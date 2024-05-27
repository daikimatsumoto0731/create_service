document.addEventListener("DOMContentLoaded", function() {
  document.getElementById('save-vegetable-button').addEventListener('click', function(e) {
    e.preventDefault();
      
    var vegetableName = document.getElementById('vegetable-name').value;
    var sowingDate = document.getElementById('sowing-date').value;
  
    if (vegetableName && sowingDate) {
      console.log('野菜が入力されました: ' + vegetableName + ', 播種日: ' + sowingDate);
      document.getElementById('vegetable-form').submit();
    } else {
      console.log('野菜の名前または播種日が入力されていません。アラートが表示されます。');
      alert('野菜の名前と播種日を入力してください');
    }
  });
  
  document.getElementById('register-vegetable-button').addEventListener('click', function(e) {
    e.preventDefault();
      
    var vegetableName = document.getElementById('vegetable-name').value;
    var sowingDate = document.getElementById('sowing-date').value;
  
    if (vegetableName && sowingDate) {
      console.log('登録ボタンがクリックされました。次のページにリダイレクトします。');
      window.location.href = `/events/show?selected_vegetable=${vegetableName}`;
    } else {
      console.log('野菜の名前または播種日が入力されていません。アラートが表示されます。');
      alert('野菜の名前と播種日を入力してください');
    }
  });
});
  