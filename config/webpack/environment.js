const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

// environment.plugins.delete('CaseSensitivePathsPlugin')
environment.plugins.delete('CaseSensitivePathsPlugin');

module.exports = environment
