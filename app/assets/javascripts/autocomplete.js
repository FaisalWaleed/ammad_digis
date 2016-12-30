
// DELETE TABLE ITEMS
var allowDefault = function(e){
   $.rails.confirmed(e);
};

//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  if(link.data('no-link') == true){
    link.trigger("click");
    return true;
  }
  link.trigger("click.rails");
}
//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var type = link.data("confirm");
  dsDialog.show({type: type, callback: allowDefault, target: link, message: "Are you sure you want to delete this?"});
}

// End Override the default confirm dialog by rails

$(document).on('cocoon:after-insert', function(e, item) {
  setup_autocomplete($( item ).find("input:first").trigger('click'));
});  

$(document).on('cocoon:after-remove', function(e, item) {
  item.parents('form').trigger('change');
});

/* $(document).on('cocoon:after-remove', function(e, item){
  save_drug_items(e,item);   
}); */

$(function() {
  setup_autocomplete($('[data-autocomplete]'));
});

$(document).on('page:load page:change', function(event) {
  setup_autocomplete($('[data-autocomplete]'));
});

function setup_autocomplete(elements) {
  
  $.each(elements, function(i, el) {
    var $el = $(el);
    var type = $el.attr('data-param');
    var url = $el.data('url') || "/search";
    if(type){
      url += "?test_type_ids[]="+type;
    }
    var target = $el.next();
    
    $el.autocomplete({
      appendTo: $el.attr('data-parent'),
      source: function( request, response ) {
        var term = request.term;
        var $this = $(this);
        
        $.getJSON( url, request, function( data, status, xhr ) {
          response( data );
        });
      },
      
      minLength: 1,
      
      select: function( event, ui ) {
        target.val(ui.item.id);
        target.trigger('change', ui.item);
        $el.trigger('complete', ui.item.label);       
        $el.val(ui.item.value); 
        $el.trigger('blur'); 
        /* navigate to the selected item's url
        window.open(ui.item.url); */
      }     
    })
    .data("ui-autocomplete")._renderItem = function(ul, item) {
      var item_template_element = $($el.attr('data-item-template'));
      var item_template = '';
      
      if(item_template_element.length) {
        item_template = $(item_template_element.html());
      }
      else {
        item_template = $( "<div>" ).text( item.label ); // default behaviour if no template found
      }
      
      $.each(item, function(key, val) {
        item_template.find('.__' + key).text(val);
      })
      
      return $("<li>").append(item_template).appendTo(ul);
    };
  })
}

function save_drug_items(e,t) {
  
  var $this = $(t);
  
  var $form = $this.parents('form');
  var $wrapper = $this.parents('#prescription_form');

  var url = '/physician/prescription/set_drug';
  var data = $form.serialize();
  
  $.ajax({
    url: url,
    type: 'POST',
    data: data,
    
    error: function(result) {
      console.log('an error has occurred...')
    },
    
    complete: function() {
      console.log('all done...')
    },
    
    statusCode: {
      299: function(result) {
        //
      },
      
      200: function(result) {   
        setup_autocomplete($wrapper.html(result).find('[data-autocomplete]'));
        $wrapper.find("select:not([multiple^=multiple])").select2({minimumResultsForSearch: Infinity});
        $wrapper.find("select:not([multiple^=multiple])").on('change', function(){
            $(this).trigger('blur');
        });        
        $wrapper.find('._prescript-ui ._prescript-item').eq(drugItem.line).trigger('click');
      },
    }
  });
}

function new_Suggestion(suggest, value) {
  var _suggest = suggest.parents('._suggest');  
  
  value = value || suggest.val().replace(/,/g, '').trim();
      
  var count = $(_suggest).find('._selected input').filter(function(){return this.value.trim() == value}).length;
  
  if(count > 0){
    return false;
  }  
  return true;
}

function add_suggest(suggest, value) {
  if(new_Suggestion(suggest, value)){  
    var _suggest = suggest.parents('._suggest');
    var fieldName = _suggest.attr('data-name');      
    
    value = value || suggest.val().replace(/,/g, '').trim();
    
    var vc = $('<div class="vc">');
    var vl = $('<div class="vl">').text(value);
    var vx = $('<div class="vx">');
    var input = $('<input type="hidden">').attr('name', fieldName).val(value);
    
    suggest.siblings('._selected').append(vc.append(vl.append(vx)).append(input));
    
    _suggest.trigger('change');
    setTimeout(function(){ suggest.val('') }, 200);
    console.log('after clear event'); 
  }else{
    setTimeout(function(){ suggest.val('') }, 200);
  }  
}

