const path = require('path');

module.exports = {
  mode: 'production',
  entry: './src/index.js', // エントリーポイントのパスを設定
  output: {
    filename: 'bundle.js', // 出力ファイルの名前を設定
    path: path.resolve(__dirname, 'dist'), // 出力先ディレクトリを設定
  },
  module: {
    rules: [
      {
        test: /\.js$/, // JavaScript ファイルに対する処理を指定
        exclude: /node_modules/, // node_modules ディレクトリ内のファイルは処理対象外
        use: {
          loader: 'babel-loader', // Babel を使用して ECMAScript 新機能をトランスパイル
          options: {
            presets: ['@babel/preset-env'], // Babel のプリセットを指定
          },
        },
      },
    ],
  },
};
