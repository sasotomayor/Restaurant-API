class IngredientsController < ApplicationController
  def index
    ingredients = Ingredient.order('id ASC');
    render json: ingredients, status: 200
  end

  def show
    if Ingredient.where(id: params[:id]).empty?
      render json: {message: 'Ingrediente inexistente'}, status: 404
    else
      ingredient = Ingredient.find(params[:id])
      render json: ingredient, status: 200
    end
  end

  def create
    ingredient = Ingredient.new(ingredient_params)
    if ingredient_params[:nombre] && ingredient_params[:descripcion]
      if ingredient.save
        render json: ingredient, status: 201
      else
        render json: {message: 'Input inválido'}, status: 400
      end
    else
      render json: {message: 'Input inválido'}, status: 400
    end
  end

  def destroy
    if Ingredient.where(id: params[:id]).empty?
      render json: {message: 'Ingrediente inexistente'}, status: 404
    else
      ingredient = Ingredient.find(params[:id])
      if params[:burger_id]
        if Burger.where(id: params[:burger_id]).empty?
          render json: {message: 'ID de hamburguesa inválido'}, status: 400
        else
          burger = Burger.find(params[:burger_id])
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
    if Ingredient.where(id: params[:id]).empty?
      render json: {message: 'Ingrediente inexistente'}, status: 404
    else
      ingredient = Ingredient.find(params[:id])
      if Burger.where(id: params[:burger_id]).empty?
        render json: {message: 'ID de hamburguesa inválido'}, status: 400
      else
        burger = Burger.find(params[:burger_id])
        burger.ingredients << ingredient
        if ingredient.update_attributes(ingredient_params)
          render json: {message: 'Ingrediente agregado'}, status: 201
        else
          render json: {message: 'ID de hamburguesa in  válido'}, status: 400
        end
      end
    end
  end

  private
  def ingredient_params
    params.permit(:nombre, :descripcion)
  end
end
