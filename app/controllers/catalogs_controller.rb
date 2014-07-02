class CatalogsController < ApplicationController
  before_action :set_catalog, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /catalogs
  # GET /catalogs.json
  def index
    @catalogs = Catalog.page params[:page]
  end

  # GET /catalogs/1.json
  def show
  end

  # GET /catalogs/new
  def new
    @catalog = Catalog.new
  end

  # GET /catalogs/1/edit
  def edit
  end

  # POST /catalogs.json
  def create
    @catalog = Catalog.new(catalog_params)

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to @catalog, notice: 'Catalog was successfully created.' }
        format.json { render :show, status: :created, location: @catalog }
      else
        format.html { redirect_to @catalog, notice: 'Catalog was successfully created.' }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalogs/1.json
  def update
    respond_to do |format|
      if @catalog.update(catalog_params)
        format.html { redirect_to @catalog, notice: 'Catalog was successfully updated.' }
        format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { redirect_to @catalog, notice: 'Catalog was successfully updated.' }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogs/1.json
  def destroy
    @catalog.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:title, :web_link, :is_locked => [])
    end
end
