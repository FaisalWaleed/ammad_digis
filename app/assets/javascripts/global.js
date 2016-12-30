var environment = 'production';

var poller = '';

// SET POLLER TIMEOUTS
var refresh = {
  'msg': 60000,
  'table': 30000
}

if(environment == 'production'){
  refresh.msg = 3000;
  refresh.table = 4000;  
}

// CREATE TABS STATE OBJECT

var keepModalOpen = false;
var modalEdited = false;

var tabs = {
  'state': {
    current: '',
    previous: ''
  },
  'handler': function(c, p) {
    this.state.current = c;
    $(p).addClass('_remove');
    $(p + this.state.current + '').removeClass('_remove');
    this.state.previous = this.state.current;
    return true;
  },
  'setNav': function(c) {
    var $elem = $('._progress-ui li[data-name="' + c + '"]');
    $elem.addClass('_active');
    $elem.siblings().removeClass('_active');
    this.handler(c);
    return true;
  }
}
var messageViewed = false;

// Store codes   
var code = {
  email: '',
  phone: ''
}


// ENABLE DATA TABLES TABBED SEARCH    
var prescription = {
  state: '',
  count: ''
}

// ENABLE DATA TABLES TABBED SEARCH    
var drugItem = {
  line: 0
}

// ENABLE CROSS SCRIPT USE OF TERMS. Can be used for abitrarily storing data for search boxes etc.    
var term = {
  search: {
    table: ''
  }
}

var redirectTo = function(elem){
  window.location.href = $(elem).attr('href');
}

var previewSubmission = function(elem) {
  var $t = $(elem);
  var group = $t.data('group');
  var id = $t.data('id');
  var text = $t.siblings('.name').text();
  var targetName = $t.data('setname');
  var html = '';
  var $parent = $("._filter ._tab[data-parent='" + group + "']");
  var $target = $('._target ._selected.' + group);
  if (isChecked($t) && !$t.hasClass('_check')) {
    $t.addClass('_check');
    html = $('<span class="vc" data-id="' + id + '"><span class="vl">' + text + '<span class="vx"></span></span></span>');
    if ($target.length < 1) {
      $("<div class='_selected " + group + "'><div class='title'>" + targetName + "</div></div>").prependTo('._target').append(html);
    } else {
      $target.append(html);
    }
    if (!$parent.hasClass('_csd')) {
      $parent.addClass('_csd');
    }
    $('._target').removeClass('_empty');
  } else {
    $target.find(".vc[data-id='" + id + "']").remove();
    $t.prop('checked', false);
    $t.removeClass('_check');
    if ($target.children('.vc').length < 1) {
      $target.remove();
      if ($parent.hasClass('_csd')) {
        $parent.removeClass('_csd');
      }      
      if($parent.attr('data-mode') == 'all'){
        $parent.removeClass('_active'); 
      }
      if(!$('._target').hasClass('_empty')){
        if($('._target ._selected').length < 1){
          $('._target').addClass('_empty');
        }    
      }
    }
  }
}

/* GENERAL FORM VALIDATION
 * validate_form(f,c,t,mode) : f is the jQuery form object, c is the callback if validation is successful and t is the interacted element,
 * mode - can be blank or 'each', determines if the form should check all fields at once or individual fields.
 */
