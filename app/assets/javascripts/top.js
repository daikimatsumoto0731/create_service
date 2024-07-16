// ハンバーガーメニューの動作を追加
document.addEventListener('DOMContentLoaded', function() {
  const menuToggle = document.getElementById('menu-toggle');
  menuToggle.addEventListener('change', function() {
    document.body.classList.toggle('menu-open', menuToggle.checked);
  });
});

// クリップボードにコピーする関数
function copyToClipboard(url) {
  navigator.clipboard.writeText(url).then(function() {
    alert('URLがクリップボードにコピーされました: ' + url);
  }, function(err) {
    console.error('クリップボードへのコピーに失敗しました: ', err);
  });
}
