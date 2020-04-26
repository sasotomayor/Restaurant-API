
class BurgersController < ApplicationController
  def index
    burgers = Burger.order('id ASC');
    #render json: {status: 'SUCCESS', message: 'Loaded burgers', data:burgers}, status: :ok
    render json: {status: 'SUCCESS', message: 'Loaded burgers', data:burgers.map{|burger| {id: burger[:id],
      nombre: burger[:name], descripcion: burger[:description], imagen: burger[:image],
      ingredientes: burger.ingredients.map{|ing| {path: "https://hamburgueseria.com/ingrediente/#{ing[:id]}"}}}}}, status: :ok
  end

  def show
    burger = Burger.find(params[:id])
    render json: {status: 'SUCCESS', message: 'Loaded burger', data: {id: burger[:id],
      nombre: burger[:name], descripcion: burger[:description], imagen: burger[:image],
      ingredientes: burger.ingredients.map{|ing| {path: "https://hamburgueseria.com/ingrediente/#{ing[:id]}"}}}}, status: :ok
  end

  def create
    burger = Burger.new(burger_params)
    if burger.save
      render json: {status: 'SUCCESS', message: 'Saved burger', data:burger}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Burger not saved', data:burger.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    burger = Burger.find(params[:id])
    burger.destroy
    render json: {status: 'SUCCESS', message: 'Deleted burger', data:burger}, status: :ok
  end

  def update
    burger = Burger.find(params[:id])
    if burger_params[:id]
      render json: {status: 'ERROR', message: 'Burger not updated', data:burger}, status: :ok
    else
      if burger.update_attributes(burger_params)
        render json: {status: 'SUCCESS', message: 'Updated burger', data:burger}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Burger not updated', data:burger}, status: :ok
      end
    end
  end

  private
  def burger_params
    params.permit(:name, :price, :description, :image)
  end
end