var validate_form = function(options) {
  var defaults = {
    form: '',
    callback: '',
    element: '',
    mode: '',
    hidden: true,
    tracker: 0
  };
  var config = $.extend(true, {}, defaults, options);
  var valid = false;
  var tracker = config.tracker;
  var $targets = config.form.find('input.required, select.required, textarea.required');
  
  if( config.form.hasClass('_form-required') && !$targets.length ){
    dsDialog.show({type: 'alert', title: 'Ooops', message: config.form.attr('data-form-empty')});         
    return true; // Ignore validation handlers set outside 
  }    
  
  if( config.form.hasClass('_form-has-options') && !config.form.find('._option input:checked').length ){
    dsDialog.show({type: 'alert', title: 'Ooops', message: config.form.attr('data-form-empty')});       
    return true; // Ignore validation handlers set outside
  } 

  if (config.mode != 'each' && config.element != '') {
    tracker = validate_field({
      form: config.form,
      element: config.element,
      tracker: tracker,
      hidden: config.hidden
    });
    //console.log('all tracker: '+ tracker);     
  } else {
    $targets.each(function() {
      tracker = validate_field({
        form: config.form,
        element: this,
        tracker: tracker,
        hidden: config.hidden
      });
      //console.log('each tracker: '+ tracker);
    });
    //console.log('aftr each tracker: '+ tracker);
  }

  $targets.each(function() {
    if (config.hidden) {
      if (!($(this).parents().is(':hidden') || ($(this).parents('._ignore, ._remove').length > 0))) {
        if (!$(this).hasClass('ds-invalid') && !$(this).hasClass('ds-valid')) {
          //console.log('hasnt been validated');
          tracker = -1;
          return false;
        }
        if ($(this).hasClass('ds-invalid')) {
          tracker = -1;
          return false;
        }
      }
    }
  });
  //console.log('after all loop tracker: '+ tracker);  

  if (tracker >= 0) {
    valid = true;
  }
  
  if (valid) {
    config.form.addClass('ready');
    if (config.callback !== '') {
      var $submit = config.form.find('._submit input');
      if (!$submit.length) {
        $submit = config.form.find('._submit');
        if (!$submit.length) {
          config.form.submit();
        }
      }
      $submit.trigger('' + config.callback + '');
    }
  } else {
    config.form.removeClass('ready');
  }

  return valid;
}

var validate_field = function(options) {
  var defaults = {
    form: '',
    element: '',
    tracker: 0,
    hidden: true
  };
  var config = $.extend(true, {}, defaults, options);
  var $elem = $(config.element);
  var optional = false;
  var iVal = '';
  var date = {
    rule: 0,
    years: ''
  };
  var temp = false;
  var $ui = $elem;
  var size = '';
  var error = $ui.next('.form-helper').attr('data-error');

  tracker = parseInt(config.tracker);

  // Check if field is required - skips if it isnt - _optional is needed to bypass this check
  if (!$elem.hasClass('required') && !$elem.hasClass('_optional')) {
    if (tracker >= 0) {
      tracker = 1;
    }
    return tracker;
  }
  // Ignore if fields are hidden in a container
  if (config.hidden) {
    if ($elem.parents().is(':hidden') || ($elem.parents('._ignore, ._remove').length > 0)) {
      return tracker;
    }
  }

  if ($elem.hasClass('ds-autocomplete')) {
    if (!isChecked($elem)) {
      $elem.siblings('input:hidden').first().val('');
    }
    $elem = $elem.siblings('input:hidden').first();
  }

  // Append fields to object
  iVal = $elem.val();

  if (isChecked($elem)) {

    if (tracker >= 0) {
      tracker = 1;
    }

    temp = true;

    if ($elem.hasClass('_name-field')) {
      temp = validate_Name(iVal);
    } else if ($elem.hasClass('_email') || $elem.prop('type') == 'email') {
      temp = validate_Email(iVal);
      if (temp) {
        // Prevents multiple calls to server
        if ($elem.hasClass('_cloud') && !config.form.hasClass('ds-email-valid')) {
          temp = false; // this here invalidates the form :(
          account_Exists($elem, iVal);
          $elem.next('.form-helper').text("Checking email address.");
        }
      } else {
        $elem.next('.form-helper').text("Your email is required. This isn't a valid email.");
      }
    } else if ($elem.hasClass('_password') && $elem.prop('type') == 'password') {      
      temp = validate_Password($elem, iVal);
    } else if ($elem.hasClass('_confirm-password') && $elem.prop('type') == 'password') {
      temp = confirm_Password(config.form, iVal);
    } else if ($elem.hasClass('_age')) {
      if (moment(iVal, "DD/MM/YYYY", true).isValid()) {
        //console.log('valid date: '+iVal);
        temp = validate_Age($elem.attr('data-rule'), iVal);
      } else {
        console.log('invalid date: '+iVal);
        temp = false;
      }
    } else if ($elem.hasClass('_code-field')) {
      temp = validate_Code($elem, iVal);
    } else if ($elem.hasClass('_tel')) {
      temp = validate_str_Length(10, iVal);
    } else if ($elem.hasClass('_credit')) {
      temp = validate_Card(iVal);
    } else if ($elem.hasClass('_cc-month') || $elem.hasClass('_cc-year')) {
      temp = validate_Card_Exp(config.form);
    } 
    
    size = $elem.attr('data-size');
    if (typeof size !== typeof undefined && size.length != 0 && size != '') {
      temp = validate_str_Length(size, iVal);
    }

    if (temp) {
      $ui.addClass('ds-valid').removeClass('ds-invalid');
    } else {
      tracker = -1;
      $ui.addClass('ds-invalid').removeClass('ds-valid');
    }

  } else {
    tracker = -1;
    $ui.addClass('ds-invalid').removeClass('ds-valid');
    if(error != ''){
      $ui.next('.form-helper').text(error);
    }
    // return false;
  }

  if ($ui.hasClass('ds-radio')) {
    if (tracker >= 1) {
      config.form.find('.ds-radio').not($ui).removeClass('ds-invalid required');
    } else {
      config.form.find('.ds-radio').not($ui).addClass('ds-invalid required').removeClass('ds-valid');
    }
  }

  if ($ui.hasClass('ds-optional')) {
    tracker = 1;
    // return true;
  }

  if (tracker < 0) {
    if ($ui.parents('._prescript-item').length > 0 && !$ui.parents('._prescript-item').hasClass('_focused')) {
      $ui.parents('._prescript-item').addClass('_focused');
    }
  }else{
    if($elem.parent().hasClass('field_with_errors')){
      $elem.unwrap();
    }
  }

  return tracker;
}

