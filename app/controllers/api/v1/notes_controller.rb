class Api::V1::NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[show destroy update]

  def index
    notes = current_user.notes
    render json: { notes: notes }, status: :ok
  end

  def show
    render json: { note: @note }, status: :ok
  end

  def create
    note = current_user.notes.build(note_params)

    if note.save
      render json: { note: note }, status: :created
    else
      render json: { errors: note.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    head :no_content
  end

  def update
    if @note.update(note_params)
      render json: { note: @note }, status: :ok
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
