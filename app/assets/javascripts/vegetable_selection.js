$(document).ready(function() {
    var selectedVegetable = null;

    console.log("野菜選択画面のスクリプトが読み込まれました。");

    $('.vegetable-button').click(function(e) {
        e.preventDefault();
        selectedVegetable = $(this).data('value');

        console.log('野菜ボタンがクリックされました: ' + selectedVegetable);

        // 選択された野菜を表示領域に表示
        $('#display-selected-vegetable').text('選択された野菜: ' + $(this).text());
    });

    $('#select-vegetable-button').click(function(e) {
        e.preventDefault();

        console.log('選択ボタンがクリックされました。選択された野菜: ' + selectedVegetable);

        if (selectedVegetable) {
            // 正しいアクションへ遷移するURLを生成
            console.log('リダイレクト先のURL: /events?selected_vegetable=' + selectedVegetable);
            window.location.href = `/events?selected_vegetable=${selectedVegetable}`;
        } else {
            console.log('選択された野菜がありません。アラートが表示されます。');
            alert('野菜を選択してください');
        }
    });
});
