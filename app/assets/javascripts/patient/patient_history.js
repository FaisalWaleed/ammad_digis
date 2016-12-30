$(document).ready(function() {
  $('#prescription-detail').on('show.bs.modal', function (event) {
    id = $(event.relatedTarget).data('presecription-id');
    if (id) {
      $.get('prescription_details/'+id, function(data){
        $('#prescription-detail .modal-body').html(data);
      })
    }
    else {
      $('#prescription-detail .modal-body').html('Invalid presecriptions');
    }
  });

  $('#prescriptionDetail').on('hidden.bs.modal', function () {
    $('.#prescriptionDetail .modal-body').html('')
  });
});
