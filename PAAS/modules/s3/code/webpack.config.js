const path = require('path');

module.exports = {
  entry: './main.js',
  resolve: {
    alias: {
        'aws-amplify': path.resolve(__dirname, 'node_modules/aws-amplify')
    }
    },
  output: {
    filename: 'index.js',
    path: path.resolve(__dirname, 'dist'),
  },
  mode: 'production',
  module: {
    rules: [
      {
        test: /\.m?js$/,
        exclude: /(node_modules)/,
        use: {
          loader: 'babel-loader',  // Optional: Transpile code for compatibility
          options: {
            presets: ['@babel/preset-env'],
          },
        },
      },
    ],
  },
};
