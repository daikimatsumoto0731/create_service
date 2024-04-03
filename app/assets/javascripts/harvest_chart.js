document.addEventListener('DOMContentLoaded', function() {
  var toggleGraphBtn = document.getElementById('toggleGraphBtn');
  var graphContainer = document.getElementById('graphContainer');
  var graphVisible = false;

  toggleGraphBtn.addEventListener('click', function() {
    graphVisible = !graphVisible;
    graphContainer.style.display = graphVisible ? 'block' : 'none';
    toggleGraphBtn.textContent = graphVisible ? 'グラフを非表示' : 'グラフを表示';
  });

  var ctx = document.getElementById('relationshipChart').getContext('2d');
  var vegetableTypes = JSON.parse(ctx.canvas.getAttribute('data-vegetables'));
  var amounts = JSON.parse(ctx.canvas.getAttribute('data-amounts'));
  var savings = JSON.parse(ctx.canvas.getAttribute('data-savings'));

  // 野菜の種類と対応する色のマッピング
  var vegetableColors = {
    "トマト": "rgba(255, 99, 132, 1)",
    "バジル": "rgba(54, 162, 235, 1)",
    // 他の野菜に対しても追加可能
  };

  // 散布図データセットの準備
  var datasets = vegetableTypes.map(function(vegetable, index) {
    return {
      label: vegetable,
      data: [{
        x: amounts[index],
        y: savings[index]
      }],
      backgroundColor: vegetableColors[vegetable] || "rgba(153, 102, 255, 1)",
    };
  });

  new Chart(ctx, {
    type: 'scatter',
    data: {
      datasets: datasets
    },
    options: {
      scales: {
        x: {
          title: {
            display: true,
            text: '累計収穫量 (kg)'
          },
          beginAtZero: true
        },
        y: {
          title: {
            display: true,
            text: '累計節約額 (円)'
          },
          beginAtZero: true
        }
      }
    }
  });
});
