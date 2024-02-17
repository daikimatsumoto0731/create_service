$(document).ready(function() {
  $('.stage-button').on('click', function() {
    var eventId = $(this).data('event-id');
    var targetModal = '#event' + eventId + '_modal';
  
    $.ajax({
      url: '/events/' + eventId + '/advice',
      method: 'GET',
      success: function(data) {
        $(targetModal + ' .modal-body').html(data);
        $(targetModal).modal('show');
      }
    });
  });
});
  