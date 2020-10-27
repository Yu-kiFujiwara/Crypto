class ScrapingDatumController < ApplicationController
  def change
    rename_table :scraping_data, :scraping_datum
  end
  
  def new
  end

  def create
  end
end