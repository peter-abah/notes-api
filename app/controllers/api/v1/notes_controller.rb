class Api::V1::NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[show destroy update]

  def index
    if params[:collection_id]
      collection = current_user.collections.find(params[:collection_id])
      @notes = collection.notes
    elsif params[:tag_id]
      tag = current_user.tags.find(params[:tag_id])
      @notes = tag.notes
    else
      @notes = current_user.notes
    end
  end

  def show; end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      render 'api/v1/notes/show', status: :created 
    else
      render json: { errors: @note.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    head :no_content
  end

  def update
    if @note.update(note_params)
      render 'api/v1/notes/show', status: :ok
    else
      render json: { errors: @note.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
