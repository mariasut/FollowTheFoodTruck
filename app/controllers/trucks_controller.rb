class TrucksController < ApplicationController
  before_action :set_truck, only: [:show, :edit, :update, :destroy]
  before_action :set_all_trucks, only: [:home, :index]


  def home
  end

  def index
  end

  def new
    @truck = Truck.new
  end

  def show
    # @basket = Basket.new
    # @tol = TruckOrderList.new(truck: @truck)
    # @basket = Basket.new(user: current_user, truck_order_list: @tol)
    @choice = Choice.new(truck: @truck, basket: @basket, user: current_user)
    @table = []
    @truck.meals.each_with_index do |meal, index|
      table[index] = {meal: meal,
                    choice: Choice.where(user_id: current_user.id, meal_id: meal.id).last || Choice.new(meal_id: meal.id)}
    end

  end

  def show_owner
    # to add a new object
    @meal = Meal.new
    @address = Address.new
    @calendar = Calendar.new

    # to display all the object already existing
    @meals = Meal.all
    # idem address
  end

  def create
    user = current_user
    @truck = Truck.new(truck_params)
    @truck.user = user
    if @truck.save
      redirect_to truck_path(@truck)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @truck.update(truck_params)
    redirect_to truck_path(@truck)
  end

  def destroy
    @truck.destroy
    redirect_to trucks_path
  end


  private

  def set_all_trucks
    @trucks = Truck.all
  end

  def set_truck
    @truck = Truck.find(params[:id])
  end

  def truck_params
    params.require(:truck).permit(:name, :type_of_food, :pay_online, :payment_info, photos: [])
  end
end
