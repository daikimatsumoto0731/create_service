document.addEventListener('DOMContentLoaded', function() {
  const menuToggle = document.getElementById('menu-toggle');
  menuToggle.addEventListener('change', function() {
    document.body.classList.toggle('menu-open', menuToggle.checked);
  });
});
