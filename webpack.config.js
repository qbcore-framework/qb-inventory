const HtmlWebpackPlugin = require('html-webpack-plugin');
const { VueLoaderPlugin } = require("vue-loader");
const CopyPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

module.exports = {
    mode: 'production',
    entry: './html_app/index.js',
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.(png|jpg)$/i,
                loader: 'file-loader',
                options: {
                    name: '[path][name].[ext]',
                    outputPath: url => url.slice(url.indexOf(`/`) + 1)
                },
            },
            {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader'
                ]
            }
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new HtmlWebpackPlugin({
            inlineSource: '.(js|css)$',
            template: './html_app/index.html',
            filename: 'ui.html'
        }),
        new MiniCssExtractPlugin(),
        // new HtmlWebpackInlineSourcePlugin(),
        new CopyPlugin([
            { from: 'html_app/index.css', to: 'index.css' }
        ]),
    ],
    resolve: {
        extensions: [ '.js' ]
    },
	output: {
		filename: 'app.js',
		path: __dirname + '/html/'
    },
    //devtool: 'inline-source-map'
};