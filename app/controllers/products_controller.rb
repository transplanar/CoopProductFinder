require 'rubygems'
require 'roo'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  def index
    @products = Product.all
    @results = Product.search(params[:search])

    # load_from_spreadsheet
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_product
    #   @product = Product.find(params[:id])
    # end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params[:product]
    end

    # def load_from_spreadsheet
    #   data = Roo::Excelx.new("./Bulk_Spreadsheet.xlsx")
    #
    #   data.default_sheet = data.sheets.first
    #
    #   2.upto(data.last_row) do |line|
    #     name = data.cell(line, 'E')
    #     code = data.cell(line, 'B')
    #
    #     puts "#{name} code is #{code}"
    #   end
    # end
end
