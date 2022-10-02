class CanteensController < ApplicationController
  before_action :set_canteen, only: %i[ show update destroy ]

  # GET /canteens
  def index
    @canteens = Canteen.all

    render json: @canteens
  end

  # GET /canteens/1
  def show
    render json: @canteen
  end

  # POST /canteens
  def create
    @canteen = Canteen.new(canteen_params)
  end

  # PATCH/PUT /canteens/1
  def update
    if @canteen.update(canteen_params)
      render json: @canteen
    else
      render json: @canteen.errors, status: :unprocessable_entity
    end
  end

  # DELETE /canteens/1
  def destroy
    @canteen.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_canteen
      @canteen = Canteen.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def canteen_params
      params.require(:canteen).permit(:name)
    end
end
