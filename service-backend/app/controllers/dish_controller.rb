class DishController < ApplicationController
  # before_action :set_dish, only: %i[ show update destroy ]

  @@id = 50
  # POST /dish#create
  def create
    dish = Dish.new
    dish[:name] = params[:dish_name]
    dish[:price] = params[:dish_price]
    dish[:star] = params[:dish_star]
    dish[:canteen_name] = params[:canteen_name]

    # 检查canteen
    # canteen = Canteen.find_by(name: params[:canteen_name])
    # if canteen
    #   dish.canteen = canteen
    # else
    #   Canteen.create(name: params[:canteen_name])
    #   dish.canteen = Dish.find_by(name: params[:canteen_name])
    # end
    # dish[:canteen_name] = params[:canteen_name]
    #
    # if dish.save
    #   render status: 200, json: response_json(
    #     true,
    #     message: "Create dish success!",
    #   )
    # end

    # 以下为sql语句进行插入操作
    begin
      execute_statement("INSERT INTO dishes(id, name, price, star, created_at, updated_at, canteen_name)
      VALUES(#{@@id}, '#{dish[:name]}', #{dish[:price]} , '#{dish[:star]}','#{DateTime.parse(Time.now.to_s).strftime('%Y-%m-%d %H:%M:%S')}',
       '#{DateTime.parse(Time.now.to_s).strftime('%Y-%m-%d %H:%M:%S')}', '#{dish[:canteen_name]}');")

      render status: 200, json: response_json(
        true,
        message: "Create dish success!",
      )

      @@id += 1
    rescue
      render status: 412, json: response_json(
        false,
        message: "Invalid information!"
      )
    end
  end

  # GET /dish/list
  def list
    # dishes = Dish.all
    # dishes_to_frontend = Array.new
    # dishes.each { |dish| dishes_to_frontend << (dish.to_json_for_frontend) }
    # hash_to_frontend = Hash.new
    # hash_to_frontend.store("list_length", dishes.length)
    # hash_to_frontend.store("list_items", dishes_to_frontend)
    #
    # render status: 200, json: response_json(
    #   true,
    #   message: "List dish success!",
    #   data: hash_to_frontend
    # )

    # 以下为sql语句进行查询操作
    dish_name = params[:dish_name]
    canteen_name = params[:canteen_name]
    sort_by_id = params[:sort_by_id]
    dish_star = params[:dish_star]
    sql = "SELECT * FROM dishes "
    if (dish_name && !dish_name.empty?) || (canteen_name && !canteen_name.empty?) || (dish_star && !dish_star.empty?)
      sql += "WHERE "
      sql += "name = '#{dish_name}' " if dish_name && !dish_name.empty?
      sql += "canteen_name = '#{canteen_name}' " if canteen_name && !canteen_name.empty?
      sql += "star = #{dish_star} " if dish_star && !dish_star.empty?
    end

    sql += "ORDER BY id ASC" if sort_by_id == '+id'
    sql += "ORDER BY id DESC" if sort_by_id == '-id'

    dishes = execute_statement(sql).as_json
    dishes_to_frontend = dishes.map { |dish| %w[dish_id dish_name dish_price dish_star created_at
    updated_at canteen_name].zip(dish).to_h }
    hash_to_frontend = Hash.new
    hash_to_frontend.store("list_length", dishes.length)
    hash_to_frontend.store("list_items", dishes_to_frontend)

    render status: 200, json: response_json(
      true,
      message: "List dish success!",
      data: hash_to_frontend
    )
  end

  # DELETE /dish#delete
  def delete
    # id = params[:dish_id]
    # dish = Dish.find(id)
    # dish.destroy
    #
    # render status: 200, json: response_json(
    #   true,
    #   message: "delete dish success!"
    # )

    begin
      execute_statement("DELETE FROM dishes WHERE id = #{params[:dish_id]};")

      render status: 200, json: response_json(
        true,
        message: "delete dish success!"
      )
    rescue

      render status: 412, json: response_json(
        false,
        message: "Invalid information!"
      )
    end
  end

  # POST /dish#update
  def update
    # old_dish = Dish.find(params[:dish_id])
    # old_dish[:name] = params[:dish_name]
    # old_dish[:price] = params[:dish_price]
    # old_dish[:star] = params[:dish_star]
    # old_dish[:canteen_name] = params[:canteen_name]
    #
    # if old_dish.save
    #   render status: 200, json: response_json(
    #     true,
    #     message: "update dish success!"
    #   )
    # else
    #   render status: 403, json: response_json(
    #     false,
    #     code: -1,
    #     message: "update dish failed!"
    #   )
    # end

    # 以下为sql语句进行修改操作
    begin
      execute_statement("UPDATE dishes SET id=#{params[:dish_id]}, name='#{params[:dish_name]}',
      price='#{params[:dish_price]}', star=#{params[:dish_star]}, canteen_name='#{params[:canteen_name]}' WHERE id=#{params[:dish_id]};")

      render status: 200, json: response_json(
        true,
        message: "update dish success!"
      )
    rescue
      render status: 403, json: response_json(
        false,
        code: -1,
        message: "update dish failed!"
      )
    end
  end

  # DELETE /dishes/1
  # def destroy
  #   @dish.destroy
  # end

  # private

  # Use callbacks to share common setup or constraints between actions.
  # def set_dish
  #   @dish = Dish.find(params[:id])
  # end
  #
  # # Only allow a list of trusted parameters through.
  # def dish_params
  #   params.require(:dish).permit(:name, :price, :star)
  # end
end
