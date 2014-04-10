class SearchController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'fastimage'
  
  before_filter :get_sites, :only => [:result]
  
  def search
  end
  
  def result
    @result_data = get_site_data ensure_site_url(@sites.first)
    
    Search.create(:request_site => ensure_site_url(@sites.first), :created_at => Time.now)
    
    @update_sites = @sites.drop(1)
  end
  
  def update_results
    @update_results_data = get_site_data ensure_site_url(params[:update_site])
    
    Search.create(:request_site => ensure_site_url(params[:update_site]), :created_at => Time.current)

    respond_to do |format|
      format.html { render :nothing => true }
      format.js   { render :layout  => false }
    end
  end
  
  protected
   
  def get_site_data url
    data = {
      :url         => '',
      :data_blocks => {}
    }
    
    # Site structure settings based on p_tag start elment
    min_p_tag_text_size = 60
    max_a_tags          = 5
    max_image_tags      = 5
    spam_filter         = true
    
    html = Nokogiri::HTML(open(url))
    
    html.css('p').select{ |n| n.text.size >= min_p_tag_text_size }.each do |p_tag|
      parent = spam_filter ? spam_filter(p_tag.parent) : p_tag.parent
      
      if parent                              &&
         parent.css('a').present?            && parent.css('img').present? &&
         parent.css('a').count <= max_a_tags && parent.css('img').count <= max_image_tags && 
         parent.css('img').select{ |img| validate_image_size(img['src'], url) }.present?
        
        block_number = data[:data_blocks].count + 1
        
        data[:data_blocks].merge!(create_data_block(parent, block_number, url))
      elsif parent
        grand_parent = spam_filter ? spam_filter(parent.parent) : parent.parent
        
        if grand_parent                              &&
           grand_parent.css('a').present?            && grand_parent.css('img').present? &&
           grand_parent.css('a').count <= max_a_tags && grand_parent.css('img').count <= max_image_tags && 
           grand_parent.css('img').select{ |img| validate_image_size(img['src'], url) }.present?
          
          block_number = data[:data_blocks].count + 1
          
          data[:data_blocks].merge!(create_data_block(grand_parent, block_number, url))
        end
      end
    end
    
    data[:url] = url + " (#{data[:data_blocks].count})"
    
    data
  end
  
  def create_data_block block, block_number, url
    p_tags   = []
    img_tags = []
    a_tags   = []
    h1_tags  = []
    h2_tags  = []
    h3_tags  = []
    
    biggest_p_tag_size = 0
    block.css('p').each do |p_tag|
      if p_tag.text.size > biggest_p_tag_size
        biggest_p_tag_size = p_tag.text.size
        p_tags = [p_tag.text]
      end
    end
    
    block.css('img').each do |img_tag|
      if src = img_tag['src']
        img_tags.push(ensure_link(src, url))
      end
    end
    
    block.css('a').each do |a_tag|
      if href = a_tag['href']
        a_tags.push([:href => ensure_link(href, url), :text => a_tag.text])
      end
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
    
    # FIXME:Uniq not working for a tags
    data_block = {
      eval(":block_#{block_number}") => {
        :p_tags    => p_tags.uniq,
        :img_tags  => img_tags.uniq,
        :a_tags    => a_tags.uniq,
        :headlines => {
          :h1_tags => h1_tags.uniq,
          :h2_tags => h2_tags.uniq,
          :h3_tags => h3_tags.uniq
        }
      }
    }
    
    data_block
  end
  
  # Before Filter
  
  def get_sites
    if params[:sites]
      @sites = params[:sites].split(",")
    else
      redirect_to search_path
    end
  end
  
  # Helper
  
  def spam_filter element
    check_for_whatever(element)
    # add more here
  end
  
  def check_for_whatever element
    element
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
  
  def ensure_link href_or_src, url
    if ["/", "\\"].include?(href_or_src.chars.first)
      url + href_or_src
    else
      href_or_src
    end
  end
  
  def validate_image_size img_link, url
    # FIXME: Nokogiri saves the image width/height already. Should be faster
    if image_size = FastImage.size(ensure_link(img_link, url), :raise_on_failure => false, :timeout => 0.1)
      image_size.first > 64 && image_size.last > 64
    else
      false
    end
  end
end
