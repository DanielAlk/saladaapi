class DataController < ApplicationController
  def shop_locations
  	render json: { shop_locations: Shop.locations }
  end
  def shop_statuses
  	render json: { shop_statuses: Shop.statuses }
  end
end