function setup_suggests() {
  $('._suggest').each(function(){
    var $e = $(this);
    var $input = $(this).find('textarea');
    $e.find('.va').on('click',function(){
      $e.addClass('_edit');
    });

    $input.off('keyup').on('keyup', function(evt) {
      if($e.hasClass('_edit')){      
        if (evt.keyCode == 13 || evt.keyCode == 188) {
          evt.preventDefault();
          add_suggest($input);
        }
      }
    })
    .off('complete').on('complete', function(evt, value) {
      if($e.hasClass('_edit')){   
        add_suggest($input, value);
      }
    });
    console.log('suggestions are ready.');
  });  
}

$(document).on('suggest', function(){
  setup_suggests();
});


function remove_suggest(e) {
  var _suggest = e.parents('._suggest');
  e.parents('.vc').remove();
  _suggest.trigger('change');
  return true;
}

function remove_option(e) {
  var id = e.data('id');
  var $option = $("._option input[data-id='"+id+"']").prop('checked',false);
  $option.trigger('change');
  return true;
}

function verify_checkbox(elem){
  if($(elem).is(':checked') || $(elem).not('input')){
    var type = $(elem).attr('data-type') || '';
    var $form = $('#ds-verify form');
    
    $form.find('._ds-field').removeClass('hidden');
    if(type != ''){
      $form.find('._ds-field').not("[data-type='"+type+"']").addClass('hidden');
    }   
    
    dsDialog.show({type: 'verify', callback: verifyCode, target: $(elem), progress: true});
  }  
}

// REMOVE CONDITION / ALLERGY
$(document).on('click', '._selected .vc .vx', function(e) {
  if($(this).parents('.vc').data('id')){
    dsDialog.show({type: 'delete', callback: remove_option, target: $(this).parents('.vc'), message: 'Are you sure you want to remove this?'});
  }else{
    dsDialog.show({type: 'delete', callback: remove_suggest, target: $(this), message: 'Are you sure you want to remove this?'});
  }
});

// VERIFY PATIENT INFO
$(document).on('change', '.verify-checkbox', function(e) {
  verify_checkbox(this);
});

$(document).on('click', '.verify-info', function(e) {
  verify_checkbox(this);
});   

/* FIELD INTERACTIONS
 * highlightRequired() : highlights required fields once they have been interacted with 
 */
var highlightRequired = function($e){
  if(validate_field({element: $e}) > 0){
    return true;
  }else{
    return false;
  }
}

/* VERIFY ENTERED CODE
 * verifyCode() : This does a complete form submit, i.e. the phone, email and code fields to the verifaction url
 */
var verifyCode = function($e){
  var $form = $('#ds-verify form');
  var verified = false;
  var ready = false;  
  
  $form.find('._code-field').each(function(){
    if( !$(this).parent('._ds-field').hasClass('hidden') ){
      verified = $(this).attr('data-verified');
      if(verified != 'false' || $(this).hasClass('ds-valid')){
        ready = true;
        return false;
      }
    }
  });
  
  if(ready){
    dsDialog.close(); 
    $form.find('._msg').hide();      
    
    var url = $form.attr('data-verification');
    var data = $form.serialize();  
  
    if(url != ''){
      $.ajax({
        url: url,
        type: 'POST',
        data: data,
        
        error: function(result) {
          console.log('an error has occurred...');
          dsDialog.show({ type: "fail", message: "Validation was unsuccessful." });
        },
        success: function(){
          console.log('task successful');         
          $e.off("change","**");
          dsDialog.show({ type: "alert", title: 'Success', message: "Validation was successful." });
        }, 
        complete: function() {
          console.log('complete...');
        },
        
        statusCode: {
          200: function(result) {
          }
        }
      });
    } 
  }else{
    $form.find('._msg').show().text('Missing verification code.');
  }
}

/* CODE UI 
 def $v: validated field
 */
