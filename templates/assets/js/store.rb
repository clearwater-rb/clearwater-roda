require 'grand_central/store'
require 'grand_central/model'

require 'actions'

class AppState < GrandCentral::Model
  attributes(
    :counter,
    :name,
  )
end

initial_state = AppState.new(
  counter: 0,
)

handler = proc do |state, action|
  case action
  when Increment
    state.update counter: state.counter + 1
  when Decrement
    state.update counter: state.counter - 1
  when SetName
    state.update name: action.name

  # If an unknown action was dispatched, we just return the current state.
  # It is important to return a state object that matches the structure of
  # the previous one. It becomes the new app state.
  else
    state
  end
end

# Allow swapping out handlers on the same store for hot-loaded code in dev.
if defined? Store
  Store.handler = handler
else
  Store = GrandCentral::Store.new(initial_state, &handler)
end

# on_dispatch takes an optional tag that lets hot loading replace the previous
# incarnation. Here we tag this block as containing our side effects.
Store.on_dispatch :side_effects do |before, after, action|
  # Add side effects based on action
end

# When you want to use application state in a component, you can use this module
# to add the attribute methods to that component using the following pattern:
#
#   class MyCounter
#     include Clearwater::Component
#     include State[:counter]
#
#     def render
#       div(counter)
#     end
#   end
module State
  # If we need to mix the same attributes into two different components, we
  # can reuse the same mixin.
  @module_cache = {}

  def self.[](*attrs)
    @module_cache.fetch(attrs) do
      @module_cache[attrs] = Module.new do
        attrs.each do |attr|
          define_method(attr) { Store.state.send(attr) }
        end
      end
    end
  end
end

# Let our actions know where they dispatch to by default
Action.store = Store
