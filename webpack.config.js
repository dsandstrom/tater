'use strict';

const path = require("path");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');

var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

var plugins = [
  new ExtractTextPlugin("css/app.css"),
  new CopyWebpackPlugin([{from: "./web/static/assets"}]),
];

if (isProduction) {
  plugins.push(
    new UglifyJSPlugin({
      sourceMap: true,
      uglifyOptions: {
        output: {
          comments: false,
          beautify: false,
        }
      }
    }),
    new OptimizeCssAssetsPlugin({
      assetNameRegExp: /\.css$/g,
      cssProcessor: require('cssnano'),
      cssProcessorOptions: { discardComments: {removeAll: true } },
      canPrint: true
    })
  );
}

module.exports = {
  entry: ["./web/static/js/app.js", "./web/static/css/app.scss"],

  output: {
    path: path.resolve(__dirname, "priv/static"),
    filename: "js/app.js"
  },

  resolve: {
    modules: ["node_modules", path.resolve(__dirname, "/web/static/js")]
  },

  devtool: "source-map",

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules|bower_components/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("css-loader")
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [
            {
              loader: "css-loader",
              options: {
                 sourceMap: true
              }
            },
            {
              loader: "sass-loader",
              options: {
                includePaths: ["node_modules"],
                sourceMap: true
              }
            }
          ]
        })
      }
    ]
  },

  plugins: plugins
};
