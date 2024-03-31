document.addEventListener('DOMContentLoaded', function() {
  var graphContainer = document.getElementById('graphContainer');
  var toggleGraphBtn = document.getElementById('toggleGraphBtn');
  var graphVisible = false;

  // グラフの初期表示を非表示にする
  graphContainer.style.display = 'none';

  // ボタンをクリックしたときの動作
  toggleGraphBtn.addEventListener('click', function() {
    // グラフの表示・非表示を切り替える
    graphVisible = !graphVisible;
    graphContainer.style.display = graphVisible ? 'block' : 'none';
    toggleGraphBtn.textContent = graphVisible ? 'グラフを非表示' : 'グラフを表示';
  });

  // グラフの描画
  var ctx = document.getElementById('harvestChart').getContext('2d');
  var vegetableTypes = JSON.parse(ctx.canvas.getAttribute('data-vegetables'));
  var amounts = JSON.parse(ctx.canvas.getAttribute('data-amounts'));
  var savings = JSON.parse(ctx.canvas.getAttribute('data-savings'));

  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: vegetableTypes, // X軸に表示するラベル（野菜の種類）
      datasets: [{
        label: '累計収穫量(kg)', // 累計収穫量のデータセット
        backgroundColor: 'rgba(255, 99, 132, 0.2)', // グラフの背景色
        borderColor: 'rgba(255, 99, 132, 1)', // グラフの枠線色
        data: amounts // Y軸に表示するデータ（累計収穫量）
      }, {
        label: '累計節約額(円)', // 累計節約額のデータセット
        backgroundColor: 'rgba(54, 162, 235, 0.2)', // グラフの背景色
        borderColor: 'rgba(54, 162, 235, 1)', // グラフの枠線色
        data: savings, // Y軸に表示するデータ（累計節約額）
        // 累計節約額データを右側のY軸に関連付ける
        yAxisID: 'y-axis-savings'
      }]
    },
    options: {
      scales: {
        y: { // 左側のY軸（累計収穫量用）
          beginAtZero: true,
          position: 'left',
          id: 'y-axis-amount'
        },
        'y-axis-savings': { // 右側のY軸（累計節約額用）
          beginAtZero: true,
          position: 'right',
          grid: {
            drawOnChartArea: false, // 右側のY軸に対応するグリッドラインは描画しない
          },
        }
      }
    }
  });
});
