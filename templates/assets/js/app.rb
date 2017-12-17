require 'opal'
require 'clearwater'

require 'store'
require 'components/layout'
require 'components/child_route'

router = Clearwater::Router.new do
  # Routing targets are other components. They stick around for the life of the
  # app, so they can store state or you can use them to fetch state from a data
  # store somewhere else in your app.
  #
  # Syntax:
  #   route path_segment => target
  #   route another_segment => another_target do
  #     route
  #   end
  route 'foo' => ChildRoute.new('foo')
  route 'bar' => ChildRoute.new('bar') do
    route 'baz' => ChildRoute.new('baz')
  end
end

# The Clearwater app itself takes 3 args:
app = Clearwater::Application.new(
  # The component is any component that includes the Clearwater::Component mixin
  component: Layout.new,

  # This is the router we created above. If you're not using routing, you can
  # safely omit this.
  router: router,

  # This is any existing element on the page. Note that it has to exist already
  # at this point, so unless you're delaying the execution of this script with
  # DOM events, you'll need to put the script tag below the element you're
  # rendering into. This is usually accomplished by putting the script tag at
  # the bottom of the <body> element.
  element: Bowser.document['#app'],
)

# Uncomment the following line to display timing information in the console on
# every render.
#
#   app.debug!

# This adds the app to the Clearwater app registry (so it can be re-rendered on
# route changes) and triggers the first render. Subsequent renders should use
# app.render instead.
app.call

# When actions are dispatched to the store, check to see if they change the
# state. If so, re-render the app.
Store.on_dispatch do |before, after, action|
  app.render unless before.equal?(after)
end
