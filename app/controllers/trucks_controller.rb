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
    # @tol = TruckOrderList.where(date: Date.today) || TruckOrderList.create(truck: @truck, date: Date.today)
    # @choice = Choice.new(truck: @truck, basket: @basket, user: current_user)
    @basket = Basket.where(user: current_user, truck: @truck, status: "pending").last
    @tables = []
    @truck.meals.each_with_index do |meal, index|
      @tables[index] = {meal: meal,
                        choice: Choice.where(user_id: current_user.id, meal_id: meal.id).last || Choice.new(meal_id: meal.id, user: current_user, quantity: 0)}
    end
  end

  def create
    user = current_user
    @truck = Truck.new(truck_params)
    @truck.user = user
    if @truck.save
      redirect_to owner_truck_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @truck.update(truck_params)
    redirect_to owner_truck_path
  end

  def destroy
    @truck.destroy
    redirect_to trucks_path
  end

  def show_owner
    # to add a new object
    @truck = Truck.find_by(user: current_user)
    @meal = Meal.new
    @address = Address.new
    @calendar = Calendar.new

    # to display all the object already existing
    @meals = Meal.all
    @addresses = Address.all
    @calendars = Calendar.all
  end

  def truck_order
    @truck = Truck.find_by(user: current_user)
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
