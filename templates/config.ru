require 'bundler/setup'
require './%{underscored_name}'

$LOAD_PATH << 'lib'

run %{titleized_name}
