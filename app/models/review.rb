class Review < ActiveRecord::Base
	include Filterable
  belongs_to :user
  belongs_to :product

  validates :user, :product, presence: true
  
  after_save :update_product_rating
  after_destroy :update_product_rating
  
  filterable search: [:text]

  def to_hash(flag = nil)
    review = JSON.parse(self.to_json).deep_symbolize_keys
    if flag == :complete
      review[:user] = self.user.to_hash
    end
    review
  end

  private
    def update_product_rating
      reviews_stars = product.reviews.map{ |review| review.stars }
      if (reviews_stars.count > 0)
        product.rating = (reviews_stars.inject(0){ |sum,x| sum + x } / reviews_stars.count.to_f)
      else
        product.rating = nil
      end
      product.save
    end
end
