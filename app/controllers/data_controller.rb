class DataController < ApplicationController
  def shop_locations
  	render json: { shop_locations: Shop.locations }
  end
  def shop_conditions
  	render json: { shop_conditions: Shop.conditions }
  end
end
