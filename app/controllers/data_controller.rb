class DataController < ApplicationController
  def shop
  	render json: { locations: Shop.locations, conditions: Shop.conditions }
  end
end
