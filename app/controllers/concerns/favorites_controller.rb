class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    puts "ここを見ろ"
    #p params
    micropost = Micropost.find(params[:micropost_id])  #find_byにしてみた
    puts 'ここを見ろお'
    current_user.favorite(micropost)
    #@micropost.favorite(correct_user)
    flash[:success] = '投稿をお気に入りにしました。'
    redirect_back(fallback_location: root_path)
    #redirect_to current_user
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    #@micropost.unfavorite(correct_user)
    flash[:success] = '投稿をお気に入りから解除しました。'
    redirect_back(fallback_location: root_path)
    #redirect_to current_user
  end
end
