require 'opal'
require 'clearwater'

class Layout
  include Clearwater::Component

  def render
    # Equivalent HTML:
    # <div>
    #   <h1 class="heading">
    #     <a href="/">Hello, Clearwater</a>
    #   </h1>
    #   <nav>
    #     <a href="/foo">Foo</a>
    #     <a href="/bar">Bar</a>
    #     <a href="/bar/baz">Baz</a>
    #   </nav>
    #   <%%= outlet || HomePage.new.render %%>
    # </div>
    div([
      h1({ class_name: 'heading' }, [
        Link.new({ href: '/' }, 'Hello, Clearwater!'),
      ]),
      nav([
        # The Link component is how you navigate between routes in Clearwater
        # apps. This leaves the `a` helper method to do a typical hard link.
        Link.new({ href: '/foo' }, 'Foo'),

        # One of the nice things about defining your UI with code instead of
        # markup is that adding whitespace doesn't look out of place.
        ' ',
        Link.new({ href: '/bar' }, 'Bar'),
        ' ',
        Link.new({ href: '/bar/baz' }, 'Baz'),
      ]),

      # The `outlet` method is a method for routing targets to render their
      # child routes, similar to the same keyword in Ember.js templates. If
      # there is no child route, we render a HomePage component.
      outlet || HomePage.new,
    ])
  end
end

# This is our default homepage component. Note that in the Layout component, we
# render this by calling HomePage.new. This means we get a brand-new HomePage
# component each time we render, despite the Layout sticking around for the life
# of the app. Because of this, our HomePage cannot hold state and only knows
# about what it is told in its initialize method (which, in this case, is
# nothing).
class HomePage
  include Clearwater::Component

  def render
    article([
      h1('Welcome to Clearwater'),

      p(<<-EOP),
        Clearwater is a Ruby front-end framework.
      EOP
    ])
  end
end

# We use a Struct here because it's shorthand for a class that takes an argument
# and gives us an accessor method with that name. Otherwise, it's identical to a
# typical template; we just wanted to take an argument.
ChildRoute = Struct.new(:name) do
  include Clearwater::Component

  def render
    div([
      h2(name),
      p("This is the child route called #{name}"),

      div([
        h3('Child content:'),
        outlet,
      ]),
    ])
  end
end

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
