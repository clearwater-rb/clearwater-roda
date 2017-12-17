require 'clearwater/component'

require 'store' # Need this for the State module
require 'actions' # Need to load the actions we want to dispatch

# This is our default homepage component. Note that in the Layout component, we
# render this by calling HomePage.new. This means we get a brand-new HomePage
# component each time we render, despite the Layout sticking around for the life
# of the app. Because of this, our HomePage cannot hold state and only knows
# about what it is told in its initialize method (which, in this case, is
# nothing).
class HomePage
  include Clearwater::Component
  include State[:counter, :name] # Add a reader method for attributes in app state

  def render
    article([
      h1('Welcome to Clearwater'),

      div([
        button({ onclick: Decrement }, '-'),
        counter,
        button({ onclick: Increment }, '+'),
      ]),

      div([
        input(value: name, oninput: SetName),
        div(name),
      ]),

      p(<<-EOP),
        Clearwater is a Ruby front-end framework.
      EOP
    ])
  end
end
