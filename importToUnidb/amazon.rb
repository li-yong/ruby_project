$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
require "watir"
require "misc"
require 'DBI'

loginPage = "http://www.amazon.com/s/ref=lp_465600_nr_n_4?fst=as%3Aoff&rh=n%3A283155%2Cn%3A!2349030011%2Cn%3A465600%2Cn%3A468212&bbn=465600&ie=UTF8&qid=1418633018&rnid=465600"
torrentPage="http://www.amazon.com/s/ref=lp_465600_nr_n_4?fst=as%3Aoff&rh=n%3A283155%2Cn%3A!2349030011%2Cn%3A465600%2Cn%3A468212&bbn=465600&ie=UTF8&qid=1418633018&rnid=465600 "
frompage=ARGV[0].to_i
topage=ARGV[1].to_i
#topage=topage-1


ie = Watir::Browser.new :firefox
=begin
ie.goto loginPage
ie.text_field(:name, "login_username").set "sunraise2005"
ie.text_field(:name, "login_password").set "@Apple!"
ie.button(:name, "login").click 
=end



#处理第一页, 第一页url 和 剩下的页不同
ie.goto torrentPage
#Misc.savehtml2file("c:\\tmp\\torrents\\torrents.htm",ie)
#Misc.putSID(ie)


rst=ie.ul(:id,"s-results-list-atf")
#<Watir::UList:0x15c83e94 located=false selector={:id=>"s-results-list-atf", :tag_name=>"ul"}>
results=rst.lis
#<Watir::LICollection:0x398f280 @parent=#<Watir::UList:0x15c83e94 located=false selector={:id=>"s-results-list-atf", :tag_name=>"ul"}>, @selector={:tag_name=>"li"}>
results.each{|x|
    puts x.text
    imageUrl=x.imgs[0].src
    title=x.h2.text
    date=x.span(:class,"a-size-small a-color-secondary").text
    auth=x.div(:class,"a-row a-spacing-none").span(:class,"a-size-small a-color-secondary").text
    
    prices=x.div(:class,"x.diva-column a-span7")
    i=0
    x.links.each{|s|
        i=i+1
        
        
      if s.text =~ /Hardcover/i
        if x.links[i].text =~/to buy/
            print "HARDCOVER PRICE"
            price=x.links[i].text
            puts price
        end
        
        if x.links[i+1].text =~/to buy/
            print "HARDCOVER PRICE"
            price=x.links[i+1].text
            puts price
        end  
      end        
        
       # puts s.text
        if s.text =~ /Paperback/i
            if x.links[i].text =~/to buy/
                print "PAPER PRICE" 
                price=x.links[i].text
                puts price
            end
            
            if x.links[i+1].text =~/to buy/
                print "PAPER PRICE" 
                price=x.links[i+1].text
                puts price
            end        
            
        end
        
        if s.text =~ /Kindle Edition/i
          if x.links[i].text =~/to buy/
              print "KINDLE PRICE" 
              price=x.links[i].text
              puts price
          end
          
          if x.links[i+1].text =~/to buy/
              print "KINDLE PRICE" 
              price=x.links[i+1].text
              puts price
          end  
        end
        
        }
    
  #  paperback=
  #  hardback=
  #  kindleEdition=
    
    
}


 



ie.close
