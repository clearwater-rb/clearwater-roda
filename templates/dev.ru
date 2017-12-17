require 'bundler'
Bundler.setup :default, :development
$LOAD_PATH << 'app'
require 'assets'

require './%{underscored_name}'

Clearwater::HotLoader.start

class %{titleized_name}Dev < %{titleized_name}
  route do |r|
    r.on('clearwater_hot_loader') { r.run Clearwater::HotLoader }

    instance_exec(r, &self.class.superclass.route_block)
  end

  def app_title
    '%{titleized_name} [DEV]'
  end

  def client_app
    'dev'
  end

  def additional_markup
    <<~HTML
      <div id="grand-central-dev-tools"></div>
    HTML
  end
end

use Rack::CommonLogger
run %{titleized_name}Dev
