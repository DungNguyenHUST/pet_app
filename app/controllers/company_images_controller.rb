class CompanyImagesController < ApplicationController
  before_action :require_user_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_company_image, only: %i[ show edit update destroy ]

  # GET /company_images or /company_images.json
  def index
    @company = Company.friendly.find(params[:company_id])
    @company_images = @company.company_images
  end

  # GET /company_images/1 or /company_images/1.json
  def show
  end

  # GET /company_images/new
  def new
    @company = Company.friendly.find(params[:company_id])
    @company_image = CompanyImage.new
  end

  # GET /company_images/1/edit
  def edit
  end

  # POST /company_images or /company_images.json
  def create
    @company = Company.friendly.find(params[:company_id])
    @company_image = @company.company_images.build(company_image_params)
    if @company_image.save
      redirect_to company_path(@company, tab_id: 'CompanyImagesID')
    else
      flash[:danger] = "Lỗi, hãy điền đủ nội dung có dấu '*' "
    end
  end

  # PATCH/PUT /company_images/1 or /company_images/1.json
  def update
    respond_to do |format|
      if @company_image.update(company_image_params)
        format.html { redirect_to @company_image, notice: "Company image was successfully updated." }
        format.json { render :show, status: :ok, location: @company_image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_images/1 or /company_images/1.json
  def destroy
    @company_image.destroy
    respond_to do |format|
      format.html { redirect_to company_images_url, notice: "Company image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_image
      @company_image = CompanyImage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_image_params
      params.require(:company_image).permit(:company_id, :image)
    end
end
