require "test_helper"

class CanteensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @canteen = canteens(:one)
  end

  test "should get index" do
    get canteens_url, as: :json
    assert_response :success
  end

  test "should create canteen" do
    assert_difference("Canteen.count") do
      post canteens_url, params: { canteen: { name: @canteen.name } }, as: :json
    end

    assert_response :created
  end

  test "should show canteen" do
    get canteen_url(@canteen), as: :json
    assert_response :success
  end

  test "should update canteen" do
    patch canteen_url(@canteen), params: { canteen: { name: @canteen.name } }, as: :json
    assert_response :success
  end

  test "should destroy canteen" do
    assert_difference("Canteen.count", -1) do
      delete canteen_url(@canteen), as: :json
    end

    assert_response :no_content
  end
end
