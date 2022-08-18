class Api::V1::CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: %i[show destroy update]

  def index
    collections = current_user.collections
    render json: { collections: }, status: :ok
  end

  def show
    render json: { collection: @collection }, status: :ok
  end

  def create
    collection = current_user.collections.build(collection_params)

    if collection.save
      render json: { collection: }, status: :created
    else
      render json: { errors: collection.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy
    head :no_content
  end

  def update
    if @collection.update(collection_params)
      render json: { collection: @collection }, status: :ok
    else
      render json: { errors: @collection.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_collection
    @collection = current_user.collections.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name)
  end

end
