var path = require('path')

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
            test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
            loader: 'file-loader',
          },
        ],

        noParse: /\.elm$/,
      },

      devServer: {
        inline: true,
        stats: { colors: true },
      },

};