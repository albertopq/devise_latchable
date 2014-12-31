class Devise::LatchController < DeviseController

  before_action :authenticate_user!

  # GET /resource/:id/pair
  def pair
    @user = current_user
  end

  # GET /resource/:id/unpair
  def unpair
    current_user.unpair
    set_flash_message :notice, :unpair_success
    redirect_to user_path(current_user)
  end


  # POST /resource/:id/pair
  def submit_token
    current_user.pair params[:token]
    if current_user.errors[:token].empty?
      set_flash_message :notice, :pair_success
      redirect_to user_path(current_user)
    else
      set_flash_message :error, current_user.errors[:token].first
      redirect_to user_pair_path
    end
  end
end


