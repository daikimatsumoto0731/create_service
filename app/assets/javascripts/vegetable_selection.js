document.addEventListener("DOMContentLoaded", function() {
  var registerButton = document.getElementById('register-vegetable-button');
  
  if (registerButton) {
    registerButton.addEventListener('click', function(e) {
      e.preventDefault();
    
      var vegetableName = document.getElementById('vegetable-name').value.trim();
      var sowingDate = document.getElementById('sowing-date').value;
      var errors = [];
      var errorExplanation = document.getElementById('client_error_explanation');
      var errorList = errorExplanation.querySelector('ul');

      // エラーメッセージをクリア
      errorList.innerHTML = '';

      if (!vegetableName) {
        errors.push('野菜の名前を入力してください');
      } else if (vegetableName.length < 2 || vegetableName.length > 50) {
        errors.push('野菜の名前は2文字以上50文字以下で入力してください');
      }

      if (!sowingDate) {
        errors.push('種まき日を入力してください');
      }

      if (errors.length > 0) {
        console.log('入力に誤りがあります。エラーメッセージを表示します。');
        errors.forEach(function(error) {
          var li = document.createElement('li');
          li.textContent = error;
          errorList.appendChild(li);
        });
        errorExplanation.style.display = 'block';
      } else {
        console.log('登録ボタンがクリックされました。次のページにリダイレクトします。');
        errorExplanation.style.display = 'none';
        // 保存が成功した場合に次のページにリダイレクトする
        var form = document.getElementById('vegetable-form');
        form.action = "/vegetables/create_and_redirect";
        form.method = "POST";
        form.submit();
      }
    });
  } else {
    console.error('登録ボタンが見つかりませんでした。');
  }
});