var validate_Name = function(val) {
  var valid = /^([a-zA-Z-]+ )+[a-zA-Z-]+$/;
  if (valid.test(val)) {
    return true;
  } else {
    return false;
  }
}

var isChecked = function(elem) {
  var val = elem.val();
  // For our checkbox friends
  if (elem.is(':checkbox') || elem.is(':radio') ) {
    if (elem.prop('checked') == true) {
      return true;
    } else {
      return false;
    }
  }
  // For everyone else
  if (parseInt(val) >= 1 || val != '' || elem.hasClass('_optional')) {
    return true;
  }
  return false;
}

var validate_Email = function(val) {
  var valid = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (valid.test(val)) {
    return true;
  } else {
    return false;
  }
}
var checking = false;
var account_Exists = function(elem, val) {
  if(checking){
    return false;
  }
  var $form = elem.parents('form'), url = $form.attr('action');
  if (url) {
    url += '/check-email.js?email='+val;
    delay(function() {
      checking = true;
      $.ajax({
        url: url
      }).done(function(result) {
        if (result.available) {
          $form.addClass('ds-email-valid');
          elem.addClass('ds-valid').removeClass('ds-invalid');
        } else {
          $form.removeClass('ds-email-valid');
          elem.next('.form-helper').text("This email address is already taken.");
        }
        checking = false;
      }).fail(function(result){
        var req = JSON.parse(result.responseText);
        if (req.available) {
          $form.addClass('ds-email-valid');
          elem.addClass('ds-valid').removeClass('ds-invalid');
        } else {
          $form.removeClass('ds-email-valid');
          elem.next('.form-helper').text("This email address is already taken.");
        }      
        checking = false;
      });  
    }, 1000);  
  } 
}

var validate_Age = function(min, date) {
  min = parseInt(min);
  //console.log('rule: '+ min);
  var years = parseInt(moment().diff(moment(date, "DD MM YYYY"), 'years'));
  //console.log('years: '+years);
  if (years >= min && years < parseInt(150)) {
    return true;
  } else {
    //console.log('invalid age');
    return false;
  }
}

