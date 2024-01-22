$(document).ready(function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth,harvestButton'
        },
        customButtons: {
            harvestButton: {
                text: '収穫',
                click: function() {
                    alert('収穫ボタンがクリックされました！');
                    // 収穫に関するロジックをここに追加
                }
            }
        },
        initialDate: '2024-01-12',
        navLinks: true, // 日付/週の名前をクリックしてビューをナビゲートできる
        businessHours: true, // 営業時間を表示
        editable: true,
        selectable: true,
        events: [
            {
                title: '種まき',
                start: '2024-01-03',
                color: '#f56c6c' // 赤色でイベントを表示
            },
            {
                title: '発芽期間',
                start: '2024-01-05',
                end: '2024-01-12',
                color: '#64ea91' // 緑色でイベントを表示
            },
            {
                title: '間引き',
                start: '2024-01-15',
                color: '#ffbf00' // 黄色でイベントを表示
            }
            // その他の農作業イベントも同様に追加
        ]
    });

    calendar.render();
});
