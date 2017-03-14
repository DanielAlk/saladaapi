class DataController < ApplicationController
  def shop
  	render json: { locations: Shop.locations, conditions: Shop.conditions, gallery_names: [ 'El Imperio', 'El Indio', 'El Dorado' ] }
  end
end
