$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require "watir"
require "misc"
ie= Watir::Browser.new


#tid=160145, 27ye
	topicid="133607"
  
	(113..639).each{ |postpages|	
  sleep 2
  puts "processing page "+postpages.to_s
	url="http://bbs.maxthon.cn/viewthread.php?tid="+topicid.to_s+"&page="+postpages.to_s
	ie.goto url
	
	
		(1..18).each{|i| 
    begin
		txt=ie.div(:class => "t_msgfontfix", :index => i).html
		txt="<----><br>"+txt+"<p>&nbsp<br></p>"
		Misc.saveTxt2File(txt,"xiaohua\\id"+topicid.to_s+"_p"+postpages.to_s+"_xiaohua.htm")
    rescue
    puts "error in page id "+postpages.to_s
    end
    
		} #1..18).each  
		
	}#(1..27).each
