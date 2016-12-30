(function($) {
  $(document).ready(function() {
    //initDOM();
  });

  $(document).on('page:change', function(e) {
    initDOM();
  })

  $('document').on('hidden.bs.modal', '.modal', function() {
    $(this).find('.modal-body').html('');
  });
  
  var hideAfter = function($elem,time){
    setTimeout(function(){
      $elem.fadeOut(500);
    }, time);
    $elem.remove();
  }

  // (RE)INITIALIZE DOM
  var initDOM = function() {
    console.log("Initializing DOM");
    
    hideAfter($('#notice._msg'),5000); // Destroy notice messages.
    $(document).trigger('suggest');
    // Show hidden content (inner fields)
    
    if(jQuery().placeholder) {
      $('input, textarea').placeholder();
    }    
    
    $('input[type=text][data-cms-date]').datetimepicker({
      format: 'YYYY-MM-DD', useCurrent: false
    }); 
    
    $('._date').inputmask('99/99/9999');
    $('._tel').inputmask('(999) 999 9999', {autoUnmask: true});
    $('._credit').inputmask('9999 9999 9999 9999',{autoUnmask: true});
    $('._cvv').inputmask('999',{autoUnmask: true});    
    
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
      link.trigger("click.rails");
    }
    //Display the confirmation dialog
    $.rails.showConfirmationDialog = function(link){
      var type = link.data("confirm");
      dsDialog.show({type: type, callback: allowDefault, target: link, message: "Are you sure you want to delete this?"});
    }
        
    $('input[type=text][data-cms-date]').datetimepicker({
      format: 'DD-MM-YYYY', useCurrent: false
    });
    
    $('._ui-toggle ._handle').on('click focus',function(){
      var $t = $(this);
      $t.find('input').prop('checked', true);
      $t.addClass('_checked');
      $t.siblings().removeClass('_checked');
    });

    /*
     * CREATE PRESCRIPTIONS
     */
    $('#content-nav .nav-ui').on('click', 'span', function(e) {
      e.preventDefault();
      var $elem = $(this).parent('li');
      var parent = $elem.data('name');
      if (parent != tabs.state.previous && !$elem.hasClass('_disabled')) {
        $elem.addClass('_active');
        $elem.siblings().removeClass('_active');
        tabs.handler(parent);
      }
      else if($elem.hasClass('_submit-trigger')){
        var form = $elem.attr('data-target');
        try{
          if(form != ""){
            $(''+form+'').trigger('submit');
          }else{
            throw new Error('Target not defined');
          }
        }catch(e){
          console.log(e);
        }
      }
    });
        
    // Show image previews for all other upload fields 
    $('._input-group').each(function() {
      var image = this;
      $(image).fileapi({
        url: '/fileapi',
        accept: 'image/*',
        imageSize: { minWidth: 128, minHeight: 128 },
        multiple: false,
        clearOnSelect: false,
        clearOnComplete: false,
        elements: {
          preview: {
            el: '._image-holder',
            width: 128,
            height: 128
          }
        },
        onSelect: function (evt, ui){
          if( !FileAPI.support.transform ) {
            alert('Your browser does not support Flash :(');
          }
        }        
      });     
    });        
  }
  
  $(document).on("click", "._menu-toggle", function(e) {
    e.preventDefault();
    $('#admin-sidebar').toggleClass('_menu-active');   
  });  
    
  $(document).on("click", ".list-item ._show-more", function(e) {
    e.preventDefault();
    var $parent = $(this).parents('.list-item');
    $(this).toggleClass('_active');
    $parent.find('._more').slideToggle('fast');
  });

  // Show file hidden content 
  $(document).on("click", ".section ._show-more-global", function(e) {
    e.preventDefault();
    $(this).toggleClass('_active');
    $('._more').slideToggle('fast');
  });

  // Show file hidden content 
  $(document).on("click", "._expandable ._parent ._control", function(e) {
    e.preventDefault();
    $(this).toggleClass('active');
    var $parent = $(this).parents('._expandable'),
      id = $(this).data('id');
    $parent.find('._child[data-id=' + id + ']').each(function() {
      $(this).fadeToggle();
    });
  });
  
  // Show file hidden content - hide controls
  $(document).on("click", "._expandable ._parent ._switch", function(e) {
    e.preventDefault();
    $(this).toggleClass('hidden');
    var $parent = $(this).parents('._expandable');
    $parent.find('._child').each(function() {
      $(this).fadeToggle();
    });
  });
  
  $(document).on("click", "._option-group ._touch", function(e) {
    e.preventDefault();
    $(this).parents('._option').fadeToggle({complete: function(){
      $(this).siblings('._option').fadeToggle(); 
    }}); 
  });  
  
  $(document).on("click", "._editable ._edit", function(e) {
    e.preventDefault();
    $(this).toggleClass('hidden');
    var $parent = $(this).parents('._editable');
    $parent.find('._input').each(function() {
      $(this).fadeToggle();
    });
  });  
  
  $(document).on('blur input keyup', 'form .required', function(e) {
    var $form = $(this).parents('form');    
    validate_form({form: $form, element: this});   
  });
  
  // Validate Form on submit  
  $(document).on('click', 'form:not(.ready) ._submit', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    if(!validate_form({form: $form, callback: 'click', mode: 'each'})){
      dsDialog.show({type: 'error', message: 'There are a few errors in your form.'});
    }
  })    
  
  $(document).on("click", ".action.submit", function(e) {
    e.preventDefault();

    var target = $(this).attr('form');
    var $form = $('form.data-form');

    if (target) {
      $form = $('form' + target + '');
    } else {
      $form = $('form.data-form');
    }

    $form.trigger('submit');
  });


  $(document).on('change', 'select#current_pharmacy', function(e) {
    var loc = window.location.href.replace(/&?current_pharmacy=.*&?/, '');

    if (loc.indexOf('?') == -1) loc += '?';

    window.location.href = loc + '&current_pharmacy=' + $(this).val();
    // window.location = window.location + '?current_pharmacy=' + $(this).val();
  });

  // PRESCRIPTION MODAL FUNCTIONS
  
  var modal_state = {
    current: '',
    previous: ''
  }

  var buildview = function(b) {
      if (b) {
        var c = modal_state.current;
        modal_state.current = modal_state.previous;
        modal_state.previous = c;
      }
      $(modal_state.current).removeClass('_remove');
      $(modal_state.previous).addClass('_remove');
    },
    getview = function(t) {
      modal_state.current = $(t).data('target');
      modal_state.previous = '#' + $(t).parents('._template').attr('id');
    }

  $(document).on('click', '.modal ._nav', function(e) {
    e.preventDefault();
    getview(this);
    buildview();
  });

  $(document).on('click', '.modal .back', function(e) {
    e.preventDefault();
    buildview(true);
  });
  
  // PREVENT SUBMIT IF FIELD ISNT POPULATED
  $(document).on('keyup', '.allow-submit', function(){
    var $submit = $(this).parents('form').find('.action');
    if($(this).val() != ''){
      $submit.removeClass('_disabled').addClass('_focus');
    }else{
      $submit.removeClass('_focus').addClass('_disabled');
    }
  }); 

  
  $(document).on('keyup', '.allow-submit-inline', function(){
    var $formSubmit = $(this).parents('form').find('input[type="submit"]');
    if($(this).val() != ''){
      $formSubmit.prop('disabled',false).removeClass('_disabled').addClass('_focus');
    }else{
      $formSubmit.prop('disabled',true).removeClass('_focus').addClass('_disabled');
    }
  });   

  // CHECK FOR STATE
  $(document).on('change','.dosage_fields .dosage_frequency select',function(){
    var $t = $(this);
    var o = $t.val().trim();
    var $e = $t.parents('.dosage_fields').find('.disable_on_stat');
    console.log('selected: '+o);
    if(o && o == '1'){
      $e.hide();
    }else{
      $e.show();
    }
    return false;
  });
  
  $(document).on('keyup', '._filter', function(){
    var $t = $(this);
    var term = $t.val().toLowerCase();
    var target = $t.data('target');
    $(target).find('label .name').filter(function(){
      var text  = $(this).text().toLowerCase();
      if(text.indexOf(term) == -1){
        $(this).parents('label').addClass('hidden');
      }else{
        $(this).parents('label').removeClass('hidden');
      }
    });
  });  
  
  $(document).on('change', '._toggle', function(){
    var id = $(this).children(":selected").text().toLowerCase();
    var $target = $("._panel[data-name='"+id+"']");
    if($target.length){
      if(!$target.hasClass('_active')){
        $target.addClass('_active');
        $target.siblings('._panel').addClass('_remove').removeClass('_active');
        $target.removeClass('_remove');
      }
    }else{
      $("._panel").addClass('_remove').removeClass('_active');
    }
  });   
  
  // PRINT HANDLER
  $(document).on('click', '#print', function(e) {
    e.preventDefault();
    window.print();
  });

})(jQuery);
