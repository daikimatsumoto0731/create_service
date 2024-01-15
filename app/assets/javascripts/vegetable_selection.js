$(document).on('turbolinks:load', function() {
  $('.vegetable-button').click(function() {
    var selectedVegetable = $(this).data('value');
    $('input[name="selected-vegetable"]').val(selectedVegetable);
  });
});
  