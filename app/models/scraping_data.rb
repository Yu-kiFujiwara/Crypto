class ScrapingData < ApplicationRecord
  belongs_to :scraping
  self.table_name = "scraping_datum"
end
