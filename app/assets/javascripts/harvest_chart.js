document.addEventListener('DOMContentLoaded', function() {
  var toggleGraphBtn = document.getElementById('toggleGraphBtn');
  var graphVisible = false;

  toggleGraphBtn.addEventListener('click', function() {
    graphVisible = !graphVisible;
    var graphContainer = document.getElementById('graphContainer'); // グラフのコンテナ要素を取得
    var savingsContainer = document.getElementById('savingsContainer'); // 節約額のグラフのコンテナ要素を取得
    graphContainer.style.display = graphVisible ? 'block' : 'none';
    savingsContainer.style.display = graphVisible ? 'block' : 'none';
    toggleGraphBtn.textContent = graphVisible ? 'グラフを非表示' : 'グラフを表示';
  });

  var ctx1 = document.getElementById('harvestChart').getContext('2d');
  var ctx2 = document.getElementById('savingsChart').getContext('2d');
  var vegetableTypes = JSON.parse(ctx1.canvas.getAttribute('data-vegetables'));
  var amounts = JSON.parse(ctx1.canvas.getAttribute('data-amounts'));
  var savings = JSON.parse(ctx2.canvas.getAttribute('data-savings'));

  // 野菜の種類と対応する色のマッピング
  var vegetableColors = {
    "トマト": "rgba(255, 99, 132, 1)", // トマトの色を設定
    "バジル": "rgba(75, 192, 192, 1)", // バジルの色を緑に設定
    "にんじん": "rgba(255, 159, 64, 1)", // にんじんの色をオレンジに設定
    // 他の野菜に対しても適切な色を追加可能
  };

  // グラフ共通のオプション設定
  var commonOptions = {
    scales: {
      x: {
        title: {
          display: true,
          text: '野菜の種類' // 横軸のラベルを変更
        },
        beginAtZero: true
      },
      y: {
        beginAtZero: true
      }
    }
  };

  // 収穫量の棒グラフデータセットの準備
  var harvestDataset = {
    labels: vegetableTypes, // 野菜の種類をラベルとして使用
    datasets: [{
      label: '収穫量',
      data: amounts,
      backgroundColor: vegetableTypes.map(vegetable => vegetableColors[vegetable] || "rgba(153, 102, 255, 1)")
    }]
  };

  // 節約額の棒グラフデータセットの準備
  var savingsDataset = {
    labels: vegetableTypes, // 野菜の種類をラベルとして使用
    datasets: [{
      label: '節約額',
      data: savings,
      backgroundColor: vegetableTypes.map(vegetable => vegetableColors[vegetable] || "rgba(153, 102, 255, 1)")
    }]
  };

  // 収穫量の棒グラフ
  new Chart(ctx1, {
    type: 'bar', // 棒グラフに変更
    data: harvestDataset,
    options: commonOptions // グラフ共通のオプションを使用
  });

  // 節約額の棒グラフ
  new Chart(ctx2, {
    type: 'bar', // 棒グラフに変更
    data: savingsDataset,
    options: commonOptions // グラフ共通のオプションを使用
  });
});
