class UsersController < ApplicationController
  include Pagy::Backend

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
    @user.reload
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Bio was successfully updated.'
    else
      render :edit
    end
  end

   def index
    @users = User.by_area_of_study(params[:area_of_study])
      case params[:tipo_ajuda]
  when 'Apoio Estudo'
    @users = @users.where(apoio_estudo: true)
  when 'Apoio á Integração'
    @users = @users.where(ajuda_social: true)
  when 'Apoio Bolsas'
    @users = @users.where(apoio_bolsas: true)
  end

  @pagy, @mentors = pagy(mentors, items: 8)


  if params[:tipo_ajuda] == 'Apoio Estudo' && params[:area_of_study].present?
    @users = @users.where(area_of_study: params[:area_of_study])
  end
end


   end


    private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :bio,
      :area_of_study,
      :current_year,
      :mentor,
      :student_id,
      :apoio_estudo,
      :ajuda_social,
      :apoio_bolsas,
      :photo,
      :active_mentorships_count
    )
  end
