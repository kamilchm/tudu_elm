var path = require('path')

var WebpackPwaManifest = require('webpack-pwa-manifest')

const elmMake = process.env.ELM_MAKE || 'elm-make';

module.exports = {
    entry: {
        app: [
            './src/index.js'
        ]
    },

    output: {
        path: path.resolve(__dirname + '/dist'),
        filename: '[name].js',
    },

    module: {
      rules: [
        {
          test: /\.(css|scss)$/,
          use: [
            'style-loader',
            'css-loader',
          ]
        },
        {
          test:    /\.html$/,
          exclude: /node_modules/,
          loader:  'file-loader?name=[name].[ext]',
        },
        {
          test:    /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader:  `elm-webpack-loader?debug=true&verbose=true&warn=true&pathToMake=${elmMake}`,
        },
        {
          test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          loader: 'url-loader?limit=10000&mimetype=application/font-woff',
        },
        {
          test: /\.(ttf|eot|svg|mp3)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          loader: 'file-loader',
        },
      ],

      noParse: /\.elm$/,
    },

    plugins: [
      new WebpackPwaManifest({
        name: 'tudu',
        short_name: 'tudu',
        description: 'so many things to do',
        background_color: '#209cee',
        theme_color: '#209cee',
        display: 'standalone',
        fingerprints: false,
        icons: [],
      })
    ],

    devServer: {
      inline: true,
      stats: { colors: true },
    },
};
