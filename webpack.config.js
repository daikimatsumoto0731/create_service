const path = require('path');

module.exports = {
  entry: './app/javascript/packs/application.js', // RailsのWebpackerエントリポイント
  output: {
    path: path.resolve(__dirname, 'public/packs'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  }
};
