$(document).ready(function() {
  $('.stage-button').on('click', function() {
    var eventId = $(this).data('event-id'); // イベントIDを取得
    var targetModal = $(this).data('target'); // モーダルのIDを取得
  
    $.ajax({
      url: `/events/${eventId}/advice`, // イベントIDに基づくアドバイスを取得するURL
      method: "GET",
      success: function(data) {
        $(`#${targetModal}`).find('.modal-body').html(data); // モーダルの内容を更新
        $(`#${targetModal}`).modal('show'); // モーダルを表示
      },
      error: function() {
        alert('アドバイスの取得に失敗しました。');
      }
    });
  });
});
  