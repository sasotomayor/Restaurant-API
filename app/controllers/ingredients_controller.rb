class IngredientsController < ApplicationController
  def index
    ingredients = Ingredient.order('id ASC');
    render json: {status: 'SUCCESS', message: 'Todos los ingredientes del menú', data:ingredients}, status: :ok
  end

  def show
    ingredient = Ingredient.find(params[:id])
    render json: {status: 'SUCCESS', message: 'Ingrediente solicitado', data:ingredient}, status: :ok
  end

  def create
    ingredient = Ingredient.new(ingredient_params)

    if ingredient.save
      render json: {status: 'SUCCESS', message: 'Ingrediente creado', data:ingredient}, status: 201
    else
      render json: {status: 'ERROR', message: 'Ingrediente no se ha creado', data:ingredient.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    ingredient = Ingredient.find(params[:id])
    if params[:burger_id]
      burger = Burger.find(params[:burger_id])
      burger.ingredients.delete(ingredient)
      render json: {status: 'SUCCESS', message: 'Ingrediente eliminado de la hamburguesa', data:ingredient}, status: :ok
    else
      if ingredient.burgers.empty?
        ingredient.destroy
        render json: {status: 'SUCCESS', message: 'Ingrediente eliminado', data:ingredient}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Ingrediente no se ha eliminado', data:ingredient}, status: :ok
      end
    end
  end

  def update
    ingredient = Ingredient.find(params[:id])
    burger = Burger.find(params[:burger_id])
    burger.ingredients << ingredient
    if ingredient.update_attributes(ingredient_params)
      render json: {status: 'SUCCESS', message: 'Ingrediente agregado a la hamburguesa', data:ingredient}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Ingrediente no agregado a la hamburguesa', data:ingredient}, status: :ok
    end
  end

  private
  def ingredient_params
    params.permit(:nombre, :descripcion)
  end
end
