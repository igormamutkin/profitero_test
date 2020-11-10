require_relative 'parser'
require_relative 'file'
require_relative 'downloader'
require 'cmdline'

cmdline = CommandLine.new [
  ['-u', '--url', :url, 'url', true, nil, ''],
  ['-f', '--file', :file, 'file', true, nil, '']
]
cmdline.parse ARGV
url = cmdline.url
file = cmdline.file

parser = Parser.new
links = parser.get_all_links(url.to_s)
file = FileCSV.new(file.to_s)

links.each { |link| parser.add_product(link) }
file.write_to_csv(parser.parsed_products)
