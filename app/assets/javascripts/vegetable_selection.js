$(document).ready(function() {
    var selectedVegetable = null;
    var authenticityToken = $('meta[name="csrf-token"]').attr('content');
    var alertShown = false;

    $('.vegetable-button').click(function(e) {
        e.preventDefault();

        selectedVegetable = $(this).data('value');
        console.log('選択された野菜: ' + selectedVegetable);

        // 選択された野菜を表示領域に表示
        $('#display-selected-vegetable').text('選択された野菜: ' + $(this).text());
    });

    $('#select-vegetable-button').click(function(e) {
        e.preventDefault();

        if (selectedVegetable) {
            console.log('選択ボタンがクリックされました');
            $('#selected-vegetable-field').val(selectedVegetable);

            var form = $('<form>', {
                'action': '/schedule',
                'method': 'post'
            }).append(
                $('<input>', {
                    'type': 'hidden',
                    'name': 'authenticity_token',
                    'value': authenticityToken
                }),
                $('<input>', {
                    'type': 'hidden',
                    'name': 'selected_vegetable',
                    'value': selectedVegetable
                })
            ).appendTo('body');

            form.submit();
        } else if (!alertShown) {
            alert('野菜を選択してください');
            alertShown = true;
        }
    });
});
