class User < ActiveRecord::Base
  # Include default devise modules.
  # devise :database_authenticatable, :registerable,
  #         :recoverable, :rememberable, :trackable, :validatable,
  #         :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include Filterable

  has_attached_file :avatar, styles: { medium: "300x300#", small: "140x140#", thumb: "80x80#" }
  validates_attachment :avatar, content_type: { content_type: /\Aimage\/.*\Z/ }

  has_many :shops, dependent: :destroy
  has_many :shop_claims, -> { order(updated_at: :desc) }, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :incoming_comments, foreign_key: :receiver_id, class_name: :Comment, dependent: :destroy
  has_many :incoming_interactions, foreign_key: :owner_id, class_name: :Interaction, dependent: :destroy
  has_many :outgoing_interactions, class_name: :Interaction, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy
  
  serialize :metadata

  validates :name, :email, :gender, :birthday, :id_type, :id_number, :locality, :address, :phone_number, :role, presence: true

  filterable search: [:name, :email]

  enum role: [ :client, :seller, :admin ]
  enum special: [ :free, :premium ]
  enum gender: [ :male, :female ]

  def metadata=(metadata)
  	if metadata.respond_to?(:each)
  		write_attribute(:metadata, metadata)
  	elsif (parsed = JSON.parse(metadata)).present?
  		write_attribute(:metadata, parsed)
  	end
  end

  def push=(message)
    PushJob.perform_async({
      user_id: self.id,
      title: 'SaladaApp',
      message: message,
      buttons: [ 'Ok' ]
    })
  end

  def first_name
    name.split.first(name.split.size-1)
  end

  def last_name
    name.split.last
  end

  def card=(token)
    $mp.post("/v1/customers/#{customer_id}/cards", { token: token })
  end

  def default_card=(token)
    request = $mp.post("/v1/customers/#{customer_id}/cards", { token: token })
    if request['status'].try(:to_i) == 200 || request['status'].try(:to_i) == 201
      card = request['response'].deep_symbolize_keys
      $mp.put("/v1/customers/#{customer_id}", { default_card: card[:id] })
    end      
  end

  def delete_card(card_id)
    $mp.delete("/v1/customers/#{customer_id}/cards/#{card_id}")
  end

  def cards
    request = $mp.get("/v1/customers/#{customer_id}/cards")
    if request["status"] == "200"
      request["response"]
    end
  end

  def create_mercadopago_user
    unless self.customer_id.present?
      customer = $mp.post("/v1/customers", { email: email })
      self.customer_id = customer['response']['id']
      if self.customer_id.blank?
        customer = $mp.get("/v1/customers/search", { email: email })
        self.customer_id = customer['response']['results'][0]['id']
      end
      self.save
    end
  end

  def handle_payment(payment)
    self.card = payment.token if payment.approved? && payment.save_card && payment.token
  end

  def handle_subscription(subscription)
    self.premium! if subscription.authorized?
    self.free! if subscription.cancelled? || subscription.finished?
  end

  def available_plan_groups
    user_role = self.admin? ? User.roles[:seller] : User.roles[self.role]
    if self.seller?
      if self.shops.present?
        PlanGroup.where(subscriptable_role: user_role)
      else
        PlanGroup.where(subscriptable_role: user_role, kind: PlanGroup.kinds[:automatic_debit])
      end
    else
      PlanGroup.where(subscriptable_role: user_role)
    end
  end

  def has_plan_groups_available?
    user_role = self.admin? ? User.roles[:seller] : User.roles[self.role]
    self.free? && self.subscriptions.cash.paused.count == 0 && PlanGroup.where(subscriptable_role: user_role).count > 0
  end

  def image
    if self.avatar.present?
      ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:medium)
    else
      ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + ActionController::Base.helpers.asset_url("user.png", :digest => false)
    end
  end

  def unanswered_questions_count
    self.incoming_comments.question.unanswered.count
  end

  def unread_answers_count
    self.incoming_comments.answer.where(read: false).count
  end

  def product_limit
    if self.free?
      5
    elsif self.premium?
      :unlimited
    end
  end

  def product_image_limit
    if self.free?
      1
    elsif self.premium?
      5
    end
  end

  def shop_limit
    if self.free?
      1
    elsif self.premium?
      :unlimited
    end
  end

  def permissions
    {
      create_shop: false,
      claim_shop: self.seller?
    }
  end

  def interacted_products_as(interact_as)
    where_clause = 'interactions.user_id' if interact_as == :user
    where_clause = 'interactions.owner_id' if interact_as == :owner
    Product.published.distinct.select('products.*, MAX(interactions.updated_at) as interaction_updated_at').joins(:interactions).where(where_clause => self).group(:product_id).order('interaction_updated_at DESC')
  end
  
  def token_validation_response
    UserSerializer.new( self, root: false )
  end

  def destroy
    if admin?
      errors.add(:can_not_delete, 'No se puede eliminar el usuario admin')
      false
    else
      super
    end
  end

  def to_hash(flag = nil)
    user = JSON.parse(self.to_json).deep_symbolize_keys
    if self.avatar.present?
      user[:avatar] = {
        thumb: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:thumb),
        small: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:small),
        medium: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:medium),
        original: ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + self.avatar.url(:original)
      }
    else
      user[:avatar] = {}
      [:thumb, :small, :medium, :original].each do |key|
        user[:avatar][key] = ENV['webapp_protocol'] + '://' + ENV['webapp_domain'] + ActionController::Base.helpers.asset_url("user.png", :digest => false)
      end
    end
    if flag == :complete
      user[:has_plan_groups_available] = self.has_plan_groups_available?

      user[:shops] = {
        items: self.shops.order(created_at: :desc).page(1).per(4).map{ |shop| shop.to_hash },
        total_count: self.shops.count
      }
      user[:products] = {
        items: self.products.order(special: :desc).page(1).per(4).map{ |product| product.to_hash },
        total_count: self.products.count
      }
      user[:shop_claims] = {
        items: self.shop_claims.order(updated_at: :desc).page(1).per(4).map{ |shop_claim| shop_claim.to_hash },
        total_count: self.shop_claims.count
      }
      user[:questions] = {
        items: self.comments.question.order(created_at: :desc).page(1).per(4).map{ |comment| comment.to_hash(:for_user) },
        total_count: self.comments.question.count
      }
      user[:answers] = {
        items: self.comments.answer.order(created_at: :desc).page(1).per(4).map{ |comment| comment.to_hash(:for_user) },
        total_count: self.comments.answer.count
      }
      user[:subscriptions] = {
        items: self.subscriptions.order(created_at: :desc).page(1).per(4).map{ |subscription| subscription.to_hash },
        total_count: self.subscriptions.count
      }
      user[:payments] = {
        items: self.payments.order(created_at: :desc).page(1).per(4).map{ |payment| payment.to_hash(:complete) },
        total_count: self.payments.count
      }
    end
    user
  end
end
