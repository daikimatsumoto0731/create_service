$(document).ready(function() {
    var selectedVegetable = null; // 選択された野菜を保持する変数
    var authenticityToken = $('meta[name="csrf-token"]').attr('content'); // CSRFトークンを取得

    // 野菜ボタンをクリックしたときの処理
    $('.vegetable-button').click(function(e) {
        e.preventDefault(); // 通常のリンク遷移を防ぐ

        selectedVegetable = $(this).data('value'); // 選択された野菜を変数に格納
        console.log('選択された野菜: ' + selectedVegetable); // デバッグメッセージ
    });

    // 選択ボタンをクリックしたときの処理
    $('#select-vegetable-button').click(function() {
        if (selectedVegetable) {
            console.log('選択ボタンがクリックされました'); // デバッグメッセージ

            // hidden_fieldに選択された野菜を設定
            $('#selected-vegetable-field').val(selectedVegetable);

            // CSRFトークンを含むフォームを作成し、送信
            var form = $('<form>', {
                'action': '/schedule', // フォームの送信先URLを指定
                'method': 'post' // フォームのHTTPメソッドを指定
            }).append(
                $('<input>', {
                    'type': 'hidden',
                    'name': 'authenticity_token',
                    'value': authenticityToken // CSRFトークンの値を設定
                }),
                $('<input>', {
                    'type': 'hidden',
                    'name': 'selected_vegetable',
                    'value': selectedVegetable
                })
            ).appendTo('body');

            form.submit(); // フォームを送信
        } else {
            alert('野菜を選択してください'); // ユーザーに選択を促すアラート
        }
    });
});
