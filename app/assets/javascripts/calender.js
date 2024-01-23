document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  var schedules = JSON.parse(calendarEl.dataset.schedules);

  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin, interactionPlugin ],
    initialView: 'dayGridMonth',
    selectable: true,
    // イベントデータをカレンダーに渡す
    events: schedules,
    // ... その他のオプション
  });

  calendar.render();
});
