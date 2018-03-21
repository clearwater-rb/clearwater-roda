require 'grand_central/action'

# Here we define an action taxonomy
#
# GrandCentral::Action
# |
# + Action -- Your top application-level action
#   |
#   + CounterAction
#   | |
#   | + Increment
#   | + Decrement
#   |
#   + SetName

# This lets your store handle entire classes of actions with a single check,
# which is very helpful in large apps with hundreds of actions:
#
#   store = GrandCentral::Store.new(initial_state) do |state, action|
#     case action
#     when CounterAction
#       # Handles both Increment and Decrement
#     when SetName
#       # ...
#     else state
#   end

# Create a top-level action, allowing for hot-loading not to overwrite it.
unless defined? Action
  Action = GrandCentral::Action.create
end

CounterAction = Action.create do
  Increment = create
  Decrement = create
end

SetName = Action.with_attributes(:name)
