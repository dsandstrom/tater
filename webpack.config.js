module.exports = {
  entry: "/Users/dsandstrom/Projects/elixir/tater/web/static/js/app.js",
  output: {
    path: "/Users/dsandstrom/Projects/elixir/tater/priv/static/js",
    filename: "app.js"
  },
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
