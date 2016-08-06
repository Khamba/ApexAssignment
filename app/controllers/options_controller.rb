class OptionsController < ApplicationController
  before_action :set_option, only: [:show, :edit, :update, :destroy]

  # GET /options.html
  def index
    @my_options = Option.where(guest: @guest).order(updated_at: :desc).limit(5)
    @other_options = Option.where.not(guest: @guest).order(updated_at: :desc).limit(5)
    render json: { my_options: @my_options, other_options: @other_options }
  end

  # GET /options/new
  def new
    @option = Option.new
  end

  # GET /options/:id/edit
  def edit
    @option = Option.find(params[:id])

    if @option.range_attribute.blank?
      render 'edit_without_chart'
    else
      @array_for_chart = @option.range_array.each_with_index.map do |value, index|
        [ value, @option.black_scholes_values[index] ]
      end
      render 'edit_with_chart'
    end
  end

  # POST /options
  def create
    @option = @guest.options.build(option_params)
    respond_to do |format|
      if @option.save
        format.js { render js: "window.location.href='" + edit_option_url(@option) + "'" }
      else
        format.js { render 'errors' }
      end
    end
  end

  # PATCH/PUT /options/1
  def update
    # Update only if this this user's option, else create new one
    if @option.guest == @guest
      respond_to do |format|
        if @option.update(option_params)
          format.js { render js: "window.location.href='" + edit_option_url(@option) + "'" }
        else
          format.js { render 'errors' }
        end
      end
    else
      @option = @guest.options.build(option_params)
      respond_to do |format|
        if @option.save
          format.js { render js: "window.location.href='" + edit_option_url(@option) + "'" }
        else
          format.js { render 'errors' }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def option_params
      params.require(:option).permit(:stock_price, :strike_price, :years_to_maturity, :risk_free_interest_rate, :volatality, :call_flag, :name, :range_attribute, :range_to, :interval)
    end
end
