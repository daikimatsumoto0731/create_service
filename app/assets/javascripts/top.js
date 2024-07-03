function copyToClipboard(url) {
  navigator.clipboard.writeText(url).then(function() {
    alert('URLがクリップボードにコピーされました: ' + url);
  }, function(err) {
    console.error('クリップボードへのコピーに失敗しました: ', err);
  });
}