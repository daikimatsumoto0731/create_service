// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require bootstrap
//= require moment
//= require fullcalendar
//= require_tree .

$(document).on('turbolinks:load', function () {
    console.log("Turbolinks load event triggered."); // turbolinks:loadイベントの発生をログに出力
    if ($('#calendar').length) {
        console.log("Calendar element found. Initializing FullCalendar."); // カレンダー要素が見つかったことをログに出力

        function Calendar() {
            console.log("Initializing FullCalendar."); // FullCalendarの初期化をログに出力
            return $('#calendar').fullCalendar({
                events: '/custom_schedule.json', // イベントデータのURLを修正
                // カレンダーの設定
            });
        }

        function clearCalendar() {
            console.log("Clearing calendar."); // カレンダーをクリアする処理をログに出力
            $('#calendar').html('');
        }

        Calendar(); // FullCalendarを初期化するために関数を呼び出す

        $(document).on('turbolinks:before-cache', clearCalendar);
    } else {
        console.log("Calendar element not found. FullCalendar initialization skipped."); // カレンダー要素が見つからなかったことをログに出力
    }
});
