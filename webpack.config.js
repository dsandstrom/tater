const path = require('path');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: ["./web/static/js/app.js", "./web/static/css/app.scss"],
  output: {
    path: path.resolve(__dirname, "priv/static"),
    filename: "js/app.js"
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
    }],
    rules: [{
      test: /\.scss$/,
      use: ExtractTextPlugin.extract({
        use: [{
          loader: "css-loader" // translates CSS into CommonJS
        }, {
          loader: "sass-loader", // compiles Sass to CSS
          options: {
            includePaths: ["node_modules"]
          }
        }],
        fallback: "style-loader" // use style-loader in development
      })
    }]
  },

  plugins: [
    new ExtractTextPlugin("css/app.css")
  ]
};
