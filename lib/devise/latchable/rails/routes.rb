module ActionDispatch::Routing
  class Mapper

    protected

    def devise_latch_pair(mapping, controllers)
      get 'pair' => 'devise/latch#pair', as: :pair
      post 'pair' => 'devise/latch#submit_token', as: :submit_token
      get 'unpair' => 'devise/latch#unpair', as: :unpair
    end
  end
end
