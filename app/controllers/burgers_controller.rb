
class BurgersController < ApplicationController
  def index
    burgers = Burger.order('id ASC');
    render json: burgers.map{|burger| {id: burger[:id], nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
      ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}, status: 200
  end

  def show
    burger = Burger.find(params[:id])
    if params[:id].is_a? String
        burger = Burger.find(params[:id])
        if burger == nil
          render json: {message: 'Hamburguesa inexistente'}, status: 404
        else
          render json: {id: burger[:id], nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
            ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}, status: 200
        end
    else
        render json: {message: 'ID inválido'}, status: 400
    end
  end

  def create
    burger = Burger.new(burger_params)
    if burger.save
      render json: burger, status: 201
    else
      render json: {message: 'Input inválido'}, status: 400
    end
  end

  def destroy
    burger = Burger.find(params[:id])
    if burger == nil
      render json: {message: 'Hamburguesa inexistente'}, status: 404
    else
      burger.destroy
      render json: {message: 'Hamburguesa eliminada'}, status: 200
    end
  end

  def update
    burger = Burger.find(params[:id])
    if burger == nil
        render json: {message: 'Hamburguesa inexistente'}, status: 404
    else
      if burger_params[:id] || burger_params[:ingredientes]
        render json: {message: 'Parámetros inválidos'}, status: 400
      else
        if burger.update_attributes(burger_params)
          render json: burger, status: 200
        else
          render json: {message: 'Parámetros inválidos'}, status: 400
        end
      end
    end
  end

  private
  def burger_params
    params.permit(:nombre, :precio, :descripcion, :imagen)
  end
end
