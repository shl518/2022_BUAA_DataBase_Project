class DishesController < ApplicationController
  before_action :set_dish, only: %i[ show update destroy ]

  # POST /dish#create
  def create
    dish = Dish.new
    dish[:name] = params[:dish_name]
    dish[:price] = params[:dish_price]
    dish[:star] = params[:dish_star]

    # 检查canteen
    canteen = Canteen.find_by(name: params[:canteen_name])
    if canteen
      dish.canteen = canteen
    else
      Canteen.create(params[:canteen_name])
      dish.canteen = Dish.find_by(name: params[:canteen_name])
    end

    if dish.save
      render status: 200, json: response_json(
        true,
        message: "Create dish success!",
      )
    end
  end

  # GET /dish/list
  def list
    dishes = Dish.all

    render status: 200, json: response_json(
      true,
      message: "List dish success!",
      data: dishes
    )
  end

  # DELETE /dish#delete
  def delete
    id = params[:dish_id]
    dish = Dish.find(id)
    dish.destroy

    render status: 200, json: response_json(
      true,
      message: "delete dish success!"
    )
  end

  # POST /dish#update
  def update
    old_dish = Dish.find(params[:dish_id])

    if old_dish.update(dish_params)
      render status: 200, json: response_json(
        true,
        message: "update dish success!"
      )
    else
      render status: 403, json: response_json(
        false,
        code: -1,
        message: "update dish failed!"
      )
    end
  end

  # DELETE /dishes/1
  def destroy
    @dish.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dish
    @dish = Dish.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dish_params
    params.require(:dish).permit(:name, :price, :star)
  end
end
