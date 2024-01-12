document.addEventListener("DOMContentLoaded", function() {
    var vegetableInputs = document.querySelectorAll("input[name='vegetable']");
    var submitButton = document.querySelector(".submit-button");
    var selectionMessage = document.getElementById("selection-message");
  
    // 選択ボタンがクリックされたときの処理
    submitButton.addEventListener("click", function(event) {
      // 選択された野菜の数をカウント
      var selectedVegetables = document.querySelectorAll("input[name='vegetable']:checked");
  
      // 選択された野菜が1つ以上ある場合はスケジュール画面に遷移
      if (selectedVegetables.length > 0) {
        // ここでスケジュール画面への遷移を行う
        // 例えば、以下のようにURLを設定して遷移させることができます
        window.location.href = "<%= schedule_path %>";
      } else {
        // 選択されていない場合はメッセージを表示
        selectionMessage.style.display = "block";
        event.preventDefault(); // フォームのデフォルト動作をキャンセル
      }
    });
  
    vegetableInputs.forEach(function(input) {
      input.addEventListener("change", function() {
        // 選択された野菜の数をカウント
        var selectedVegetables = document.querySelectorAll("input[name='vegetable']:checked");
  
        // 選択された野菜が1つ以上ある場合はボタンを有効にする
        if (selectedVegetables.length > 0) {
          submitButton.disabled = false;
          selectionMessage.style.display = "none"; // メッセージを非表示
        } else {
          submitButton.disabled = true;
          selectionMessage.style.display = "block"; // メッセージを表示
        }
      });
    });
  });
  