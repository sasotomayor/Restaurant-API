
class BurgersController < ApplicationController
  def index
    burgers = Burger.order('id ASC');
    render json: {status: 'SUCCESS', message: 'Todas las hamburguesas del menú', data:burgers.map{|burger| {id: burger[:id],
      nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
      ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}}, status: 200
  end

  def show
    burger = Burger.find(params[:id])
    if burger.empty?
      render json: {status: 'ERROR', message: 'Hamburguesa inexistente', data: {}}, status: 404
    else
      render json: {status: 'SUCCESS', message: 'Hamburguesa solicitada', data: {id: burger[:id],
        nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
        ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}, status: 200
    end
  end

  def create
    burger = Burger.new(burger_params)
    if burger.save
      render json: {status: 'SUCCESS', message: 'Hamburguesa creada', data:burger}, status: 201
    else
      render json: {status: 'ERROR', message: 'Hamburguesa no se ha creado', data:burger.errors}, status: 400
    end
  end

  def destroy
    burger = Burger.find(params[:id])
    if burger.empty?
      render json: {status: 'ERROR', message: 'Hamburguesa inexistente', data:{}}, status: 404
    else
      burger.destroy
      render json: {status: 'SUCCESS', message: 'Hamburguesa eliminada', data:burger}, status: 200
    end
  end

  def update
    burger = Burger.find(params[:id])
    if burger.empty?
        render json: {status: 'ERROR', message: 'Hamburguesa inexistente', data:burger}, status: 404
    end
    if burger_params[:id] || burger_params[:ingredientes]
      render json: {status: 'ERROR', message: 'Parámetros inválidos', data:burger}, status: 400
    else
      if burger.update_attributes(burger_params)
        render json: {status: 'SUCCESS', message: 'Hamburguesa modificada', data:burger}, status: 200
      else
        render json: {status: 'ERROR', message: 'Hamburguesa no se ha modificado', data:burger}, status: 400
      end
    end
  end

  private
  def burger_params
    params.permit(:nombre, :precio, :descripcion, :imagen)
  end
end
