import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction'; // 日付クリックやイベントドラッグ&ドロップに必要

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');

  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin, interactionPlugin ],
    editable: true,
    selectable: true,
    // 他にもオプションがあるから、必要に応じて追加しよう
  });

  calendar.render();
});