require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'ostruct'
class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  def search
    @products = Product.where("name LIKE ?", "%" + params[:q] + "%")
    apiproducts = f21request(params[:q])
    @apiproducts = apiproducts
  end

  def preferences
    pref = amazonrequest()
    @clothing_preference = pref
  end

  def f21request(query)

    # url = URI("https://apidojo-hm-hennes-mauritz-v1.p.rapidapi.com/products/search?color_groups=black&start=0&rows=15&query=#{query}")
    url = URI("https://apidojo-forever21-v1.p.rapidapi.com/products/search?color_groups=black&start=0&rows=15&query=#{query}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    # request["x-rapidapi-host"] = 'apidojo-hm-hennes-mauritz-v1.p.rapidapi.com'
    # request["x-rapidapi-key"] = '8635d8da1emsh82286d53695c15ep1720a0jsn35bdb7e367a2'

    request["x-rapidapi-host"] = 'apidojo-forever21-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '2119b7d06cmsh39ea3dffd6eb2dbp1b1ecdjsn43a7211d2d0c'
    #request["x-rapidapi-key"] = 'fpPGBGyACNmshJMcun5TDd492NwCp1RoE0Ljsn1QAJu4MuB0Lr'

    response = http.request(request)
    data = JSON.parse(response.read_body, object_class:OpenStruct)
    return data
  end

  def amazonrequest()

    #url = URI("https://parazun-amazon-data.p.rapidapi.com/search?keywords=#{current_user.clothing_preference}&region=US")
    url = URI("https://amazon-price1.p.rapidapi.com/search?keywords=#{current_user.clothing_preference}&marketplace=ES")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)

    # request["x-rapidapi-host"] = 'parazun-amazon-data.p.rapidapi.com'
    # request["x-rapidapi-key"] = '8635d8da1emsh82286d53695c15ep1720a0jsn35bdb7e367a2'

    request["x-rapidapi-host"] = 'amazon-price1.p.rapidapi.com'
    request["x-rapidapi-key"] = '2119b7d06cmsh39ea3dffd6eb2dbp1b1ecdjsn43a7211d2d0c'
    # request["x-rapidapi-key"] = 'fpPGBGyACNmshJMcun5TDd492NwCp1RoE0Ljsn1QAJu4MuB0Lr'

    response = http.request(request)
    data = JSON.parse(response.read_body, object_class:OpenStruct)
    return data
  end


  # GET /products/1
  # GET /products/1.json
  def show
  end


  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user = current_user
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description)
    end
end
