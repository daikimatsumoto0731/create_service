document.addEventListener("DOMContentLoaded", function() {
  var registerButton = document.getElementById('register-vegetable-button');
  
  if (registerButton) {
    registerButton.addEventListener('click', function(e) {
      e.preventDefault();
    
      var vegetableName = document.getElementById('vegetable-name').value;
      var sowingDate = document.getElementById('sowing-date').value;
    
      if (vegetableName && sowingDate) {
        console.log('登録ボタンがクリックされました。次のページにリダイレクトします。');
        // 保存が成功した場合に次のページにリダイレクトする
        var form = document.getElementById('vegetable-form');
        form.action = "/vegetables/create_and_redirect";
        form.method = "POST";
        form.submit();
      } else {
        console.log('野菜の名前または種まき日が入力されていません。アラートが表示されます。');
        alert('野菜の名前と種まき日を入力してください');
      }
    });
  } else {
    console.error('登録ボタンが見つかりませんでした。');
  }
});
  