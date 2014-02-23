class SearchController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  
  before_filter :get_sites, :only => [:result]
  
  def index
    
  end
  
  def result
    get_site_data ensure_site_url(@sites.first)
    
    # parse params to single sites
    
    # give single site to "site to data block" method
    
    # give data block + other sites to result page
    
    # result page loads data into table tool
    
    # ajax call with all sites in paras left is triggerd
    
    # methods starts over again
    
    # when no param is left, ajax dont gets injected for result page
  end
  
  private
  
  def get_sites
    if params[:sites]
      @sites = params[:sites].split(",")
    else
      redirect_to search_path
    end
  end
  
  protected
  
  def get_site_data url
    @site_data = {
      :url         => url,
      :data_blocks => {}
    }
    
    html = Nokogiri::HTML(open(url))
    
    html.css('p').each do |p_tag|
      parent = p_tag.parent
      
      if parent.css('a').present? && parent.css('img').present?
        block_number = @site_data[:data_blocks].count + 1
        
        @site_data[:data_blocks].merge!(create_data_block(parent, block_number, url))
      else
        grand_parent = parent.parent
        
        if grand_parent.css('a').present? && grand_parent.css('img').present?
          block_number = @site_data[:data_blocks].count + 1
          
          @site_data[:data_blocks].merge!(create_data_block(grand_parent, block_number, url))
        end
      end
    end
  end
  
  def create_data_block block, block_number, url
    p_tags   = []
    img_tags = []
    a_tags   = []
    h1_tags  = []
    h2_tags  = []
    h3_tags  = []
    
    block.css('p').each do |p_tag|
      p_tags.push(p_tag.text)
    end
    
    block.css('img').each do |img_tag|
      img_tags.push(img_tag['src'])
    end
    
    block.css('a').each do |a_tag|
      a_tags.push(ensure_href(a_tag['href'], url))
    end
    
    block.css('h1').each do |h1_tag|
      h1_tags.push(h1_tag.text)
    end
    
    block.css('h2').each do |h2_tag|
      h2_tags.push(h2_tag.text)
    end
    
    block.css('h3').each do |h3_tag|
      h3_tags.push(h3_tag.text)
    end
    
    data_block = {
      eval(":block_#{block_number}") => {
        :p_tags    => p_tags,
        :img_tags  => img_tags,
        :a_tags    => a_tags,
        :headlines => {
          :h1_tags => h1_tags,
          :h2_tags => h2_tags,
          :h3_tags => h3_tags
        }
      }
    }
    
    data_block
  end
  
  def ensure_site_url site
    if site.count(".") == 2 && (site.include?("http:\\") || site.include?("http://"))
      site
    else
      if site.count(".") == 1
        "http://www." + site
      elsif site.count(".") == 2
        "http://" + site
      # http://heise.de not coverd
      else
        redirect_to search_path
      end
    end
  end

  def ensure_href href, url
    if href.chars.first.in?("/", "\\")
      url + href
    else
      href
    end
  end
end
