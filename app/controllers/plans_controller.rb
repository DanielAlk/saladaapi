class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all

    render json: @plans
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    render json: @plan
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      render json: @plan, status: :created, location: @plan
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    @plan = Plan.find(params[:id])

    if @plan.update(plan_params)
      head :no_content
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy

    head :no_content
  end

  private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.permit(:mercadopago_plan_id, :plan_group, :name, :title, :kind, :price, :frequency, :frequency_type, :application_fee, :status, :description, :auto_recurring, :metadata, :mercadopago_plan)
    end
end
