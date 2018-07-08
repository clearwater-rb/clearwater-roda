require 'roda'
require 'roda/opal_assets'
require 'opal'

class %{titleized_name} < Roda
  plugin :public

  assets = Roda::OpalAssets.new

  route do |r|
    r.public
    assets.route r

    <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>#{app_title}</title>
  </head>

  <body>
    <div id="app"></div>
    #{additional_markup}
    #{assets.js client_app}
  </body>
</html>
    HTML
  end

  def app_title
    '%{titleized_name}'
  end

  def client_app
    'app.js'
  end

  def additional_markup
  end
end
