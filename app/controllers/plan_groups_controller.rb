class PlanGroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_plan_group, only: [:show, :update, :destroy]

  # GET /plan_groups
  # GET /plan_groups.json
  def index
    @plan_groups = PlanGroup.available_for_user(current_user)

    render json: @plan_groups
  end

  # GET /plan_groups/1
  # GET /plan_groups/1.json
  def show
    render json: @plan_group
  end

  # POST /plan_groups
  # POST /plan_groups.json
  def create
    @plan_group = PlanGroup.new(plan_group_params)

    if @plan_group.save
      render json: @plan_group, status: :created, location: @plan_group
    else
      render json: @plan_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plan_groups/1
  # PATCH/PUT /plan_groups/1.json
  def update
    @plan_group = PlanGroup.find(params[:id])

    if @plan_group.update(plan_group_params)
      head :no_content
    else
      render json: @plan_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /plan_groups/1
  # DELETE /plan_groups/1.json
  def destroy
    @plan_group.destroy

    head :no_content
  end

  private

    def set_plan_group
      @plan_group = PlanGroup.find(params[:id])
    end

    def plan_group_params
      params.permit(:name, :title, :description, :kind, :subscriptable_role, :starting_price)
    end
end
