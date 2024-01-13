document.addEventListener('DOMContentLoaded', () => {
  const vegetableRadios = document.querySelectorAll('.vegetable-radio');
  const form = document.querySelector('form');

  vegetableRadios.forEach(radio => {
    radio.addEventListener('change', () => {
      const selectedVegetable = document.querySelector('input[name="selected-vegetable"]:checked');
      if (selectedVegetable) {
        const vegetableButtons = document.querySelectorAll('.vegetable-button');
        vegetableButtons.forEach(button => button.classList.remove('active'));
        const vegetableButton = document.querySelector(`.vegetable-button.${selectedVegetable.value}`);
        if (vegetableButton) {
          vegetableButton.classList.add('active');
        }
      }
    });
  });

  form.addEventListener('submit', (e) => {
    const selectedVegetable = document.querySelector('input[name="selected-vegetable"]:checked');
    if (!selectedVegetable) {
      e.preventDefault();
      alert('野菜を選択してください。');
    }
  });
});