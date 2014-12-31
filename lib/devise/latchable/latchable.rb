require 'devise/latchable/rails'

module Devise
  module Latchable
  end
end

Devise.add_module :latchable,
                  :model => 'devise/latchable/model',
                  :controller => 'controllers/latch',
                  :route => { :latch_pair => [:pair] }
