class Devise::LatchController < DeviseController

  def pair
    @user = User.find(params[:id])
  end

  def unpair
    user = User.find(params[:id])
    user.unpair
    redirect_to user_path, :notice => 'Success'
  end

  def submit_token
    user = User.find(params[:id])
    user.pair params[:token]
    if user.errors[:token].empty?
      # set_flash_message :notice, :pair_success
      redirect_to user_path, :notice => 'Success'
    else
      set_flash_message :alert, user.errors[:token].first
      redirect_to user_pair_path
    end
  end
end


