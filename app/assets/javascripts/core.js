$('html').addClass('_dg-app-ready');

NProgress.configure({
  showSpinner: false
});
var tableInterval, msgInterval;
FaviconNotification.init({
  color: '#008AFF'
});

// request permission on page load
document.addEventListener('DOMContentLoaded', function () {
  if (Notification.permission !== "granted")
    Notification.requestPermission();
});

var setUpScroll = function(){
  var headerH = $('.client-infobar .tab-header').outerHeight(true);
  var bodyH = $('.client-infobar').height();
  var $target = $(".client-infobar .tab-content");
  bodyH = bodyH - headerH - 15;
  $target.height(bodyH);
  $target.perfectScrollbar({
    suppressScrollX: true
  });
};

(function($) {
  var domReady = false;
  $(document).ready(function() {
    // initDOM();
  });

  $(document).on('page:change', function(e) {
    // Clear intervals on page change
    window.clearInterval(tableInterval);
    window.clearInterval(msgInterval);
    
    initDOM();
  });
  
  $(window).resize(function(e) {
    setUpScroll();
  });
  
  $(document).on("ready page:load page:change", function(){ 

    $form = $("#new_subscription");    

    if($form.length == 0){
      return false;
    }
    if(typeof Stripe === "undefined"){ 
      dsDialog.show({ type: "fail", message: "The payment gateway could not be reached. Please refresh this page and try again." }); 
    }else{
      Stripe.setPublishableKey($('#ds-secret').val());    
      var show_error, stripeResponseHandler, processing = false, tokenReady = false;
      $("#new_subscription input, #new_subscription select").on('change', function(){
        tokenReady = false;
        //console.log('token ready: '+tokenReady);
      });
      $form.submit(function (event) {
        if(typeof Stripe === "undefined"){
          dsDialog.show({ type: "fail", message: "The payment gateway could not be reached. Please refresh this page and try again." });         
          return false;        
        }else{
          if(tokenReady){
            return true;
          }
          if(!processing){
            processing = true;
            //console.log('processing stripe payment');
            $form.find("._progress-ui").addClass('hidden');
            $form.find("._submit").hide();
            $form.find("#ds-progressing._next").removeClass("_disabled").click(); 
            $form.find("._progress-ui ._next").toggleClass("_disabled");          
            //console.log('getting token');          
            Stripe.card.createToken($form, stripeResponseHandler);  
            return false;          
          }            
        }
      });

      stripeResponseHandler = function (status, response) {
        var token;
        if (response.error) {
          $form.find("._submit").show();
          $form.find("._progress-ui ._next").toggleClass("_disabled");     
          $form.find("._progress-ui").removeClass('hidden');          
          dsDialog.show({ type: "fail", message: response.error.message }); 
          $form.find("#ds-card").removeClass("_disabled").click();           
          processing = false;          
        } else {
          token = response.id;
          $("#new_subscription").find("input[data-stripe='cc-token']").val(token);
          //console.log('got stripe token'); 
          tokenReady = true;
          
          if(token.trim() == '') {
            tokenReady = false;
            dsDialog.show({ type: "fail", message: "A problem prevented your card being processed. Please try again." });
            
            $form.find("._submit").show();
            $form.find("._progress-ui ._next").toggleClass("_disabled");  
            $form.find("._progress-ui").removeClass('hidden');            
            $form.find("#ds-card").removeClass("_disabled").click();                 
            processing = false;                
          }else{
            //console.log('Form valid submitting');   
            $form.submit();
          }
        }
        return false;
      };
    }
  });  
  
  $(document).on('htmlLoaded', function(e) {
    
    setUpScroll();
    
    // See other variations in autocomplete.js
    $('body .verify-checkbox').on('change', function(e) {
      verify_checkbox(this);
    });          
    
  });

  var globalTable;

  // ASSIGN DATATABLES TO ALL TABLES
  var initGlobalTable = function($elem) {
    var c = '' + $elem.data('options') + '';
    var u = $elem.data('url') + '.json';
    if (c == '') {
      c = 'default';
    }  
    var opt = {
      "autoWidth": false,
      "lengthChange": false,
      "paging": false,
      "sDom": '<"top">rt<"bottom"ilp><"clear">',
      "order": [],
      'language': {
        "info": "_START_ to _END_ of _TOTAL_",
        "infoEmpty": "no entries found",
        /* "search" : "<i class='bt-icon ion ion-android-search'></i>", */
        "zeroRecords": "Nothing found",
        "paginate": {
          "first": "<<",
          "last": ">>",
          "next": " ",
          "previous": " "
        }
      }
    };

    switch (c) {
      case 'orderable':
        opt.columnDefs = [{
          "orderable": true
        }];
        break;
      case 'search-col-5-open':
        opt.searchCols = [
          null,
          null,
          null,
          null,
          null, {
            "search": "open"
          },
          null
        ];
        opt.columnDefs = [{
          "targets": 'disable-sort',
          "orderable": false
        }];
        break;
      default:
        break;
    }
    
    if(prescription.state == ''){
      prescription.state = $elem.data('default-col');
    }   

    return $elem.DataTable(opt);
  }

  var table;

  $('document').on('hidden.bs.modal', '.modal', function() {
    $(this).find('._template').html('');
  });

  var filterColumn = function(i, s , e) {
    table.search(term.search.table);
    table.column(i).search(s).draw();
  }
  
  var columnCount = function(c,$elem){
    var $t, s, info; 
    $elem.each(function() {
      $t = $(this);
      s = $t.data('state');
      table.column(c).search(s);
      info = table.page.info();
      $t.find('._msg-count').text(info.recordsDisplay);
    });      
  }
  
  var hideAfter = function($elem,time){
    setTimeout(function(){
      $elem.fadeOut(600, function() {
        $elem.remove();
      });
    }, time);
  }

  // (RE)INITIALIZE DOM
  var initDOM = function() {
    if(domReady){
      console.log('Dom already initilized');
      //return false;
    }
    console.log("Initializing DOM");
    
    $(document).find('[data-tooltip]').powerTip({
      placement: 'e'
    });     
    
    if(jQuery().placeholder) {
      $('input, textarea').placeholder();
    }      
    
    if($('#client-sidebar').length){    
      var sticky = new Waypoint.Sticky({
        element: $('#client-sidebar')[0],
        stuckClass: '_fixed'                             
      })    
    }
    
    $('._select._multiple select').multipleSelect({ placeholder: 'None', selectAll: false, countSelected: false});
    $('._select._multiple select').multipleSelect('uncheckAll');
    
    $("body select:not([multiple^=multiple])").select2({minimumResultsForSearch: Infinity});
    $("body select:not([multiple^=multiple])").on('change', function(){
        $(this).trigger('blur');
    });
    
    hideAfter($('#notice-container ._msg'),7000); // Destroy notice messages.
    
    $(document).trigger('suggest');
    // Show hidden content (inner fields)

    if ($('.table._searchable').length) {
      console.log('why are you here?');
      if ($.fn.dataTable.isDataTable('.table._searchable')) {
        console.log("table exists - do nothing");
        // table = $('.table._searchable').DataTable();
      } else {
        console.log("creating table");
        table = initGlobalTable($('.table._searchable'));
        $('body #table_search').on('keyup', function() {
          term.search.table = this.value;
          table.search(term.search.table).draw();
        });

        // INITIALIZE DATATABLE
        var rows_selected = [];

        poller = (function() {
          var inProgress = false;

          var _poller = {
            poll: function() {
              if (inProgress) return true;

              var pageUrl = window.location.href;

              console.log('polling...', pageUrl);

              inProgress = true;
              $.ajax({
                url: pageUrl,
                type: 'GET',

                success: function(data) {
                  inProgress = false;

                  table.destroy();

                  var $tbody = $('table._searchable tbody');

                  $tbody.empty();
                  $tbody.html(data);
                  //console.log('data...', data);

                  table = initGlobalTable($('.table._searchable'));
                  //alert("polled and created table");
                  filterColumn(5, prescription.state, $('._psc-state')); 
                  //alert("filtering by: "+ prescription.state);
                }
              })
            }
          };

          tableInterval = window.setInterval(function() {

            _poller.poll();

          }, refresh.table);

          return _poller;
        })();        
      }
    }   

    if($('body .table._global').length){
      if (!$.fn.dataTable.isDataTable('body .table._global')) {
        console.log('prep datatable + 1');    
        //globalTable.destroy();
        //$('body #g_table_date').empty(); // Remove existing date filters
        globalTable = initGlobalTable($('.table._global'));
        //yadcf.exResetAllFilters(globalTable);
      }else{
        console.log("resetting the table");
      }
      
      var $elemTbl = $('.table._global');
      var f = '' + $elemTbl.data('filter') + '';
      var col = '';
      if (f == 'date') {
        col = '' + $elemTbl.data('filter-on') + '';
        console.log('BREAK');
        if(col != ''){
          yadcf.init(globalTable, [
              {column_number : col, filter_reset_button_text: false, filter_type: "range_date", filter_container_id: 'g_table_date', datepicker_type: 'bootstrap-datetimepicker', date_format: 'YYYY-MM-DD'}]);        
        }else{
          console.log('Col is empty');
        } 
      }     
    }

    $(document).on('keyup', '#g_table_search', function(e) {
      globalTable.search(this.value).draw();
    });      

    $('input[type=text][data-cms-date]').datetimepicker({
      format: 'YYYY-MM-DD', useCurrent: false
    }); 
    
    $('._date').inputmask('99/99/9999');
    $('._tel').inputmask('(999) 999 9999', {autoUnmask: true});
    $('._credit').inputmask('9999 9999 9999 9999',{autoUnmask: true});
    $('._cvv').inputmask('999',{autoUnmask: true});    

    $('body').on('click', '._psc-state', function(e) {
      e.preventDefault();
      var $t = $(this);
      if (!$t.hasClass('active')) {
        var state = $(this).data('state');
        prescription.state = state;
        $('body ._psc-state').removeClass('active');
        $t.addClass('active');
        filterColumn(5, prescription.state, $('._psc-state'));
      }
    });

    if ($('.client-infobar')) {
      var headerH = $('.client-infobar .tab-header').outerHeight(true);
      var bodyH = $('.client-infobar').height();
      var $target = $(".client-infobar .tab-content");
      bodyH = bodyH - headerH - 15;
      $target.height(bodyH);
      $target.perfectScrollbar({
        suppressScrollX: true
      });
    }
    
    $('._ui-toggle ._handle').on('click focus',function(){
      var $t = $(this);
      $t.find('input').prop('checked', true);
      $t.addClass('_checked');
      $t.siblings().removeClass('_checked');
    });

    $(document).on('click focus','._focus-wrapper .remove_fields', function(e){
      e.stopPropagation();
    });      
      
    $(document).on('click focus','._focus-wrapper', function(){
      var $t = $(this);
      if(!$t.hasClass('_focused')){       
        $t.addClass('_focused');
        $t.siblings('._focus-wrapper').removeClass('_focused');
        $t.find('input').not(':hidden').first().focus(); 
      }
    });      
    
    /* FOCUS LIST ROW  
    $(document).on('focus','._focus-wrapper', function(){
      if(!$(this).hasClass('_focused')){        
        $(this).addClass('_focused');        
        $(this).siblings('._focus-wrapper').removeClass('_focused');
        $(this).find('input').not(':hidden').first().focus();        
      }
    }); */   
    
    $(document).on('change','._value-field', function(e){
      var v = '';
      var p = '';
      var $this = $(this);
      if($this.is('input')){
        v = $this.val();
        p = $this.attr('placeholder');
      }
      if($this.is('select')){
        v = $this.find('option:selected').text();
      }    
      var s = $this.data('target');
      var $parent = $this.parents('.list-item');
      if(v){
        if(s == '._drug-form'){
          v = ' - ' + v;
        }else if(s == '._drug-duration'){
          v = ' x ' + v;
        }         
        $parent.find(s).text(v);        
      }else{
        if(s == '._drug-form'){
          p = ' - ' + p;
        }else if(s == '._drug-duration'){
          p = ' x ' + p;
        }  
        $parent.find(s).text(p);
      }
      /* if(s == '._drug-route'){
        var term = v.toLowerCase();
        if(term == 'po'){
          $parent.addClass('_hasScript');
        }else{
          $parent.removeClass('_hasScript');
        }
      } */      
    });   
    
    $(document).on('click', 'body', function(){
      $("._stage").removeClass('_active').trigger('hide-stage');    
    });    
    
    $(document).on('click', '._stage', function(e){
      e.stopPropagation();
    });  
    
    $(document).on("hide-stage", "._stage", function(e) {
      e.preventDefault();
      if($(this).hasClass("_show-more")){
        var $parent = $(this).parents('.list-item');
        $parent.find('._more').slideUp('fast');
        $(this).removeClass('_active');  
      }
    });     

    $(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
      var tab = $(".client-infobar .tab-content");
      tab.scrollTop = 0;
      $(tab).perfectScrollbar('update');
    });
    
    /*
     * Multi Step UI
     */
    $('body').on('click', '._next', function(e) {
      var $elem = $(this);
      var parent = $elem.data('name');
      console.log('setting tab');
      if ( !$elem.hasClass('_disabled') ) {
        var $form = $(this).parents('form');
        var valid = validate_form({form: $form, mode: 'each'});
        if( valid ){
          $form.removeClass('ready');
          $elem.addClass('_active');
          $elem.removeClass('_pristine')
          $elem.siblings().removeClass('_active');
        }else{
          if($elem.hasClass('_pristine')){
            return false;
          }  
        }
        tabs.setNav(parent);
        tabs.handler(parent, '._card');
      }
    });
    
    $('body').on('click', '._toggle', function(e) {
      var $elem = $(this);
      var $target = $($elem.data('name'));
      var id = $elem.data("type-id");
      $("body input._lab-select").attr("data-param",id);
      setup_autocomplete($('[data-autocomplete]'));
      if($target.length){
        if($elem.hasClass('_active')){
          $elem.removeClass('_active');
          $elem.siblings().removeClass('_inactive');
          $target.addClass('_remove');
          $target.find('._option input').prop('checked',false).trigger('change');
        }else{
          $elem.addClass('_active');
          $elem.siblings().addClass('_inactive');
          $target.removeClass('_remove');
        }
      }
    });       

    $(document).off("click", "._show-notifications").on("click", "._show-notifications", function(e) {
      e.preventDefault();
      var $elem = $(this);      
      var $target = $elem.data('notification');
      if($('#client-ui').hasClass('_showing-'+$target+'')){
        $('#client-ui').removeClass('_showing-'+$target+''); 
        $elem.removeClass('_active');         
        return false;
      }
      
      refreshNotificationsList({elem: $elem, target: $target});
    });      
    
    // Check if message count elements exist in the page
    if($('._msg-count[data-notification="messages"]').length){
      (function() {
        var inProgress = false;
        var $elem = $('._msg-count[data-notification="messages"]');
        //var exCount = $elem.first().text();
        var _poller = {
          poll: function() {
            if(messageViewed){
              $elem.removeClass('_changed');
              FaviconNotification.remove();
            }            
            if (inProgress) return true;

            var pageUrl = $('body').data('msg-source');
            
            inProgress = true;
            $.ajax({
              url: pageUrl,
              type: 'GET',
              success: function(data) {
                inProgress = false;
                var count = 0;
                if($.isArray(data)){
                  for (var i in data) {
                    count += data[i].unread_message_count;
                  }  
                }

                if(count > Number($elem.first().text())){
                  // removed message viewed conditional  && !messageViewed
                  messageViewed = false;
                  FaviconNotification.add();
                  $elem.addClass('_changed');      
                  createDesktopNotification({title: 'New Notification', body: "You have a new notification."});                  
                }                
                $elem.text(count);
              }
            })
          }
        };

        msgInterval = window.setInterval(function() {

          _poller.poll();

        }, refresh.msg);

        return _poller;
      })();        
    }
    
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
            height: 128
          }
        },
        onSelect: function (evt, ui){
          var file = ui.files[0];
          if( !FileAPI.support.transform ) {
            alert('Your browser does not support Flash :(');
          }
          else if( file ){
            //console.log('the file: '+file);
            /*var $cropArea = $('#dg-cropper ._img');             
            $('#dg-cropper').modal('show');              
            $('#dg-cropper').on('shown.bs.modal', function (event) { 
              $cropArea.cropper({
                file: file,
                bgColor: '#fff',
                maxSize: [$('#dg-cropper').width(), $('#dg-cropper').height()],
                minSize: [200, 200],
                selection: '90%',
                onSelect: function (coords){
                  console.dir(coords);
                  $(image).fileapi('crop', file, coords);
                }
              });              
              $('#dg-cropper').on('click', '._crop', function (){
                $('#dg-cropper').modal('hide');
              }); 
            })  */          
          }
        }        
      });     
    });    
    
    // SETUP INFOBAR
    $("#new_diagnostic ._option input[type='checkbox']").each(function(){   
      previewSubmission(this);
    });   

    if(window.location.hash){
      prepareView(window.location.hash);
    }else{
      $('#client-ui').removeClass('_page-loading');        
    }
    
    domReady = true;
  }   
  
  $(document).on("click", "._menu-toggle", function(e) {
    e.preventDefault();
    $('#client-sidebar').toggleClass('_menu-active');   
  });  
  
  $(document).on("click", ".list-item ._show-more", function(e) {
    e.preventDefault();
    var $parent = $(this).parents('.list-item');
    $parent.find('._more').slideToggle('fast').toggleClass('_showing');
    $(this).toggleClass('_active');    
  });

  
