$(document).ready(function() {
  $('.stage-button').on('click', function() {
    var eventId = $(this).data('event-id'); // 正しくイベントIDを取得
    var targetModalId = $(this).data('target');
    
    $.ajax({
      url: `/events/${eventId}/advice`, // 正しいURLを使用
      method: "GET",
      success: function(data) {
        $(targetModalId).find('.modal-body').html(data);
        $(targetModalId).modal('show');
      }
    });
  });
});
  