const path = require('path');

module.exports = {
  entry: './app/javascript/packs/application.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public/assets')
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
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  node: false // この行を変更しました
};
