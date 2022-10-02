require "test_helper"

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dish = dishes(:one)
  end

  test "should get index" do
    get dishes_url, as: :json
    assert_response :success
  end

  test "should create dish" do
    assert_difference("Dish.count") do
      post dishes_url, params: { dish: { name: @dish.name, price: @dish.price, star: @dish.star } }, as: :json
    end

    assert_response :created
  end

  test "should show dish" do
    get dish_url(@dish), as: :json
    assert_response :success
  end

  test "should update dish" do
    patch dish_url(@dish), params: { dish: { name: @dish.name, price: @dish.price, star: @dish.star } }, as: :json
    assert_response :success
  end

  test "should destroy dish" do
    assert_difference("Dish.count", -1) do
      delete dish_url(@dish), as: :json
    end

    assert_response :no_content
  end
end
