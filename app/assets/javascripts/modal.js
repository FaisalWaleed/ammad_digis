// Clean up modals when they close
$(document).on('hide.bs.modal', '.modal', function(e) {
  if(keepModalOpen){
    e.preventDefault();
    e.stopImmediatePropagation();
    dsDialog.show({type: 'alert', title: 'Files are in your queue', message: "Uploads must be completed before leaving this screen. If you want to cancel the upload, remove all files from the queue."});
    return false; 
  }
  if(modalEdited){
    e.preventDefault();
    e.stopImmediatePropagation();
    dsDialog.show({type: 'warning', title: 'There are unsaved changes', message: "If you would like to leave this screen without saving your changes, click Continue.", callback: closeModal, target: $('body .modal')});
    return false; 
  }
  $(this).removeData('bs.modal');
  //   $(this).find('.modal-content').html('');
  if($('#dg-add-patient').length) {
    $('#dg-add-patient #error_explanation').html('');
    $('#dg-add-patient form')[0].reset();
  }
});

$(document).on('shown.bs.modal', '#dg-add-patient', function(e) {
  var $form = $('#dg-add-patient form.patient-data');
  var $submit = $form.find('.submit-btn');

  var $patientName = $('input#prescription_patient_name').val();

  if ($patientName.length > 0) {
    $patientName = $patientName.split(' ');

    $form.find('input.firstname').val($patientName.shift());
    $form.find('input.lastname').val($patientName.pop());
    $form.find('input.middlename').val($patientName.join(' '));
  }

  if ($form.length > 0) {

    if ($submit.length > 0) {

      $submit.on('click', function(e) {
        e.preventDefault();

        var data = $form.serialize();
        var url = '/physician/prescription/add_patient';

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
              $('#dg-add-patient #error_explanation').html(result)
            },

            200: function(result) {
              $('#client-ui').html(result);
              $('#prescripts .add_fields').trigger('click');
              $('#dg-add-patient').modal('hide');
            },
          }
        });
      })

    }
  }
})

var closeModal = function(elem){
  modalEdited = false;
  $(elem).modal('hide');
}

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
    // focus message input
    $(modal_state.current).find('textarea').eq(0).focus();
  },
  getview = function(t) {
    modal_state.current = $(t).data('target');
    modal_state.previous = '#' + $(t).parents('._template').attr('id');
  }

$(document).off('click', '.modal ._nav').on('click', '.modal ._nav', function(e) {
  e.preventDefault();
  getview(this);
  buildview();
});

$(document).off('click', '.modal .back').on('click', '.modal .back', function(e) {
  e.preventDefault();
  if($(this).data('prev')){
    modal_state.previous = $(this).data('prev');
  }
  buildview(true);
});

// UPDATE PRESCRIPTION STATE
$(document).off('click', 'a.action.update-prescription-status').on('click', 'a.action.update-prescription-status', function(e) {
  e.preventDefault();
  var $self = $(this);
  var url = $self.data('url');
  var $modal = $('#dg-pharm-prescription');
  var params = {};
  var state = $self.data('state');

  //if (state == 'open' || state == 'ready') {
    // DONT FORGET TO ADD DOSAGE AMOUNT FIELD
    params = $modal.find('#dispense-order-form').serialize();
  //}

  $.ajax({
    url: url,
    type: 'POST',
    data: params,

    success: function(result) {
      $.ajax({
        url: window.location.href,
        type: 'GET',
        success: function(data) {
          poller.poll();
        }
      });
      $modal.modal('hide');
    }
  })
});

$(document).off('click', 'a.action.fill-prescription').on('click', 'a.action.fill-prescription', function(e) {
  e.preventDefault();
  var $self = $(this), $modal = $('body #dg-pharm-prescription'), $form = $modal.find('#dispense-order-form'), url = $form.attr('action');
  var params = {}, state = $self.data('state');

  //if (state == 'open' || state == 'ready') {
    // DONT FORGET TO ADD DOSAGE AMOUNT FIELD
    params = $form.serialize();
  //}
  
  // alert(url);
  if(!validate_form({form: $form, mode: 'each'})){
    dsDialog.show({type: 'alert', title: 'Error', message: "You must fill out the fields higlighted in red before filling this prescription."});    
  }else{
    $.ajax({
      url: url,
      type: 'POST',
      data: params,

      success: function(result) {
        $modal.modal('hide');    
        Turbolinks.visit(window.location.href);
      }
    });    
  }
  
});

// PRESCRIPTION MODAL - TRANSFER HANDLER
$(document).off('click', 'a#transfer_prescription.action').on('click', 'a#transfer_prescription.action', function(e) {
  e.preventDefault();
  var $form = $('form#new_dispense_order');
  if(!validate_form({form: $form, mode: 'each'})){
    dsDialog.show({type: 'alert', title: 'Error', message: "You must fill out the fields higlighted in red before making this transfer."});    
  }else{    
    var $self = $(this);
    var $target = $('#dg-pharm-prescription');    
    var params = $form.serialize();
    var url = $form.attr('action');

    $.ajax({
      url: url,
      type: 'POST',
      data: params,

      success: function(result) {
        setup_autocomplete($target.find('.modal-content').html(result).find('[data-autocomplete]'));
        //buildview();
        poller.poll();
      }
    });
  }
});

