class FoldersController < ApplicationController
  before_action :set_folder, only: %i[ show edit update destroy ]
  before_action :sanitize_params, only: %i[ create update ]

  # GET /folders or /folders.json
  def index
    @root_folder = Folder.first
  end

  # GET /folders/1 or /folders/1.json
  def show
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
  end

  # POST /folders or /folders.json
  def create
    @folder = Folder.new(folder_params)
    @folder.files.attach(@files_params) if @files_params.present?

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: "Folder was successfully created." }
        format.json { render :show, status: :created, location: @folder }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1 or /folders/1.json
  def update
    @folder.files.attach(@files_params) if @files_params.present?
    
    respond_to do |format|
      if @folder.update(folder_params)
        @folder.update_attribute('parent_id', nil) if @folder == Folder.first

        format.html { redirect_to @folder, notice: "Folder was successfully updated." }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1 or /folders/1.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url, notice: "Folder was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # DELETE /folders/file/1 or /folders/file/1.json
  def destroy_file
    file = ActiveStorage::Attachment.find(params[:id])
    file.purge_later
    respond_to do |format|
      format.html { redirect_to folders_url, notice: "Folder was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def folder_params
      params.require(:folder).permit(:name, :parent_id)
    end

    def sanitize_params
      @files_params = params[:folder][:files]
    end
end
