class ContactsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_filter :authenticate_admin!, except: :create
  before_action :filterize, only: :index
  before_action :set_contact, only: [:show, :update, :destroy]
  before_action :set_contacts, only: [:update_many, :destroy_many]

  # GET /contacts
  # GET /contacts.json
  def index
    response.headers['X-Total-Count'] = @contacts.count.to_s
    @contacts = @contacts.page(params[:page]) if params[:page].present?
    @contacts = @contacts.per(params[:per]) if params[:per].present?
    
    render json: @contacts
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    render json: @contact
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      Notifier.contact(@contact).deliver_later
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])

    if @contact.update(contact_params)
      head :no_content
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy

    head :no_content
  end
  
  # PATCH/PUT /contacts
  # PATCH/PUT /contacts.json
  def update_many
    if @contacts.update_all(contact_params)
      render json: @contacts, status: :ok, location: contacts_url
    else
      render json: @contacts.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts.json
  def destroy_many
    if (@contacts.destroy_all rescue false)
      head :no_content
    else
      render json: @contacts.errors, status: :unprocessable_entity
    end
  end

  private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def set_contacts
      @contacts = Contact.where(id: params[:ids])
    end

    def contact_params
      params.permit(:name, :email, :tel, :message, :role, :subject, :read)
    end
end
