require 'curb'
require 'nokogiri'

class Downloader
  def self.get_doc(link)
    @@doc = Nokogiri::HTML(Curl::Easy.perform(link.to_s).body_str)
  end
end
