class UserPhoneNumber < ActiveRecord::Base
  include Filterable
  belongs_to :user

  validates :user, :phone_number, presence: true
  validate :user_phone_number_limit, unless: :force_user_limit

  filterable search: [ :phone_number ]
  filterable order: [ :user, :phone_number ]

  attr_accessor :force_user_limit

  before_save :update_limit, if: :force_user_limit

  def to_hash(flag = nil)
    user_phone_number = JSON.parse(self.to_json).deep_symbolize_keys
    if flag == :complete
      user_phone_number[:user] = self.user.to_hash
    end
    user_phone_number
  end

  private
    def update_limit
      unless self.user.user_phone_numbers.count < self.user.phone_numbers_limit
        self.user.increment!(:phone_numbers_limit)
      end
    end

    def user_phone_number_limit
      if self.new_record? && self.user.user_phone_numbers.count + 1 > self.user.phone_numbers_limit
        errors.add(:user_phone_numbers_limit, "El usuario ha alcanzado su limite de teléfonos")
      end
    end
end
