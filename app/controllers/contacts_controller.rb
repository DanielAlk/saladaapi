class ContactsController < ApplicationController
  include Filterize
  filterize order: :created_at_desc, param: :f
  before_action :filterize, only: :index
  before_action :set_contact, only: [:show, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    response.headers['X-Total-Count'] = @contacts.count.to_s
    @contacts = @contacts.page(params[:page]) if params[:page].present?
    if params[:page].present?
      response.headers["X-total"] = @contacts.total_count.to_s
      response.headers["X-offset"] = @contacts.offset_value.to_s
      response.headers["X-limit"] = @contacts.limit_value.to_s
    end
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

  private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.permit(:name, :email, :tel, :message, :role, :subject, :read)
    end
end
