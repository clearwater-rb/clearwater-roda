require 'clearwater/component'

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
