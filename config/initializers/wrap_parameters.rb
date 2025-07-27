# frozen_string_literal: true

# Enable parameter wrapping for JSON
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json]
end