$(document).on('click', '[data-target="#pharm-transfer-template"]', function(e) {
  e.preventDefault();

  var t = this;
  var $self = $(t);
  var $target = $('#dg-pharm-prescription'), $form = $target.find('#dispense-order-form');
  if(!$form.find('.list-item ._line-item-id:checked').length){
    dsDialog.show({type: 'alert', title: 'Error', message: "You must select the line items that you would like to transfer before continuing."});    
  }else{  
    var params = {
      dispense_order: {
        dispensable_ids: [],
      }
    }
    var prescription_id = $('input[name="dispense_order[prescription_id]"]');
    params.dispense_order.prescription_id = prescription_id.val();
    var url = $self.data('url'), id = '';
    
    $form.find('.list-item ._line-item-id:checked').each(function(){
      id = $(this).data('id');
      params.dispense_order.dispensable_ids.push(id);
    });

    console.dir(params);

    $.ajax({
      url: url,
      type: 'GET',
      data: params,

      success: function(result) {
        setup_autocomplete($target.find('.modal-content').html(result).find('[data-autocomplete]'));
        getview(t);
        buildview();
      }
    });
  }
});

// Modal Awesomeness
$(document).on('show.bs.modal', '[data-remote="true"]', function(ev) {

  var $modal = $(this);
  var loadingMessage = '<div class="modal-loading"><p>Fetching Data</p></div>';
  if (!$modal.find('.modal-loading').length) {
    $modal.find('.modal-content').prepend(loadingMessage);
  }
  // Add a loader  
  $modal.find('.modal-ready').hide();
  $modal.find('.modal-loading').show();
  // Get the trigger element
  var $trigger = $(ev.relatedTarget);
  // Pull prescription id
  var id = $trigger.data('resource-id');
  // Pull show view's url
  var url = $trigger.data('url');
  // Set up AJAX
  var data = {};

  var result = $.ajax({
    url: url,
    type: 'GET',
    data: data

  }).done(function(result) {
    // Populate Modal       
    $modal.find('.modal-content').html(result); // will need to update this so that all modals load at once
    // Remove loader
    $modal.find('.modal-loading').fadeOut('fast');
    $modal.find('.modal-ready').fadeIn('slow');
    $(document).trigger('dg.modal.ready');
    if($modal.find(".modal-ready #_prescript-message").length){
      $modal.find(".modal-ready textarea").eq(0).focus();
    }
  }).fail(function(jqXHR, status) {
    $modal.find('.modal-loading').html('An error has occurred.').show();
    console.log('Request failed: ' + status);
  });
});

$(document).off('dg.modal.ready').on('dg.modal.ready', function() {
  if (typeof fileUploader.destroy == 'function') {
    fileUploader.destroy();
    console.log('Dropzone destroyed');
  }
  var $target = $('._file-data-ui ._main-field');
  if($target.length){
    buildDropzone({
      elem: $('._file-data-ui ._main-field'),
      maxFiles: 10,
      type: 'multi'
    });
  }
});

$(document).off('upload_processed').on('upload_processed', function() {
  //console.log('triggered upload_processed');
  var $form = $("#tech-upload-template form");
  var data = $form.serialize();
  //console.log('form data: '+data);
  var url = $form.attr('action');
  $("#tech-upload-template").addClass('_wait');
  $.ajax({
    url: url,
    type: 'POST',
    data: data,

    error: function(result) {
      console.log('an error has occurred...');
    },

    complete: function() {
      //console.log('all done...')
    },

    statusCode: {
      299: function(result) {
        // ERROR HTML
      },

      200: function(result) {
        // SUCCESS HTML 
        console.log('FORM SAVED');
        modalEdited = false;
        $('#tech-upload-wrapper').html(result);
        $('#tech-upload-template').removeClass('_remove _upload-ready _form-changed').addClass('_upload-complete');
        $(document).trigger('dg.modal.ready');
        //$('.modal').modal('hide');
        //$parent.find('._feedback-ui p').text('Re-open modal to view changes');
      }
    }
  });
}); 

$(document).off('click', '#tech_upload_result').on('click', '#tech_upload_result', function(e) {
  //console.log('processing queue');
  $(this).addClass('hidden');
  e.preventDefault();
  e.stopPropagation();
  $('.modal').trigger('dg.prepareFrom');
});

$(document).on('change input', "#tech-upload-template form",function(){
  modalEdited = true;
  $('#tech-upload-template').addClass('_form-changed').removeClass('_upload-complete');
});

