require 'open-uri'
require 'nokogiri'
require 'openssl'

class NewsController < ApplicationController
  skip_forgery_protection


  def index
    @history = session[:history]   
  end


  def scrape

    url = params[:url]

    if url.blank?
       redirect_to root_path and return 
    end
    
    begin
      html = URI.open(url)
      doc = Nokogiri::HTML.parse(html)
  
      summary_html = doc.at_css('.content--summary')&.inner_html&.strip
      body_html = doc.css('.body-text p').map(&:inner_html).join
  
      scraped_article = {
        title: doc.at_css('h1')&.text&.strip,
        date: doc.at_css('time')&.text&.strip,
        body: [summary_html, body_html].compact.join('<br><br>')
      }
  
      history = session[:history] || []
      history.unshift(scraped_article)
      session[:history] = history.first(5)
  
    rescue => e
      logger.error 
    end
  
    redirect_to root_path
  end
end