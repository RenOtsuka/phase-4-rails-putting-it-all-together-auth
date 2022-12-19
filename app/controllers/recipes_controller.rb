class RecipesController < ApplicationController
  before_action :authorize
  # skip_before_action :authorize, only:[:create] 

  def index
      recipes = Recipe.all
      render json: recipes, include: :user, status: :created
  end

  def create
    user = User.find(session[:user_id])
    recipe = user.recipes.create(recipe_params)
    if recipe.valid?
      render json: recipe, include: :user, status: :created
    else
      render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private 

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def authorize
    return render json: {errors: ["User Not Logged In"]}, status: :unauthorized unless session.include? :user_id
  end
end
