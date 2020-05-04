class IngredientsController < ApplicationController
  def index
    ingredients = Ingredient.order('id ASC');
    render json: ingredients, status: 200
  end

  def show
    if params[:id].is_a? String
      ingredient = Ingredient.find(params[:id])
      if ingredient != nil
        render json: ingredient, status: 200
      else
        render json: {message: 'Ingrediente inexistente'}, status: 404
      end
    else
        render json: {message: 'ID inválido'}, status: 400
    end
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    if ingredient_params[:nombre] && ingredient_params[:descripcion]
      if ingredient.save
        render json: {id: ingredient[:id], nombre: ingredient[:nombre], descripcion: ingredient[:descripcion]}, status: 201
      else
        render json: {message: 'Input inválido'}, status: 400
      end
    else
      render json: {message: 'Input inválido'}, status: 400
    end
  end

  def destroy
    ingredient = Ingredient.find(params[:id])
    if ingredient == nil
      render json: {message: 'Ingrediente inexistente'}, status: 404
    else
      if params[:burger_id]
        burger = Burger.find(params[:burger_id])
        if burger == nil
          render json: {message: 'ID inválido'}, status: 400
        else
          if burger.ingredients.include? ingredient
            burger.ingredients.delete(ingredient)
            render json: {message: 'Ingrediente retirado'}, status: 200
          else
            render json: {message: 'Ingrediente inexistente en la hamburguesa'}, status: 404
          end
        end
      else
        if ingredient.burgers.empty?
          ingredient.destroy
          render json: {message: 'Ingrediente eliminado'}, status: 200
        else
          render json: {message: 'Ingrediente no se puede borrar, se encuentra presente en una hamburguesa'}, status: 409
        end
      end
    end
  end

  def update
    ingredient = Ingredient.find(params[:id])
    burger = Burger.find(params[:burger_id])
    if ingredient == nil
      render json: {message: 'Ingrediente inexistente'}, status: 404
    else
      if burger == nil
        render json: {message: 'ID de hamburguesa inválido'}, status: 400
      else
        burger.ingredients << ingredient
        if ingredient.update_attributes(ingredient_params)
          render json: {message: 'Ingrediente agregado'}, status: 201
        else
          render json: {message: 'ID iválido'}, status: 400
        end
      end
    end
  end

  private
  def ingredient_params
    params.permit(:nombre, :descripcion)
  end
end
