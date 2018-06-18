require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  #attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    @studentInfo = []
    doc = Nokogiri::HTML(open(index_url))
    hash = {}
    doc = doc.css(".roster-cards-container")
    links = doc.css("a")
    
    doc.each do |roster|
     
      students = roster.css(".student-card a")
      count = 0
      students.each do |student|
        #binding.pry
         
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        #profile_url = student.css(".student-card a").value
        profile_url = links[count]["href"]
        
        x = {
        :name => name,
        :location => location,
        :profile_url => profile_url
      }
      #binding.pry
      @studentInfo.push(x)
      #binding.pry
      count += 1
      end 
  
    end 
    
    @studentInfo
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    @profileHash = {}
    #linkedin github twitter blog profile_quote bio 
    
    docHeader = doc.css("vitals-container")
    docBody = doc.css("details container")
    @profile_quote = ""
    linkedin = ""
    twitter = ""    
    github = ""
    blog = ""
    iconCount = 0
    
    docHeader.each do |headContainer|
      quoteContainer = docHeader.css("vitals-text-container")
      iconContainer = docHeader.css("social-icon-container")
      
      quoteContainer.each do |text|
        @profile_quote = quoteContainer.css("profile-quote").text
        @profileHash[:profile_quote] = @profile_quote
      end 
      
      iconContainer.each do |social|
        
      end 
    end 
    
    docBody.each do |bodyContainer|
      @bio = ""
      bioBlock = docBody.css("bio-block details-block")
      bioBlock.each do |block|
        bioContent = bioBlock.css("bio-content content-holder")
        bioContent.each do |content|
          @bio = bioContent.css("description-holder").text
          @profileHash[:bio] = @bio
        end 
      end 
      
    end 
    #binding.pry
    @profileHash
    
  end

end

