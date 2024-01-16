$(document).ready(function() {
    $('.vegetable-button').click(function(e) {
        e.preventDefault(); // 通常のリンク遷移を防ぐ

        var selectedVegetable = $(this).data('value');
        console.log('選択された野菜: ' + selectedVegetable); // デバッグメッセージ

        // hidden_fieldに選択された野菜を設定
        $('#selected-vegetable-field').val(selectedVegetable);

        // フォームを送信
        $('form').submit();
    });

    $('#select-vegetable-button').click(function() {
        console.log('選択ボタンがクリックされました'); // デバッグメッセージ
    });
});
