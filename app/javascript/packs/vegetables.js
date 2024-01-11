document.addEventListener("DOMContentLoaded", function() {
    var vegetableInputs = document.querySelectorAll("input[name='vegetable']");
    var submitButton = document.querySelector(".submit-button");
  
    vegetableInputs.forEach(function(input) {
      input.addEventListener("change", function() {
        submitButton.disabled = false; // 野菜が選択されたらボタンを有効にする
      });
    });
  });
  