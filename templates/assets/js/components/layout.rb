require 'clearwater/component'

require 'components/home_page'

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
