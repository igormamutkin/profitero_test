require 'curb'
require 'nokogiri'
require 'pry'

class Parser
  attr_reader :parsed_products

  def initialize
    @parsed_products = []
  end

  def get_doc(link)
    Nokogiri::HTML(Curl::Easy.perform(link.to_s).body_str)
  end

  def get_all_links(link)
    puts 'parse category page'
    doc = get_doc(link)
    all_links = []
    page = 2
    while doc.xpath("//button[contains(@class, 'next')]").length.positive?
      tags_link = doc.xpath("//link[@itemprop='url']/@href").map(&:text)
      all_links.concat(tags_link)
      doc = Nokogiri::HTML(Curl::Easy.perform("#{link}?p=#{page}").body_str)
      page += 1
    end
    puts "Collected #{all_links.length} links from selected categories"
    all_links
  end

  def add_product(doc)
    puts 'add one product to the array of products'
    img_pr = get_img(doc)
    get_sizes(doc).each.with_index do |size, i|
      name_pr = get_name(doc) + " #{size}"
      price_pr = get_prices(doc)[i]
      @parsed_products << [name_pr, price_pr, img_pr]
      puts "Product: #{@parsed_products.last.join(", ")} was created"
    end
  end

  private

  def get_name(doc)
    puts 'get product name'
    name_pr = doc.xpath("//p[@class='product_main_name']/text()").text.strip
  end

  def get_img(doc)
    puts 'get product image'
    img = doc.xpath("//img[@id='bigpic']/@src").text
  end

  def get_sizes(doc)
    puts 'get product size list'
    array_size = doc.xpath("//span[@class='radio_label']").map(&:text)
  end

  def get_prices(doc)
    puts 'get price list according to the product'
    array_price = doc.xpath("//span[@class='price_comb']").map(&:text)
  end
end