var validate_str_Length = function(rule, str) {
  rule = parseInt(rule);
  str = str.trim().length;
  //console.log('rule: '+rule+' & string: '+str);
  if (str >= rule) {
    return true;
  } else {
    return false;
  }
}

var validate_Password = function($e, val) {
  val = val.trim();
  
  var valid = /^(?=.{8,})(?=.*([a-z].*))(?=.*([A-Z].*))(?=.*(\d.*))(?=.*([!@#$%^&*(){}_=+<,>\/\[\]\.\-\\].*))(.*)$/;
  /* /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!_<>.+-=()%*\[\]~?&])[A-Za-z\d$@$!_<>.+-=()%*\[\]~?&]{8,}$/; */

  if ($e.hasClass('_optional') && !val) {
    return true;
  }   
  
  /* if(!validate_str_Length(8, val)){
    $e.next('.form-helper').text("Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol");
    return false;
  } */
  if(!valid.test(val)){
    $e.next('.form-helper').text("Your password must contain at least 8 characters including one upper case letter, one lower case letter, a number, and a special symbol");
    return false;
  }   
  $e.next('.form-helper').text("");
  return true;    

}

var confirm_Password = function($form, val) {
  val = val.trim();
  var confirmVal = $form.find('._password').val().trim();
  if (val == confirmVal) {
    return true;
  } else {
    return false;
  }
}

var validate_Code = function($e, val) {
  var hash = $e.attr('data-type');
  val = val.trim();
  if (val == code[hash]) {
    return true;
  } else {
    return false;
  }
}

var validate_Card = function(val) {
  var valid = /^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$/;
  if (valid.test(val)) {
    return true;
  } else {
    return false;
  }
}

var validate_Card_Exp = function(form){
  var values = '', valid = true;
  var $month = form.find('._cc-month'), $year = form.find('._cc-year');
  if($month.val().trim() != '' && $year.val().trim() != ''){
    values = '01-'+form.find('._cc-month').val().trim() + '-' + form.find('._cc-year').val().trim();
    if(moment(values,"DD-MM-YYYY").isAfter(moment(),"month")){ 
      valid = true;
      $month.addClass('ds-valid').removeClass('ds-invalid');
      $year.addClass('ds-valid').removeClass('ds-invalid');
    }else{
      valid = false; 
      $month.addClass('ds-invalid').removeClass('ds-valid');
      $year.addClass('ds-invalid').removeClass('ds-valid');      
    }  
  }
  return valid;
}

/* DSALERT-UI
type, callback, target, msg
*/
var dsDialog = {
  'ui': '',
  'elem': '',
  'callback': '',
  'hasMessage': false,
  'hasAction': true,
  'message': '',
  'actionText': 'Ok',
  'config': {},
  'show': function(options) {
    var defaults = {
      type: '',
      callback: '',
      target: '',
      messsage: '',
      progress: false,
      title: ''
    };
    this.config = $.extend(true, {}, defaults, options);
    this.config.type = this.config.type.toLowerCase();
    this.ui = 'alert-container';
    this.elem = this.config.target;
    this.callback = this.config.callback;
    this.title = this.config.title;
    this.message = this.config.message;
    this.type(this.config.type);
    this.open();
  },
  'test': function() {
    console.log('Test function called');
  },
  'open': function() {
    var diag = this;
    var validated = true;
    $('#' + diag.ui + '.alert-ui .alert-dialog').addClass('_show');
    $('#' + diag.ui + '.alert-ui .alert-bg').show();

    $('#' + diag.ui + '.alert-ui ._controls').off('click', 'span').on('click', 'span', function(e) {
      e.preventDefault();
      e.stopPropagation();
      if ($(this).hasClass('_ok')) {
        if ($(this).hasClass('_submit')) {
          validated = validate_form({
            form: $(this).parents('form'),
            mode: 'each'
          });
          if (!validated) {
            return false;
          }
        }

        if (diag.elem !== undefined || diag.target !== undefined) {
          diag.callback(diag.elem);
          if (!diag.config.progress) {
            diag.close();
          }
        }
      } else {
        try {
          diag.elem.prop('checked', false);
        } catch (e) {}
        diag.close();
      }
    });
  },
  'close': function() {
    $('#' + this.ui + '.alert-ui .alert-dialog').removeClass('_show');
    $('#' + this.ui + '.alert-ui .alert-bg').hide();
    $('body').focus(); // reset focus to body
  },
  'type': function(t) {
    var title = '',
      message = '',
      action = 'Ok',
      opt = this;
    this.hasAction = true; // reset      
    switch (t) {
      case 'delete':
        title = 'Are you sure?';
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = true;
        action = 'Delete';
        break;
      case 'warning':
        title = opt.title || 'Are you sure?';
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = true;
        action = 'Continue';
        break;        
      case 'cancel':
        title = 'Are you sure?';
        message = 'Cancelling your subscription will result in your account not being automatically renewed.';
        this.hasMessage = true;
        this.hasAction = true;
        action = 'Cancel my subscription';
        break;
      case 'success':
        title = 'Success!';
        message = 'All done!';
        this.hasMessage = true;
        this.hasAction = false;
        break;
      case 'validation_failed':
        title = 'Error';
        message = 'There are a few errors in your form. These are highlighted in red. Once you are done correcting them, please try again.';
        this.hasMessage = true;
        this.hasAction = false;
        break;
      case 'help':
        title = 'Need Help?';
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = false;
        break;
      case 'upload':
        title = 'Uploading...';
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = false;
        break;
      case 'fail':
        title = 'Please try again.';
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = false;
        break;
      case 'alert':
        title = opt.title;
        message = opt.message;
        this.hasMessage = true;
        this.hasAction = false;
        break;
      default:
        opt.ui = 'ds-' + t;
        this.hasMessage = false;
        break;
    }
    if (this.hasMessage) {
      $('#' + opt.ui + '.alert-ui ._title').text(title);
      $('#' + opt.ui + '.alert-ui ._content').text(message);
      $('#' + opt.ui + '.alert-ui ._ok').text(action);
    }
    if (!this.hasAction) {
      $('#' + opt.ui + '.alert-ui ._footer').hide();
    } else {
      $('#' + opt.ui + '.alert-ui ._footer').show();
    }
  }
};

/* DSNOTIFICATION-UI
type, callback, target, msg
*/
var dsNotification = {
  'show': function(options) {
    var defaults = {
      type: '',
      callback: '',
      target: '#notice-container ._ui',
      messsage: '',
      progress: false
    };
    var config = $.extend(true, {}, defaults, options);
    config.type = config.type.toLowerCase();
    $(config.target).html('<div class="_msg ' + config.type + '">' + config.message + '</div>');
  },
  'destroy': function(options) {
    var defaults = {
      target: '#notice-container ._ui'
    };
    var config = $.extend(true, {}, defaults, options);
    $(config.target).html('');
  }
}

var fileUploader = {};

var buildDropzone = function(options) {
  console.log('building dropzone');
  var url = $(options.elem).parents('form').attr('action');
  var authtoken = $(options.elem).parents('form').find("input[name='authenticity_token']").val();
  var csrftoken = $("meta[name='csrf-token']").attr("content");
  var $zone = $(options.elem).find("._file-field");
  var $addNew = $(options.elem).find('._new-result');
  var $anchor = $(options.elem).find('._item-anchor');
  var param = $zone.attr('name');
  console.log('param: ' + param);
  var dzOptions = {};
  if (options.type == 'multi') {
    $zone = options.elem;
    dzOptions = {
      autoProcessQueue: false,
      createImageThumbnails: false,
      previewsContainer: options.elem[0],
      previewTemplate: document.querySelector('#upload_field_template').innerHTML,
      autoDiscover: false,
      paramName: param,
      url: url,
      acceptedFiles: 'application/pdf,image/png,image/jpeg',
      method: 'patch',
      uploadMultiple: true,
      maxFiles: options.maxFiles,
      parallelUploads: 10,
      init: function() {
        var _t = this;
        this.on('addedfile', function(file, xhr, formData) {
          keepModalOpen = true;
          if (_t.getQueuedFiles().length > -1) {
            $('#tech-upload-template').removeClass('_upload-complete').addClass('_upload-ready');
          }
        });
        this.on('removedfile', function(file, xhr, formData) {
          if (!_t.getQueuedFiles().length) {
            keepModalOpen = false;
            modalEdited = true;
            $('#tech-upload-template').removeClass('_upload-ready').addClass('_form-changed');
          }
        });
        this.on('maxfilesexceeded', function(file, xhr, formData) {
          _t.removeFile(file);
        });
        this.on('sending', function(file, xhr, formData) {
          formData.append('authenticity_token', authtoken);
          formData.append('csrf-token', csrftoken);
        });
        this.on('queuecomplete', function(file) {
          _t.removeAllFiles();
          $('#tech-upload-template').removeClass('_upload-ready _form-changed').addClass('_upload-complete');
          //console.log('Remove all files and processed');
          $(document).trigger('upload_processed');
          //console.log('FILES SAVED');
        });
      }
    }
  }

  fileUploader = new Dropzone($zone[0], dzOptions);
  $('.modal').off('dg.prepareFrom').on('dg.prepareFrom', function(e) {
    console.log('processing queue');
    if (fileUploader.getQueuedFiles().length) {
      console.log('num files: ' + fileUploader.getQueuedFiles().length);
      fileUploader.processQueue();
    } else {
      $(document).trigger('upload_processed');
    }
  });

}

var createDesktopNotification = function(message) {
  // app icon is set in messages partial
  if (!Notification) {
    alert('Desktop notifications not available in your browser. Try Google Chrome.'); 
    return;
  }

  if (Notification.permission !== "granted"){
    Notification.requestPermission();
  } else {
    var notification = new Notification(message.title, {
      icon: window.appIcon,
      body: message.body
    });

    notification.onclick = function () {
      // get target
      refreshNotificationsList({elem: $('._show-notifications'),target: 'messages', silent: true, show: true});
    };
    
    setTimeout(notification.close.bind(notification), 8000);
    
  }

}

var refreshNotificationsList = function(options){
  var defaults = {
    elem: '',
    silent: false,
    show: false
  };
  var config = $.extend(true, {}, defaults, options);  
  var $elem = config.elem;
  var $target = config.target;
  var pageUrl = $('body').data('msg-source');
  var template = $("#notification-message-template").html();      
  var html = '', content = '';
  
  var inProgress = true;
  $.ajax({
    url: pageUrl,
    type: 'GET',
    success: function(data) {
      inProgress = false;
      if($.isArray(data)){
        for (var i in data) {
          content = template;
          content = content.replace(/{{agency}}/g, data[i].sender.name);
          content = content.replace(/{{message}}/g, data[i].last_message);
          content = content.replace(/{{date}}/g, data[i].date);   
          content = content.replace(/{{avatar}}/g, data[i].avatar);           
          content = content.replace(/{{url}}/g, data[i].url);                
          html += content;
        }  
      }
    }
  }).done(function(){ 
    if(html != ''){
      $('#notification_list').html(html);
    }
    if(!config.silent){
      $('#client-ui').addClass('_showing-'+$target+'');     
      $elem.addClass('_active').removeClass('_changed'); 
    }
    if(config.show){
      $("#notification_list").find("> .list-item").first().trigger('click');
    }    
    messageViewed = true;        
    FaviconNotification.remove();
    inProgress = false;        
  });
}  

var prepareView = function(hash) {
  console.log('hash is: ' + hash);
  if (hash) {
    hash = $.trim(hash.substr(1));
    if (hash == 'lab') {
      $("body ._toggle[data-name='._laboratory']").trigger('click');
    } else if (hash == 'radiology') {
      $("body ._toggle[data-name='._radiology']").trigger('click');
    }
  }
  $('#client-ui').removeClass('_page-loading');
}

var delay = (function() {
  var timer = 0;
  return function(callback, ms) {
    clearTimeout(timer);
    timer = setTimeout(callback, ms);
  };
})();
