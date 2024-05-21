$(document).ready(function() {
  // 各野菜のアドバイスボタンがクリックされたときの処理
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

  // モーダルを表示するボタンがクリックされたときの処理
  $('[data-toggle="modal"]').on('click', function() {
    var targetModal = $(this).data('target');
    $(targetModal).modal('show');
  });

  // 画像を分析するモーダル表示用のボタンがクリックされたときの処理
  $('#analyzeImageModal').on('show.bs.modal', function(event) {
    var button = $(event.relatedTarget); // 適切なボタンを取得
    var modal = $(this);
    modal.find('.modal-body input').val('');
  });

  $('#analyze_image_form').on('submit', function(e) {
    e.preventDefault(); // フォームのデフォルト送信を防ぐ
    var formData = new FormData(this);
    $.ajax({
      url: $(this).attr('action'),
      type: 'POST',
      data: formData,
      contentType: false,
      processData: false,
      success: function(data) {
        $('#analyzeImageModal .modal-body').html(data);
        $('#analyzeImageModal').modal('show');
      },
      error: function(jqXHR, textStatus, errorThrown) {
        alert('画像の分析に失敗しました: ' + textStatus);
      }
    });
  });  
});
