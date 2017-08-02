const path = require('path');
var CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  entry: "./web/static/js/app.js",
  output: {
    path: path.resolve(__dirname, "priv/static/js"),
    filename: "app.js"
  },

  resolve: {
    modules: [ "node_modules", __dirname + "/web/static/js" ]
  },

  plugins: [
    new CopyWebpackPlugin([{ from: "./web/static/assets" }])
  ],

  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader",
      query: {
        presets: ["es2015"]
      }
    }]
  }
};
