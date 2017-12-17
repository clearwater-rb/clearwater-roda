require 'bundler'
Bundler.setup :default, :production

require './%{underscored_name}'

$LOAD_PATH << 'lib'

use Rack::Deflater
use Rack::CommonLogger
run %{titleized_name}
