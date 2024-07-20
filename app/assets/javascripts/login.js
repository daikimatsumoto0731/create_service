// ハンバーガーメニューのトグル機能
document.addEventListener('DOMContentLoaded', function() {
  const menuToggle = document.getElementById('menu-toggle-auth');
  const body = document.body;

  // メニューの開閉
  menuToggle.addEventListener('change', function() {
    if (menuToggle.checked) {
      body.classList.add('menu-open');
    } else {
      body.classList.remove('menu-open');
    }
  });
});
