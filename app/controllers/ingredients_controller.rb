class IngredientsController < ApplicationController
  def index
    ingredients = Ingredient.order('id ASC');
    render json: {status: 'SUCCESS', message: 'Loaded ingredients', data:ingredients}, status: :ok
  end

  def show
    ingredient = Ingredient.find(params[:id])
    render json: {status: 'SUCCESS', message: 'Loaded ingredient', data:ingredient}, status: :ok
  end

  def create
    ingredient = Ingredient.new(ingredient_params)

    if ingredient.save
      render json: {status: 'SUCCESS', message: 'Saved ingredient', data:ingredient}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Ingredient not saved', data:ingredient.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    ingredient = Ingredient.find(params[:id])
    if params[:burger_id]
      burger = Burger.find(params[:burger_id])
      burger.ingredients.delete(ingredient)
      render json: {status: 'SUCCESS', message: 'Removed ingredient', data:ingredient}, status: :ok
    else
      if ingredient.burgers.empty?
        ingredient.destroy
        render json: {status: 'SUCCESS', message: 'Deleted ingredient', data:ingredient}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Ingredient not deleted', data:ingredient}, status: :ok
      end
    end
  end

  def update
    ingredient = Ingredient.find(params[:id])
    burger = Burger.find(params[:burger_id])
    burger.ingredients << ingredient
    if ingredient.update_attributes(ingredient_params)
      render json: {status: 'SUCCESS', message: 'Added ingredient', data:ingredient}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Ingredient not added', data:ingredient}, status: :ok
    end
  end

  private
  def ingredient_params
    params.permit(:name, :description)
  end
end
