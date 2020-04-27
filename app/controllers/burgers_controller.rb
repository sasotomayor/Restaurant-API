
class BurgersController < ApplicationController
  def index
    burgers = Burger.order('id ASC');
    #render json: {status: 'SUCCESS', message: 'Loaded burgers', data:burgers}, status: :ok
    render json: {status: 'SUCCESS', message: 'Todas las hamburguesas del menú', data:burgers.map{|burger| {id: burger[:id],
      nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
      ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}}, status: :ok
  end

  def show
    burger = Burger.find(params[:id])
    render json: {status: 'SUCCESS', message: 'Hamburguesa solicitada', data: {id: burger[:id],
      nombre: burger[:nombre], descripcion: burger[:descripcion], imagen: burger[:imagen],
      ingredientes: burger.ingredients.map{|ing| {path: "https://whispering-thicket-50827.herokuapp.com/ingrediente/#{ing[:id]}"}}}}, status: :ok
  end

  def create
    burger = Burger.new(burger_params)
    if burger.save
      render json: {status: 'SUCCESS', message: 'Hamburguesa creada', data:burger}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Hamburguesa no se ha creado', data:burger.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    burger = Burger.find(params[:id])
    burger.destroy
    render json: {status: 'SUCCESS', message: 'Hamburguesa eliminada', data:burger}, status: :ok
  end

  def update
    burger = Burger.find(params[:id])
    if burger_params[:id] || burger_params[:ingredientes]
      render json: {status: 'ERROR', message: 'Hamburguesa no se ha modificado', data:burger}, status: :ok
    else
      if burger.update_attributes(burger_params)
        render json: {status: 'SUCCESS', message: 'Hamburguesa modificada', data:burger}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Hamburguesa no se ha modificado', data:burger}, status: :ok
      end
    end
  end

  private
  def burger_params
    params.permit(:nombre, :precio, :descripcion, :imagen)
  end
end
