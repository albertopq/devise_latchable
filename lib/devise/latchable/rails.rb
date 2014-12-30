require 'devise/latchable/rails/routes'

module DeviseLatchable
  class Engine < Rails::Engine
    paths["app/controllers"] = "lib/controllers"
  end
end
