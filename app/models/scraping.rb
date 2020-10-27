class Scraping < ApplicationRecord
  require 'mechanize'
  has_many :scraping_datum

  class << self
    def scrape
      agent = Mechanize.new
      page = agent.get("https://bitflyer.com/ja-jp/ex/buysell/btc")
      elements = page.search('div.ex-header__balance-info') #div.idxcol aは取得したい要素  elementsは任意の変数 div._3Cyx0
      result = []
      elements.each do |element|
        scraping_data = ScrapingData.new
        scraping_data.content = element.inner_text
        scraping_data.save
        result << scraping_data.content
      end
      result
    end
  end
end
