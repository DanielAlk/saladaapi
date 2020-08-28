class UserPhoneNumber < ActiveRecord::Base
  include Filterable
  belongs_to :user

  validates :user, :phone_number, presence: true
  validate :user_phone_number_limit

  filterable search: [ :phone_number ]
  filterable order: [ :user, :phone_number ]

  private
  def user_phone_number_limit
    if self.new_record? && self.user.user_phone_numbers.count + 1 > self.user.phone_numbers_limit
      errors.add(:user_phone_number_limit, "El usuario ha alcanzado su limite de teléfonos")
    end
  end
end
