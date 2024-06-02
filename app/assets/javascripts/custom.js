$(document).ready(function() {
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

  // カレンダーの初期化
  var calendarEl = document.getElementById('calendar');
  var calendar;

  if (calendarEl) {
    calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      events: '/events.json' // イベントデータを取得するエンドポイント
    });
    calendar.render();
  }

  // スタンプボタンのクリックイベント
  $('.stamp-button').on('click', function() {
    var stamp = $(this).data('stamp');
    var today = new Date().toISOString().split('T')[0];
    var vegetableId = $('#calendar').data('selected-vegetable-id');

    addStampToCalendar(stamp, today, vegetableId);
  });

  // スタンプをカレンダーに追加する関数
  function addStampToCalendar(stamp, date, vegetableId) {
    console.log('Sending stamp:', stamp, 'on date:', date, 'for vegetable:', vegetableId); // デバッグ用ログ

    $.ajax({
      url: '/events',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
      },
      data: JSON.stringify({
        event: {
          title: stamp,
          start_date: date,
          end_date: date,
          vegetable_id: vegetableId
        }
      }),
      success: function(data) {
        console.log('Stamp added successfully:', data); // デバッグ用ログ
        calendar.addEvent({
          title: stamp,
          start: date,
          allDay: true
        });
        alert('スタンプが追加されました');
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log('Error adding stamp:', textStatus, errorThrown); // デバッグ用ログ
        alert('スタンプの追加に失敗しました: ' + textStatus);
      }
    });
  }
});