/*  $(document).on("mouseenter", ".notification-group .list-item ._show-more", function(e) {
    e.preventDefault();
    var $t = $(this);
    if(!$t.hasClass('_active')){ 
      setTimeout(function(){
        var $parent = $t.parents('.list-item');
        var $more = $parent.find('._more');
        $t.addClass('_active');    
        $more.slideDown('fast');    
      },100);
    }   
  });  */

  // Show file hidden content 
  $(document).on("click", ".section ._show-more-global", function(e) {
    e.preventDefault();
    $(this).toggleClass('_active');
    $('._more').slideToggle('fast');
  });

  // Show file hidden content 
  $(document).on("click change", "._expandable ._parent ._control", function(e) {
    //e.preventDefault();
    $(this).toggleClass('active');
    var $parent = $(this).parents('._expandable'),
      id = $(this).data('id');
    $(this).parents('._parent').toggleClass('_active');
    $parent.find('._child[data-id=' + id + ']').each(function() {
      $(this).toggle();
    });
  });
  
  // Show file hidden content - hide controls
  $(document).on("click", "._expandable ._parent ._switch", function(e) {
    e.preventDefault();
    $(this).toggleClass('hidden');
    var $parent = $(this).parents('._expandable');
    $parent.find('._child').each(function() {
      $(this).slideToggle('fast');
    });
  });
  
  $(document).on("click", "._editable ._edit", function(e) {
    e.preventDefault();
    $(this).toggleClass('hidden');
    var $parent = $(this).parents('._editable');
    $parent.find('._input').each(function() {
      $(this).slideToggle();
    });
  });  
  
  $(document).on('blur input keyup', 'form .required', function(e) {
    var $form = $(this).parents('form');
    validate_form({form: $form, element: this}); 
  }) 
  
  $(document).on('blur input keyup', '._prescript-item .required', function(e) {
    var $form = $(this).parents('._prescript-item');
    validate_form({form: $form, element: this});      
  })   
  
  // Validate Form on submit  
  $(document).on('click', 'form:not(.ready) ._submit', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    if(!validate_form({form: $form, callback: 'click', mode: 'each'})){
      dsDialog.show({type: 'alert', title: 'Your form contains errors', message: "Please update the fields highlighted in red before re-submitting your form."});      
    }
  })   
  
  // Validate slave form
  $(document).on('click', 'form ._prepare-form', function(e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    var $main = '';
    var target = $(this).data('form');
    if( target != '' ){ // check for form attribute
      $main = $(document).find('form[data-target='+target+']');
      if( validate_form({form: $form, mode: 'each'}) ){
        if( !validate_form({form: $main, callback: 'click', mode: 'each'}) ){
          dsDialog.show({type: 'alert', title: 'Your form contains errors', message: "Please update the fields highlighted in red before re-submitting your form."}); 
        }
      }else{
        dsDialog.show({type: 'alert', title: 'Your form contains errors', message: "Please update the fields highlighted in red before re-submitting your form."});         
      }
    }else{
      return false;
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

  /* 
   *  $(document).on('click','.modal .back', function(e){
   *    e.preventDefault();
   *    var $template = $(this).parents('._template');
   *    $('._template ._prev').removeClass('_remove _prev');
   *    $template.addClass('_prev _remove');
    }); 

    $(document).on('click','.modal ._nav', function(e){
    e.preventDefault();
    var t = $(this).data('target');
    var $p = $(this).parents('._template');
    $p.addClass('_remove _prev');
    $(t).removeClass('_remove _prev');    
    });  
    */
  
  // PREVENT SUBMIT IF FIELD ISNT POPULATED
  $(document).on('keyup', '.allow-submit', function(){
    var target = $(this).data('ready');
    if(target){
      var $submit = $('.'+target+'');
      if($(this).val() != ''){
        $submit.removeClass('_disabled').addClass('_focus');
      }else{
        $submit.removeClass('_focus').addClass('_disabled');
      }
    }
  }); 
  
  // PRESCRIPTION MODAL - MESSAGES HANDLER
  $(document).on('click', 'form.ready a._submit#send_message', function(e) {
    e.preventDefault();
        
    var $self = $(this);
    var $target = $self.parents('.modal[data-remote="true"]') //$('#dg-pharm-prescription');

    var $form = $self.parents('form');
    
    var resolved = $form.find('#message_mark_as_resolved').prop('checked');
    
    if(resolved && $target.find('form textarea').val() == ''){
      $target.find('form textarea').val('Closed the conversation.'); 
    }
    
    var params = $form.serialize();
    var url = $form.attr('action');
    
    $self.removeClass('_submit').text('SENDING...');    

    $.ajax({
      url: url,
      type: 'POST',
      data: params,

      success: function(result) {
        if($target.length) {
          $target.find('.modal-content').html(result);
          // reseting form         
          if(resolved){
            $target.find('form .hide-if-resolved').remove();
          }else{
            $target.find('form textarea').val(''); 
          }
          buildview();
        }
      },
      
      error: function(result){
        $self.addClass('_submit').text('TRY AGAIN');        
      }
    }).done(function(){
      $(document).trigger('dg.message.action');
    });
  });
    
  $(document).off('dg.message.action').on('dg.message.action', function() {
    console.log('message sent');
/*    // disable page scrolling to top after loading page content
    Turbolinks.enableTransitionCache(true);

    // pass current page url to visit method
    Turbolinks.visit(location.toString());

    // enable page scroll reset in case user clicks other link
    Turbolinks.enableTransitionCache(false);  */  
  });  
  
  $(document).on('keyup', '.allow-submit-inline', function(){
    var $formSubmit = $(this).parents('form').find('input[type="submit"]');
    if($(this).val() != ''){
      $formSubmit.prop('disabled',false).removeClass('_disabled').addClass('_focus');
    }else{
      $formSubmit.prop('disabled',true).removeClass('_focus').addClass('_disabled');
    }
  });   
  
  // PATIENT NOTES
  $(document).on('submit', 'form#patient_notes_form', function(e) {
    e.preventDefault();

    var $self = $(this);
    var url = $self.attr('action');
    var data = $self.serialize();
    var $submit = $self.find('._submit');
    $self.removeClass('ready');
    $submit.find('span').text('Processing...');    

    $.ajax({
      url: url,
      data: data,
      type: 'POST',

      success: function(result) {
        $('#patient_notes').html(result);
        $self.find('textarea').val(''); // Clear note field
        $submit.find('span').text('Save Note');            
      },
      
      error: function(result){
        $self.addClass('ready');
        $submit.find('span').text('TRY AGAIN');        
      }      
      
    })
  })

  // LINE ITEM NOTES
  $(document).off('click', '#pharmacy_details form .add-subscript-note').on('click', '#pharmacy_details form .add-subscript-note', function(e) {
    e.preventDefault();

    var $self = $(this);
    var $form = $self.parents('form');
    var data = $form.serialize();
    var url = $form.attr('action') + '/set_prescript_note';

    $.ajax({
      url: url,
      data: data,
      type: 'POST',

      success: function(result) {
        $('#pharmacy_details').html(result);
        setup_autocomplete($('#pharmacy_details [data-autocomplete]'));  
        tabs.setNav('review');
      }
    })
  })
  
  // CHECK FOR STATE
  $(document).on('change','.dosage_fields .dosage_frequency select',function(){
    var $t = $(this);
    var o = $t.val().trim();
    var $e = $t.parents('._prescript-item').find('.disable_on_stat');
    if(o && o == '1'){
      $e.hide();
    }else{
      $e.show();
    }
    return false;
  })
  
  // DIAGNOSTICS
  $(document).on('blur input keyup change','form ._binded', function(){
    var $form = $(this).parents('form');
    var value = $(this).val();
    var bindedTo = $(this).data('bind');
    var $target = $(document).find('[data-bind='+bindedTo+']').not($(this));
    if( validate_field({form: $form, element: this}) > 0 ){
      if($(this).is(':checkbox')){
        value = true;
      }      
    }else{
      value = '';
      if($(this).is(':checkbox')){
        value = false;
      }      
    }
    $target.val(value);
  });
  
  $(document).on('keyup', '._filter', function(){
    var $t = $(this);
    var term = $t.val().toLowerCase();
    var target = $t.data('target');
    $(target).find('._option .name').filter(function(){
      var text  = $(this).text().toLowerCase();
      if(text.indexOf(term) == -1){
        $(this).parents('._option').addClass('hidden');
      }else{
        $(this).parents('._option').removeClass('hidden');
      }
    });
  });
  
  // FILTER
  $(document).on('change', "._option input[type='checkbox']", function(){
    previewSubmission(this);
  });  
  
  $(document).on('click', '._tab', function(e) {
    var $elem = $(this);
    var parent = $elem.data('name');
    var group = $elem.data('group');
    var $collection = $(group);
    if (!$elem.hasClass('_active')) {
      var $form = $elem.parents('form');
      // why? 
//       var valid = validate_form({
//         form: $form,
//         mode: 'each'
//       });
      if($elem.attr('data-mode') == 'all'){
        $elem.addClass('_active');
        $(parent).find('._option input').prop('checked', true).trigger('change');  
      }else{
        //if (valid) {
          $form.removeClass('ready');
          $elem.addClass('_active');
          $elem.siblings().removeClass('_active');

          $collection.each(function() {
            $(this).addClass('_remove');
          });
        //}
        $(parent).removeClass('_remove');          
      }        
    } else {
      $elem.removeClass('_active');
      $(parent).addClass('_remove');
      if($elem.attr('data-mode') == 'all'){        
        $(parent).find('._option input').prop('checked', false).trigger('change');
      }
    }
  }); 
  
  // LINK HANDLER
  $(document).on('click', '._before-print', function(e) {
    e.preventDefault();
    dsDialog.show({type: 'warning', title: 'Warning', message: "When a prescription is printed, it is no longer editable and cannot be sent to a pharmacist. Click Continue to proceed or Cancel to return to the prescription.", callback: redirectTo, target: $(this)});
  });
  
  // PRINT HANDLER
  $(document).on('click', '#print', function(e) {
    e.preventDefault();
    window.print();
  });

})(jQuery);
