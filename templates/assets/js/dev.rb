require 'opal'
require 'app'
require 'store'

require 'grand_central/dev_tools'
require 'clearwater/hot_loader'

dev_tools = GrandCentral::DevTools.new(
  Store,
  Bowser.document['#grand-central-dev-tools']
)
dev_tools.start

Clearwater::HotLoader.connect 9292