$(document).on('click', '._code', function(e) {
  e.preventDefault();
  var $this = $(this);
  var $elem = $this.parents('._ds-field');
  var $input = $elem.find('._ds-validate');
  var $form = $this.parents('form');
  
  var url = $form.attr('data-code');
  var data = $input.serialize();
  
  // HACK
  data += '&patient_id=' + $form.data('patient-id');
  
  // AJAX GOES HERE
  // If code has been sent, add a class to the button and disable the related input field

  if(highlightRequired($input)){
    if(url != ''){
      $.ajax({
        url: url,
        type: 'POST',
        data: data,
        beforeSend: function(){
          $this.addClass('_disabled');
          $this.text('Sending...');
        },
        error: function(result) {
          $this.removeClass('_disabled');
          $this.text('Send Code');          
          console.log('an error has occurred...');
        },  
        complete: function(result) {
          $this.removeClass('_disabled');
          $this.text('Send Code');  
          console.log('Email code: '+ result.responseJSON.email_code);
          if(result.responseJSON.email_code){
            code.email = result.responseJSON.email_code;
          }
          if(result.responseJSON.phone_code){
            code.phone = result.responseJSON.phone_code;
          }
        },        
        statusCode: {
          200: function(result) {
            $input.prop('readonly',true);
            $elem.find('._full-input').addClass('_has-action');
            $this.addClass('_ready');
          },
        }
      });
    }     
  }
});

$(document).on('click', '._ds-pristine', function(e) {
  e.preventDefault();
  var $i = $(this).parents('.input-container');
  $i.find('._full-input').removeClass('_has-action'); // label
  $i.find('.required').prop('readonly',false);
  $i.find('._code').removeClass('_ready');
  $i.find('._ds-dirty').val('').trigger('change');  
});

var dsRetrieveRX = function(){
  var $form = $('#ds-getprescription form');
  var url = $form.attr('action');
  var data = $form.serialize();
  var $action = $form.find('._footer');
  
  $form.removeClass('ready');
  $action.text('Processing...');
  
    
  if(url != ''){
    $.ajax({
      url: url,
      type: 'POST',
      data: data,        
      error: function(result) {
        $form.addClass('ready');
        $action.find('._ok').text('TRY AGAIN');        
        $action.show();
      },
      success: function(){
        Turbolinks.visit('/pharmacist/prescriptions');       
      }           
    });
  } 
}

var dsRetrieveDiagnostic = function(){
  var $form = $('#ds-getdiagnostic form');
  var url = $form.attr('action');
  var data = $form.serialize();
  var $action = $form.find('._footer');
  
  $form.removeClass('ready');
  $action.hide();
  console.log('url: '+ url);
  if(url != ''){
    $.ajax({
      url: url,
      type: 'POST',
      data: data,        
      error: function(result) {
        $form.addClass('ready');
        $action.find('._ok').text('TRY AGAIN');        
        $action.show();
      },
      success: function(){
        window.location.reload();
      }
    });
  } 
}

// GET PRESCRIPTION VIA PIN
$(document).on('click', '.get-prescription', function(e) {
  e.preventDefault();
  dsDialog.show({type: 'getprescription', callback: dsRetrieveRX, progress: true});
});

// GET DIAGNOSTIC VIA PIN
$(document).on('click', '.get-diagnostic', function(e) {
  e.preventDefault();
  dsDialog.show({type: 'getdiagnostic', callback: dsRetrieveDiagnostic, progress: true});
});

$(document).on('change', '._suggest', function(e) {
  var collection = $(this).find('.vc input[type="hidden"]');
  var url = $(this).attr('data-url');      
  var params = collection.serialize();
  
  if(params.length == 0) {
    var type = $(this).attr('data-type');
    
    if(type.length) {
      params = { patient: {} };
      params['patient'][type] = [''];
    }
    else {
      alert("An unknown error has occurred. Please refresh and try again.");
      return false;
    }
  }
  
  if(url.length) {
    $.ajax({
      url: url,
      
      data: params,
      
      type: 'post',
      
      success: function(result) {
        console.log(result);
      }
    })
  }
})

// PATIENT ADDRESS 
$(document).on('click focus', '._expanded-form', function(e) {
  e.stopPropagation(); 
  var $target = $(this);
  if(!$target.hasClass('_active')){
    $target.addClass('_active');
  }
});

$(document).on('blur', "._expanded-form input, ._expanded-form select", function(e) {
  e.stopPropagation(); 
});

$(document).on('blur', '._expanded-form', function(e){
  alert('left');
  $(this).removeClass('_active');
});

$(document).on('change input', "._expanded-form input, ._expanded-form select", function(e) {
  e.stopPropagation();  
  var $parent = $(this).parents("._expanded-form");
  var text = '';
  var $targets = $parent.find("input, select");
  var $textField = $parent.next('input');
  $targets.each(function(i){
    i++;
    var c = $(this).val().trim();
    if(c){
      text += c;
      if(i != $targets.length){
        text += ', ';
      }
    }
  });
  $textField.val(text);
  $textField.trigger('input');
});

