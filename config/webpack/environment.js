const { environment } = require('@rails/webpacker')
environment.plugins.delete('CaseSensitivePathsPlugin')

module.exports = environment
