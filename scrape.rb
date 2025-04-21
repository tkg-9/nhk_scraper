require 'open-uri'
require 'nokogiri'
require 'openssl'

url = 'https://www3.nhk.or.jp/news/'
html = URI.open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) # SSLエラー回避用
doc = Nokogiri::HTML.parse(html)

doc.css('a[href*="/news/html/"]').each do |a_tag|
  title = a_tag.text.strip
  href = a_tag['href']
  puts "#{title} -> https://www3.nhk.or.jp#{href}"
end