// EXISTING PATIENTS
$(document).on('change', 'input#patient_id', function(e) {
  var $this = $(this);
  var url = 'set_patient';
  var $form = $this.parents('form');
  var data = $form.serialize();
  
  console.log(data);
  $('#client-header').addClass('_minimize');
  
  var promptText = $('#client-content').find('._prompt').html();
  
  $('#client-content').find('._prompt').html('Fetching patient details...');

  $.ajax({
    url: url,
    type: 'GET',
    data: data,
    
    error: function(result) {
      console.log('an error has occurred...');
      $('#client-content').find('._prompt').html(promptText);
      $('#client-header').removeClass('_minimize');
    },
    
    complete: function() {
      console.log('all done...');
    },
    success: function(result) {
      Turbolinks.visit(result.redirect_url);
    }
  });
})

// NEW PATIENTS

/* NO LONGER NEEDED - CAN BE REFACTORED TO PATIENT ID
$(document).on('change input', '.profile-info input', function(e) {
  var $this = $(this);
  var $form = $('#new_prescription');
  var name = $this.attr('name');
  var value = $this.val().trim();
  var $target = $form.find('input[name="'+name+'"]');
  if($target.length){
    $target.val(value);
  }else{
    $('<input type="hidden" />').attr({name: name, value: value}).appendTo($form);
  }  
}) */

$(document).on('click', 'form.ready a#set_patient', function(e) {
  e.preventDefault();
  var $this = $(this);
  var $form = $this.parents('form');
  var data = $form.serialize();
  var url = 'add_patient';
  var inprogress = false;
  $this.addClass('_disabled');
  
  $('#client-header').addClass('_minimize');
  
  var promptText = $('#client-content').find('._prompt').html();
  
  $('#client-content').find('._prompt').html('Fetching patient details...');
  
  /* console.log('Serialized: '+ data);
  return false; */
  if(!inprogress){
    inprogress = true;
    $.ajax({
      url: url,
      type: 'POST',
      data: data,
      
      error: function(result) {
        console.log('an error has occurred...');
        $this.removeClass('_disabled');
        $('#client-content').find('._prompt').html(promptText);
        $('#client-header').removeClass('_minimize');        
      },
      
      complete: function() {
        console.log('all done...');
        inprogress = false;
      },
      success: function(result) {  
        Turbolinks.visit(result.redirect_url);
      }
    }); 
  }
})

/* =================================== */

$(document).on('keyup', 'input[name="prescription[pharmacy_name]"]', function(e) {
  $('input[name="prescription[pharmacy_id]"]').val(null).trigger('change');
})

// MOVED PHARMACY ID VALIDATION TO CORE JS - @ validate_form();

$(document).on('click', 'form.ready #prescription_set_pharmacy', function(e) {
  e.preventDefault();
  //console.log('Debug: clicked set_pharmacy link');
  
  var $this = $(this);
  
  var $form = $this.parents('form');
  var url = '/physician/prescription/set_pharmacy';
  
  var pharmacy_id = $form.find('#prescription_pharmacy_id').val();
  var prescription_id = $form.find('#prescription_id').val();
  var send_to_patient = ($form.find('#prescription_send_to_patient:checked').val() || '0');
  var allow_generic = ($form.find('#prescription_allow_generic:checked').val() || '0');  
  
  var insurer_ids = $form.find('._select._multiple._insurer_ids input[type="checkbox"]:checked').map(function() {
    return this.value
  }).get();

  /* if(!(pharmacy_id && prescription_id && insurer_id)) {
    alert('Please ensure that you have selected both a pharmacy and insurer before continuing.');    
    console.log(pharmacy_id, prescription_id, insurer_id)
    return false;
  } */
  
  var data = {
    pharmacy_id: pharmacy_id,
    prescription_id: prescription_id,
    insurer_ids: insurer_ids,
    send_to_patient: send_to_patient,
    allow_generic: allow_generic
  }

  $.ajax({
    url: url,
    type: 'POST',
    data: data,
    
    error: function(result) {
      console.log('an error has occurred...')
    },
    
    complete: function() {
      console.log('all done...')
    },
    success: function(result) {
      console.dir(result);
      if(result.prescription.send_to_patient == '1'){
        dsDialog.show({type: 'warning', title: 'Prescription Sent', message: "The prescription was successfully sent to the patient.", target: result.redirect_url, callback: Turbolinks.visit});       
        return false;
      }
      Turbolinks.visit(result.redirect_url);
    }    
  });
})

$(document).on('change', 'input[type="hidden"].prescript-drug-id', function(e){
  drugItem.line = $(this).parents('._prescript-ui ._prescript-item').index('._prescript-item');  
  save_drug_items(e,this); 
});


