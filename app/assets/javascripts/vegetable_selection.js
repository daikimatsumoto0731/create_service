$(document).ready(function() {
    $('.vegetable-button').click(function(e) {
        e.preventDefault(); // 通常のリンク遷移を防ぐ

        var selectedVegetable = $(this).data('value');
        console.log('選択された野菜: ' + selectedVegetable); // デバッグメッセージ

        // hidden_fieldに選択された野菜を設定
        $('#selected-vegetable-field').val(selectedVegetable);

        // スケジュール画面へのリダイレクトを手動で実行
        window.location.href = '<%= custom_schedule_path %>?selected_vegetable=' + selectedVegetable;
    });

    $('#select-vegetable-button').click(function() {
        console.log('選択ボタンがクリックされました'); // デバッグメッセージ
    });
});
