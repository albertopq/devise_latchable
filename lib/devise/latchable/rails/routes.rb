module ActionDispatch::Routing
  class Mapper

    protected

    def devise_latch_pair(mapping, controllers)
      get ':id/pair' => 'devise/latch#pair', as: :pair
      post ':id/pair' => 'devise/latch#submit_token', as: :submit_token
      get ':id/unpair' => 'devise/latch#unpair', as: :unpair
    end
  end
end
