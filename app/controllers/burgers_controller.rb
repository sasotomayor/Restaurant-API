class BurgersController < ApplicationController
  def index
    burgers = Burger.order('id ASC');
    render json: burgers.map{|burger| {id: burger[:id], nombre: burger[:nombre], descripcion: burger[:descripcion], precio: burger[:precio], imagen: burger[:imagen],
      ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}, status: 200
  end

  def show
    if params[:id]
      if Burger.where(id: params[:id]).empty?
        render json: {message: 'Hamburguesa inexistente'}, status: 404
      else
        burger = Burger.find(params[:id])
        render json: {id: burger[:id], nombre: burger[:nombre], descripcion: burger[:descripcion], precio: burger[:precio], imagen: burger[:imagen],
          ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}, status: 200
      end
    else
      render json: {message: 'ID inválido'}, status: 400
    end
  end

  def create
    burger = Burger.new(burger_params)
    if burger_params[:nombre] && burger_params[:descripcion] && burger_params[:imagen] && burger_params[:precio]
      if burger.save
        render json: {id: burger[:id], nombre: burger[:nombre], descripcion: burger[:descripcion], precio: burger[:precio], imagen: burger[:imagen],
          ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}, status: 201
      else
        render json: {message: 'Input inválido'}, status: 400
      end
    else
      render json: {message: 'Input inválido'}, status: 400
    end
  end

  def destroy
    if Burger.where(id: params[:id]).empty?
      render json: {message: 'Hamburguesa inexistente'}, status: 404
    else
      burger = Burger.find(params[:id])
      burger.destroy
      render json: {message: 'Hamburguesa eliminada'}, status: 200
    end
  end

  def update
    if Burger.where(id: params[:id]).empty?
        render json: {message: 'Hamburguesa inexistente'}, status: 404
    else
      burger = Burger.find(params[:id])
      if burger_params[:precio] || burger_params[:nombre] || burger_params[:descricion] || burger_params[:imagen]
        if burger.update_attributes(burger_params)
          render json: burger, status: 200
        else
          render json: {message: 'Parámetros inválidos'}, status: 400
        end
      else
        render json: {message: 'Parámetros inválidos'}, status: 400
      end
    end
  end

  private
  def burger_params
    params.permit(:nombre, :precio, :descripcion, :imagen)
  end
end
