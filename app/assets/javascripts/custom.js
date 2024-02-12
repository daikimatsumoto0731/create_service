$(document).ready(function() {
  $('.stage-button').on('click', function() {
    var stage = $(this).data('stage');
    console.log(stage + " ボタンがクリックされました。");
  });
});
  