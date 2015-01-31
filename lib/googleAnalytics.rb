# -*- coding: utf-8 -*-
module GoogleAnalystics
  require 'misc'
  require "watir"
  
  def GoogleAnalystics.parseCompany(url)
    
    ie=Watir::Browser.new
    ie.goto(url.to_s)
    
    sleep 5
    rowtable=ie.table(:class,"profile_list_table").row(:index,15)
    
    
    siteName = rowtable.div(:index,3).text
    puts "===#{siteName}==="
    
    receivingStatus = rowtable.cells[7].html.include?("profile_status_receiving")
    puts " ReceivingStatus: "+receivingStatus.to_s
    
    
    visitorsAll =  rowtable.cells[8].text
    puts " VisitorsAll: "+ visitorsAll
    
    
    stayTime = rowtable.cells[9].text
    puts " StayTime: "+stayTime
    
    bounceRate =  rowtable.cells[10].text
    puts " BounceRate: "+bounceRate
    
    completedGoads =  rowtable.cells[11].text
    puts " CompletedGoads: "+completedGoads
    
    
    
    change = rowtable.cells[14].text
    puts " change: "+change
    
    ie.close
  end
  
end  #module GoogleAnalystics
