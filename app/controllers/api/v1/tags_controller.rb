class Api::V1::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[show destroy update]

  def index
    if params[:note_id]
      note = current_user.notes.find(params[:note_id])
      tags = note.tags
    else
      tags = current_user.tags
    end
    render json: { tags: }, status: :ok
  end

  def show
    render json: { tag: @tag }, status: :ok
  end

  def create
    tag = current_user.tags.build(tag_params)

    if tag.save
      render json: { tag: }, status: :created
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  def update
    if @tag.update(tag_params)
      render json: { tag: @tag }, status: :ok
    else
      render json: { errors: @tag.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
