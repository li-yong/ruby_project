module LM   
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"

#require  'Utility'
require  'Misc'

#########################
### make session alive
########################
def LM.makesessionalive(ie)
  (1..100000).each{
  
  ie.goto("http://www.linkmarket.net/link_directory/members_only/my_account.php")
  sleep 5
  ie.goto("http://www.linkmarket.net/link_directory/members_only/edit_your_web_site.php")
  sleep 5
  ie.goto("http://www.linkmarket.net/link_directory/members_only/change_password.php")
  }
end 

#########################
### scan and send request to others 
########################
def LM.scanAndsentrequest(currentcatID,url)

ie= Watir::Browser.new  
ie.goto(url)  #url is first line category, such as Electric
cnt=1
arr=self.getAllpagesAry(ie) #arr hold all pages links under parent, such as Electric/?start=1
arr.each { |link| 
	ie.goto(link)
	puts "====cat:"+currentcatID+", page "+cnt.to_s+" of "+ arr.length.to_s
	puts "==== "+link +" ==="
	self.select(ie)

	cnt=cnt+1
}
  
self.sbmtLQ(ie)
ie.close
end #def LM.scanAndsentrequest(url)


#######
#submit link request
#######

def LM.sbmtLQ(ie)
 ie.goto("http://www.linkmarket.net/link_directory/your_link_cart.php")
 
 if !ie.text.include? "Your Link Cart is Empty"
 ie.button(:value,"Request Link Exchange").click
 sleep 1 until ie.text.include? "Your Link Cart" 
 puts "links in queue submited"
 else
  puts "link cart empty"
 end
 
end





############
#View single one page, click the PR>3 , 'add to cart' to requested task
############
def  LM.select(ie)
  maintableid=ie.tables.length.to_i-1
	entries=ie.table(:index,maintableid).rows.size

	(4..entries).step(4) { |i| 

	rate=ie.table(:index,maintableid)[i][1].text.split
	pr=rate[0].gsub("PR","").to_i; 
	link=(rate[7].to_i+1) ; 
  score=(pr*20)**4/link ;
	
	#if ( score > 1000 ) or (pr > 3) 
	if (pr >= 2) 
		 if ie.table(:index,maintableid)[i][2].html.include?("ac_add.gif")
		   print "PR: "+pr.to_s;
		   print "   links: "+link.to_s
		   puts "   Score: "+score.to_s
		   ie.table(:index,maintableid)[i][2].image(:index,1).click
      else
       puts "no \"add to cart\" button available"
     end  #if ie.table(:index,maintableid)[i][2].html.include?("ac_add.gif")
  else
    puts "pr: "+ pr.to_s + " <2, not send request"
	end #if (pr >= 2) 
	
	} 

end  #def  LM.select(ie)


##############
#retrun max page number of particular category
##############

def LM.getMaxpageid(ie)
 baselink=ie.url.split("/?")[0]
 link=baselink+"/?start=1000000"
 ie.goto(link)
 foottab=ie.tables.length
 rtn=ie.table(:index,foottab).text.split[-1]
 puts "total page of "+baselink+" is "+rtn
 return rtn
end #def LM.getMaxpageid(ie)



#################
#
####################
def LM.getAllpagesAry(ie)
    basepage=ie.url.split("/?")[0]
    total=self.getMaxpageid(ie).to_i
	arr=[]
	
   (1..total).step(1) {|i|
      a=i-1 ; 

	  thispage=a*10+1 
	  thispage=thispage.to_s
	  
	  rtnpage=basepage+"?start="+thispage
	  arr << rtnpage
	    
	  }
return arr
end #def LM.getAllpagesAry(ie)




#################
## ADD LINK, step3of3 and step2of3
####################
def LM.addlink(ie,stage)
  
  if stage.to_s == "1"
   
  htmlcode=ie.text_field(:index,1).text  #"<a href=\"http://www.best-wallpapers.com/\" title=\"Wallpaper\" target
  file="c:/tmp/lm.txt"
  puts "saving exchange link html code to "+file
  Misc.saveTxt2File(htmlcode,file)


 elsif stage.to_s == "3"
  #self.echohtmlhref(htmlcode)  #comment out since netfirms have problem direct ssh (no response when ssh)
  
  ie.text_field(:id,"link_page").set("http://www.taobaoagent.com/info/exchangelinks.php")
  ie.button(:value,"Submit Link's Url").click
end #  if stage.to_s == "1"
  ie.close
end



#################
## Click Trade or Not Trade button a task page.
####################
def LM.tradealink(ie)
     pr=ie.table(:index,13)[10].text.split[0].gsub("PR","").to_i
       if pr <= 1 
          puts "pr "+ pr.to_s+ " < 2, not trade"
          ie.button(:value,"Do Not Trade").click if ie.button(:value,"Do Not Trade").exist?
      else
          puts "pr "+ pr.to_s+ ">= 2,  trade"
          ie.button(:value,"Trade >>").click # if ie.button(:value,"Trade>>").exist?
        end  
     ie.close        
end




#################
## ssh command, upload 
####################
def LM.echohtmlhref(html)
 puts "ssh remote generate html"
 #host="ssh.netfirms.com"
 #user="myvpsoft"
 #pwd="!QAZ2wsx" 
 #remotefile="~/taobaoagent.com/system/application/views/page/exchangelinks.php"




host="64.79.213.172"
user="root"
pwd="fav8ht39" 
remotefile="~/test.php"



html=html.gsub("\"",  "\\\" ")
cmd="echo \"#{html}\" >> #{remotefile}"
#Utility.runsshcmd(host,user,pwd,cmd) 


end #def LM.echohtmlhref(html)


def LM.currentjob(stage)
stage=stage.to_s
ie=Watir::Browser.new 


url="http://www.linkmarket.net/link_directory/members_only/current_jobs.php" #current Jobs
ie.goto(url)

tasknumber=ie.table(:index,13)[1][1].text.split()[-1].gsub(".","").to_i #8 or "Results 1 - 8 of 8."
tasknumber=25 if tasknumber.to_i > 25 #only proecess firstpage currently
taskpages=tasknumber/25.0
#taskpages=taskpages+1
baseurl="http://www.linkmarket.net/link_directory/members_only/current_jobs.php"
(0..taskpages).each{|x| thisurl= baseurl+"?start="+(x*25+1).to_s; 
puts thisurl.to_s;
self.currentjobFirstpage(stage,ie,thisurl); 
}


end #def LM.currentjob(stage)


#########################
########### CURRENT JOBS 
########################
def LM.currentjobFirstpage(stage,ie,thisurl)
stage=stage

#iejoblists=Watir::Browser.new 
iejoblists=ie



#url="http://www.linkmarket.net/link_directory/members_only/current_jobs.php" #current Jobs
iejoblists.goto(thisurl)


tasknumberinthispage=iejoblists.table(:index,13).rows.length - 2 
#tasknumber=25 if tasknumber.to_i > 25 #only proecess firstpage currently



threads=[]


(1..tasknumberinthispage).each{|task|

puts "task "+ task.to_s + " of " + tasknumberinthispage.to_s + "in this page"
row=task+2

threads << Thread.new{
taskOpsite=iejoblists.table(:index,13)[row][2].text                      #"http://www.keeplivinginyourhome.com/"
taskInOut=iejoblists.table(:index,13)[row][3].html.include?("ac_recived.gif")                 #"TRUE"
taskState=iejoblists.table(:index,13)[row][4].html.split("/")[2].split()[0].split("\"")[0]               #"step_1.gif"
taskAction=iejoblists.table(:index,13)[row][7].text                               #=> "Respond"
taskNextpage=iejoblists.table(:index,13)[row][7].link(:index,1).href #"http://www.linkmarket.net/link_directory/members_only/job_type_respond.php?t=4&uid=277676"
 
 
 #puts taskOpsite+taskInOut.to_s+taskState+taskAction+taskNextpage
 


ieonejob=Watir::Browser.new 

 if taskAction == "Respond"
     ieonejob.goto(taskNextpage)
     puts "tradelink..........."
     self.tradealink(ieonejob)
end


 if taskAction == "Add Link"
        ieonejob.goto(taskNextpage)
        puts "addlink..."
        self.addlink(ieonejob, stage)
        
        
  end
      
  
} #threads << Thread.new{



 

}  # (1..tasknumber).each{|task|
threads.each { |aThread|  aThread.join }

#ie.close
#ie2.close

end #def LM.currentjob()




#########################
### retrun arr of all the category url
########################
def LM.getCatLink()
  arr=[]
 arr << "http://www.linkmarket.net/link_directory/Arts/Animation/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Antiques/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Architecture/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Art-History/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Body-art/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Celebrities/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Classical-Studies/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Comics/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Costumes/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Crafts/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Dance/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Design/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Digital/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Entertainment/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Graphic-Design/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Humanities/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Illustration/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Literature/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Movies/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Music/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Myths-and-Folktales/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Native-and-Tribal/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Online-Writing/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Other/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Performing-Arts/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Photography/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Radio/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Television/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Theatre/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Typography/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Video/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Visual-Arts/"
 arr << "http://www.linkmarket.net/link_directory/Arts/Writers-Resources/"
 arr << "http://www.linkmarket.net/link_directory/Business/Aerospace-and-Defense/"
 arr << "http://www.linkmarket.net/link_directory/Business/Agriculture-and-Forestry/"
 arr << "http://www.linkmarket.net/link_directory/Business/Arts-and-Entertainment/"
 arr << "http://www.linkmarket.net/link_directory/Business/Automotive/"
 arr << "http://www.linkmarket.net/link_directory/Business/Biotechnology-and-Pharmaceuticals/"
 arr << "http://www.linkmarket.net/link_directory/Business/Business-Services/"
 arr << "http://www.linkmarket.net/link_directory/Business/Chemicals/"
 arr << "http://www.linkmarket.net/link_directory/Business/Construction-and-Maintenance/"
 arr << "http://www.linkmarket.net/link_directory/Business/Consumer-Goods-and-Services/"
 arr << "http://www.linkmarket.net/link_directory/Business/Electronics-and-Electrical/"
 arr << "http://www.linkmarket.net/link_directory/Business/Employment/"
 arr << "http://www.linkmarket.net/link_directory/Business/Energy-and-Environment/"
 arr << "http://www.linkmarket.net/link_directory/Business/Financial-Services/"
 arr << "http://www.linkmarket.net/link_directory/Business/Food-and-Related-Products/"
 arr << "http://www.linkmarket.net/link_directory/Business/Healthcare/"
 arr << "http://www.linkmarket.net/link_directory/Business/Hospitality/"
 arr << "http://www.linkmarket.net/link_directory/Business/Industrial-Goods-and-Services/"
 arr << "http://www.linkmarket.net/link_directory/Business/Information-Technology/"
 arr << "http://www.linkmarket.net/link_directory/Business/Insurance/"
 arr << "http://www.linkmarket.net/link_directory/Business/Mining-and-Drilling/"
 arr << "http://www.linkmarket.net/link_directory/Business/Other/"
 arr << "http://www.linkmarket.net/link_directory/Business/Publishing-and-Printing/"
 arr << "http://www.linkmarket.net/link_directory/Business/Real-Estate/"
 arr << "http://www.linkmarket.net/link_directory/Business/Retail-Trade/"
 arr << "http://www.linkmarket.net/link_directory/Business/Telecommunications/"
 arr << "http://www.linkmarket.net/link_directory/Business/Textiles-and-Nonwovens/"
 arr << "http://www.linkmarket.net/link_directory/Business/Transportation-and-Logistics/"
 arr << "http://www.linkmarket.net/link_directory/Business/Wholesale-Trade/"
 arr << "http://www.linkmarket.net/link_directory/Business/Work-at-Home/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Advertising-and-Marketing/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Algorithms/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Artificial-Intelligence/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Artificial-Life/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Bulletin-Board-Systems/"
 arr << "http://www.linkmarket.net/link_directory/Computers/CAD-and-CAM/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Companies/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Computer-Science/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Consultants/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Data-Communications/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Data-Formats/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Desktop-Publishing/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Domain-Registration/"
 arr << "http://www.linkmarket.net/link_directory/Computers/E-Books/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Education/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Employment/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Emulators/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Fonts/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Games/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Graphics/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Hacking/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Hardware/"
 arr << "http://www.linkmarket.net/link_directory/Computers/History/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Home-Automation/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Human-Computer-Interaction/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Internet/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Intranet/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Mailing-Lists/"
 arr << "http://www.linkmarket.net/link_directory/Computers/MIS/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Mobile-Computing/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Multimedia/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Newsgroups/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Open-Source/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Operating-Systems/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Organizations/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Other/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Parallel-Computing/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Performance-and-Capacity/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Product-Support/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Programming/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Publications/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Robotics/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Security/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Shopping/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Software/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Speech-Technology/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Supercomputing/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Systems/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Usenet/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Virtual-Reality/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Web-Design/"
 arr << "http://www.linkmarket.net/link_directory/Computers/Web-Hosting/"
 arr << "http://www.linkmarket.net/link_directory/Games/Board-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Card-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Coin-Op/"
 arr << "http://www.linkmarket.net/link_directory/Games/Computer-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Console-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Dice/"
 arr << "http://www.linkmarket.net/link_directory/Games/Fantasy-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Games/Fortune-Telling/"
 arr << "http://www.linkmarket.net/link_directory/Games/Gambling/"
 arr << "http://www.linkmarket.net/link_directory/Games/Hand-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Internet/"
 arr << "http://www.linkmarket.net/link_directory/Games/Miniatures/"
 arr << "http://www.linkmarket.net/link_directory/Games/MUDs/"
 arr << "http://www.linkmarket.net/link_directory/Games/News-and-Reviews/"
 arr << "http://www.linkmarket.net/link_directory/Games/Other/"
 arr << "http://www.linkmarket.net/link_directory/Games/Paper-and-Pencil/"
 arr << "http://www.linkmarket.net/link_directory/Games/Party-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Play-By-Mail/"
 arr << "http://www.linkmarket.net/link_directory/Games/Puzzles/"
 arr << "http://www.linkmarket.net/link_directory/Games/Role-Playing/"
 arr << "http://www.linkmarket.net/link_directory/Games/Table-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Tile-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Trading-Cards/"
 arr << "http://www.linkmarket.net/link_directory/Games/Video-Games/"
 arr << "http://www.linkmarket.net/link_directory/Games/Wordplay/"
 arr << "http://www.linkmarket.net/link_directory/Health/Addictions/"
 arr << "http://www.linkmarket.net/link_directory/Health/Aging/"
 arr << "http://www.linkmarket.net/link_directory/Health/Animal/"
 arr << "http://www.linkmarket.net/link_directory/Health/Beauty/"
 arr << "http://www.linkmarket.net/link_directory/Health/Child-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Dentistry/"
 arr << "http://www.linkmarket.net/link_directory/Health/Disabilities/"
 arr << "http://www.linkmarket.net/link_directory/Health/Education/"
 arr << "http://www.linkmarket.net/link_directory/Health/Employment/"
 arr << "http://www.linkmarket.net/link_directory/Health/Environmental-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Fitness/"
 arr << "http://www.linkmarket.net/link_directory/Health/Health-Insurance/"
 arr << "http://www.linkmarket.net/link_directory/Health/History/"
 arr << "http://www.linkmarket.net/link_directory/Health/Home-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Mens-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Nursing/"
 arr << "http://www.linkmarket.net/link_directory/Health/Nutrition/"
 arr << "http://www.linkmarket.net/link_directory/Health/Occupational-Health-and-Safety/"
 arr << "http://www.linkmarket.net/link_directory/Health/Organizations/"
 arr << "http://www.linkmarket.net/link_directory/Health/Other/"
 arr << "http://www.linkmarket.net/link_directory/Health/Pharmacy/"
 arr << "http://www.linkmarket.net/link_directory/Health/Products-and-Shopping/"
 arr << "http://www.linkmarket.net/link_directory/Health/Professions/"
 arr << "http://www.linkmarket.net/link_directory/Health/Public-Health-and-Safety/"
 arr << "http://www.linkmarket.net/link_directory/Health/Publications/"
 arr << "http://www.linkmarket.net/link_directory/Health/Reproductive-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Resources/"
 arr << "http://www.linkmarket.net/link_directory/Health/Senior-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Senses/"
 arr << "http://www.linkmarket.net/link_directory/Health/Services/"
 arr << "http://www.linkmarket.net/link_directory/Health/Support-Groups/"
 arr << "http://www.linkmarket.net/link_directory/Health/Teen-Health/"
 arr << "http://www.linkmarket.net/link_directory/Health/Weight-Loss/"
 arr << "http://www.linkmarket.net/link_directory/Health/Womens-Health/"
 arr << "http://www.linkmarket.net/link_directory/Home/Apartment-Living/"
 arr << "http://www.linkmarket.net/link_directory/Home/Consumer-Information/"
 arr << "http://www.linkmarket.net/link_directory/Home/Cooking/"
 arr << "http://www.linkmarket.net/link_directory/Home/Do-It-Yourself/"
 arr << "http://www.linkmarket.net/link_directory/Home/Domestic-Services/"
 arr << "http://www.linkmarket.net/link_directory/Home/Emergency-Preparation/"
 arr << "http://www.linkmarket.net/link_directory/Home/Entertaining/"
 arr << "http://www.linkmarket.net/link_directory/Home/Family/"
 arr << "http://www.linkmarket.net/link_directory/Home/Gardens/"
 arr << "http://www.linkmarket.net/link_directory/Home/Home-Automation/"
 arr << "http://www.linkmarket.net/link_directory/Home/Home-Business/"
 arr << "http://www.linkmarket.net/link_directory/Home/Home-Improvement/"
 arr << "http://www.linkmarket.net/link_directory/Home/Homemaking/"
 arr << "http://www.linkmarket.net/link_directory/Home/Homeowners/"
 arr << "http://www.linkmarket.net/link_directory/Home/Moving-and-Relocating/"
 arr << "http://www.linkmarket.net/link_directory/Home/Other/"
 arr << "http://www.linkmarket.net/link_directory/Home/Personal-Finance/"
 arr << "http://www.linkmarket.net/link_directory/Home/Personal-Organization/"
 arr << "http://www.linkmarket.net/link_directory/Home/Pets/"
 arr << "http://www.linkmarket.net/link_directory/Home/Rural-Living/"
 arr << "http://www.linkmarket.net/link_directory/Home/Seniors/"
 arr << "http://www.linkmarket.net/link_directory/Home/Shopping/"
 arr << "http://www.linkmarket.net/link_directory/Home/Urban-Living/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Arts/ctory/Kids-and-Teen"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Computers/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Entertainment/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Games/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Health/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/News/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Other/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/People-and-Society/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Pre-School/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/School-Time/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Sports-and-Hobbies/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Teen-Life/"
 arr << "http://www.linkmarket.net/link_directory/Kids-and-Teens/Your-Family/"
 arr << "http://www.linkmarket.net/link_directory/News/Alternative/"
 arr << "http://www.linkmarket.net/link_directory/News/Analysis-and-Opinion/"
 arr << "http://www.linkmarket.net/link_directory/News/Breaking-News/"
 arr << "http://www.linkmarket.net/link_directory/News/Chats-and-Forums/"
 arr << "http://www.linkmarket.net/link_directory/News/Colleges-and-Universities/"
 arr << "http://www.linkmarket.net/link_directory/News/Current-Events/"
 arr << "http://www.linkmarket.net/link_directory/News/Directories/"
 arr << "http://www.linkmarket.net/link_directory/News/Extended-Coverage/"
 arr << "http://www.linkmarket.net/link_directory/News/Internet-Broadcasts/"
 arr << "http://www.linkmarket.net/link_directory/News/Journals/"
 arr << "http://www.linkmarket.net/link_directory/News/Magazines-and-E-zines/"
 arr << "http://www.linkmarket.net/link_directory/News/Media/"
 arr << "http://www.linkmarket.net/link_directory/News/Newspapers/"
 arr << "http://www.linkmarket.net/link_directory/News/Online-Archives/"
 arr << "http://www.linkmarket.net/link_directory/News/Other/"
 arr << "http://www.linkmarket.net/link_directory/News/Personalized-News/"
 arr << "http://www.linkmarket.net/link_directory/News/Politics/"
 arr << "http://www.linkmarket.net/link_directory/News/Radio/"
 arr << "http://www.linkmarket.net/link_directory/News/Satire/"
 arr << "http://www.linkmarket.net/link_directory/News/Services/"
 arr << "http://www.linkmarket.net/link_directory/News/Television/"
 arr << "http://www.linkmarket.net/link_directory/News/Weather/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Antiques/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Audio/irectory/Recreation/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Autos/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Aviation/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Birding/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Boating/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Bowling/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Camps/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Climbing/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Collecting/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Crafts/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Drugs/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Fireworks/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Food/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Games/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Gardens/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Genealogy/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Guns/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Horoscopes/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Humor/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Kites/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Knives/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Living-History/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Martial-Arts/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Models/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Motorcycles/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Outdoors/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Parties/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Pets/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Picture-Ratings/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Radio/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Roads-and-Highways/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Scouting/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Sports/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Theme-Parks/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Tobacco/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Trains-and-Railroads/"
 arr << "http://www.linkmarket.net/link_directory/Recreation/Travel/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Almanacs/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Archives/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Ask-an-Expert/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Bibliography/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Biography/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Blogs/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Books/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Dictionaries/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Education/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Encyclopedias/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Flags/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Geography/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Journals/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Knots/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Knowledge-Management/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Libraries/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Maps/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Museums/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Open-Access-Resources/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Other/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Questions-and-Answers/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Quotations/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Scientific-Reference/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Style-Guides/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Thesauri/"
 arr << "http://www.linkmarket.net/link_directory/Reference/Time/"
 arr << "http://www.linkmarket.net/link_directory/Reference/World-Records/"
 arr << "http://www.linkmarket.net/link_directory/Science/Agriculture/"
 arr << "http://www.linkmarket.net/link_directory/Science/Anomalies-and-Alternative-Science/"
 arr << "http://www.linkmarket.net/link_directory/Science/Astronomy/"
 arr << "http://www.linkmarket.net/link_directory/Science/Biology/"
 arr << "http://www.linkmarket.net/link_directory/Science/Chemistry/"
 arr << "http://www.linkmarket.net/link_directory/Science/Conferences/"
 arr << "http://www.linkmarket.net/link_directory/Science/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Science/Earth-Sciences/"
 arr << "http://www.linkmarket.net/link_directory/Science/Educational-Resources/"
 arr << "http://www.linkmarket.net/link_directory/Science/Employment/"
 arr << "http://www.linkmarket.net/link_directory/Science/Environment/"
 arr << "http://www.linkmarket.net/link_directory/Science/History-of-Science/"
 arr << "http://www.linkmarket.net/link_directory/Science/Institutions/"
 arr << "http://www.linkmarket.net/link_directory/Science/Instruments-and-Supplies/"
 arr << "http://www.linkmarket.net/link_directory/Science/Math/"
 arr << "http://www.linkmarket.net/link_directory/Science/Methods-and-Techniques/"
 arr << "http://www.linkmarket.net/link_directory/Science/News/"
 arr << "http://www.linkmarket.net/link_directory/Science/Other/"
 arr << "http://www.linkmarket.net/link_directory/Science/Philosophy-of-Science/"
 arr << "http://www.linkmarket.net/link_directory/Science/Physics/"
 arr << "http://www.linkmarket.net/link_directory/Science/Publications/"
 arr << "http://www.linkmarket.net/link_directory/Science/Reference/"
 arr << "http://www.linkmarket.net/link_directory/Science/Science-in-Society/"
 arr << "http://www.linkmarket.net/link_directory/Science/Search-Engines/"
 arr << "http://www.linkmarket.net/link_directory/Science/Social-Sciences/"
 arr << "http://www.linkmarket.net/link_directory/Science/Software/"
 arr << "http://www.linkmarket.net/link_directory/Science/Technology/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Antiques-and-Collectibles/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Auctions/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Autos/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Beauty-Products/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Books/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Children/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Classifieds/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Clothing/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Computers/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Consumer-Electronics/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Crafts/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Death-Care/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Directories/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Education/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Entertainment/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Ethnic-and-Regional/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Flowers/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Food-and-Related-Products/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Furniture/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/General-Merchandise/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Gifts/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Health/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Holidays/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Home-and-Garden/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Jewelry/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Music/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Niche/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Office-Products/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Other/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Pets/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Photography/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Publications/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Recreation/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Religious/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Sports/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Tobacco/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Tools/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Toys-and-Games/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Travel/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Vehicles/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Visual-Arts/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Weddings/"
 arr << "http://www.linkmarket.net/link_directory/Shopping/Wholesale/"
 arr << "http://www.linkmarket.net/link_directory/Society/Activism/"
 arr << "http://www.linkmarket.net/link_directory/Society/Advice/"
 arr << "http://www.linkmarket.net/link_directory/Society/Crime/"
 arr << "http://www.linkmarket.net/link_directory/Society/Death/"
 arr << "http://www.linkmarket.net/link_directory/Society/Disabled/"
 arr << "http://www.linkmarket.net/link_directory/Society/Economics/"
 arr << "http://www.linkmarket.net/link_directory/Society/Education/"
 arr << "http://www.linkmarket.net/link_directory/Society/Ethnicity/"
 arr << "http://www.linkmarket.net/link_directory/Society/Folklore/"
 arr << "http://www.linkmarket.net/link_directory/Society/Future/"
 arr << "http://www.linkmarket.net/link_directory/Society/Gay,-Lesbian-and-Bisexual/"
 arr << "http://www.linkmarket.net/link_directory/Society/Genealogy/"
 arr << "http://www.linkmarket.net/link_directory/Society/Government/"
 arr << "http://www.linkmarket.net/link_directory/Society/History/"
 arr << "http://www.linkmarket.net/link_directory/Society/Holidays/"
 arr << "http://www.linkmarket.net/link_directory/Society/Issues/"
 arr << "http://www.linkmarket.net/link_directory/Society/Language-and-Linguistics/"
 arr << "http://www.linkmarket.net/link_directory/Society/Law/"
 arr << "http://www.linkmarket.net/link_directory/Society/Lifestyle-Choices/"
 arr << "http://www.linkmarket.net/link_directory/Society/Men/"
 arr << "http://www.linkmarket.net/link_directory/Society/Military/"
 arr << "http://www.linkmarket.net/link_directory/Society/Organizations/"
 arr << "http://www.linkmarket.net/link_directory/Society/Other/"
 arr << "http://www.linkmarket.net/link_directory/Society/Paranormal/"
 arr << "http://www.linkmarket.net/link_directory/Society/People/"
 arr << "http://www.linkmarket.net/link_directory/Society/Philanthropy/"
 arr << "http://www.linkmarket.net/link_directory/Society/Philosophy/"
 arr << "http://www.linkmarket.net/link_directory/Society/Politics/"
 arr << "http://www.linkmarket.net/link_directory/Society/Relationships/"
 arr << "http://www.linkmarket.net/link_directory/Society/Religion-and-Spirituality/"
 arr << "http://www.linkmarket.net/link_directory/Society/Sexuality/"
 arr << "http://www.linkmarket.net/link_directory/Society/Social-Sciences/"
 arr << "http://www.linkmarket.net/link_directory/Society/Sociology/"
 arr << "http://www.linkmarket.net/link_directory/Society/Subcultures/"
 arr << "http://www.linkmarket.net/link_directory/Society/Support-Groups/"
 arr << "http://www.linkmarket.net/link_directory/Society/Transgender/"
 arr << "http://www.linkmarket.net/link_directory/Society/Urban-Legends/"
 arr << "http://www.linkmarket.net/link_directory/Society/Women/"
 arr << "http://www.linkmarket.net/link_directory/Society/Work/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Adventure-Racing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Air-soft/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Animal-Fighting/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Archery/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Badminton/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Baseball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Basketball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Billiards/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Boomerang/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Bowling/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Boxing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Cheerleading/"
 arr << "http://www.linkmarket.net/link_directory/Sports/College-and-University/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Cricket/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Cycling/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Darts/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Equestrian/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Events/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Extreme-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Fantasy/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Fencing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Fishing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Flying-Discs/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Football/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Goal-ball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Golf/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Greyhound-Racing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Gymnastics/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Handball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Hockey/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Horse-Racing/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Hunting/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Informal-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Kabbadi/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Lacrosse/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Martial-Arts/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Motorsports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Multi-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Officiating/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Other/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Paintball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Rodeo/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Rope-Skipping/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Rounders/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Running/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Sepak-Takraw/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Shooting/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Skateboarding/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Skating/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Skiing-and-Snowboarding/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Soccer/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Softball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Squash/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Strength-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Table-Tennis/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Team-Handball/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Team-Spirit/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Tennis/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Track-and-Field/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Walking/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Water-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Winter-Sports/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Women/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Wrestling/"
 arr << "http://www.linkmarket.net/link_directory/Sports/Youth-and-High-School/"
 arr << "http://www.linkmarket.net/link_directory/World/Afrikaans/"
 arr << "http://www.linkmarket.net/link_directory/World/Arabic/"
 arr << "http://www.linkmarket.net/link_directory/World/Armenian/"
 arr << "http://www.linkmarket.net/link_directory/World/Azerbaijani/"
 arr << "http://www.linkmarket.net/link_directory/World/Bable/"
 arr << "http://www.linkmarket.net/link_directory/World/Bahasa-Melayu/"
 arr << "http://www.linkmarket.net/link_directory/World/Bangla/"
 arr << "http://www.linkmarket.net/link_directory/World/Belarusian/"
 arr << "http://www.linkmarket.net/link_directory/World/Belgium/"
 arr << "http://www.linkmarket.net/link_directory/World/Bosanski/"
 arr << "http://www.linkmarket.net/link_directory/World/Bulgarian/"
 arr << "http://www.linkmarket.net/link_directory/World/Cymraeg/"
 arr << "http://www.linkmarket.net/link_directory/World/Czech/"
 arr << "http://www.linkmarket.net/link_directory/World/Dansk/"
 arr << "http://www.linkmarket.net/link_directory/World/Deutsch/"
 arr << "http://www.linkmarket.net/link_directory/World/Eesti/"
 arr << "http://www.linkmarket.net/link_directory/World/Euskara/"
 arr << "http://www.linkmarket.net/link_directory/World/Farsi/"
 arr << "http://www.linkmarket.net/link_directory/World/Greek/"
 arr << "http://www.linkmarket.net/link_directory/World/Hebrew/"
 arr << "http://www.linkmarket.net/link_directory/World/Hindi/"
 arr << "http://www.linkmarket.net/link_directory/World/Hrvatski/"
 arr << "http://www.linkmarket.net/link_directory/World/Indonesia/"
 arr << "http://www.linkmarket.net/link_directory/World/Interlingua/"
 arr << "http://www.linkmarket.net/link_directory/World/Islenska/"
 arr << "http://www.linkmarket.net/link_directory/World/Italiano/"
 arr << "http://www.linkmarket.net/link_directory/World/Japanese/"
 arr << "http://www.linkmarket.net/link_directory/World/Kannada/"
 arr << "http://www.linkmarket.net/link_directory/World/Kiswahili/"
 arr << "http://www.linkmarket.net/link_directory/World/Korean/"
 arr << "http://www.linkmarket.net/link_directory/World/Latvian/"
 arr << "http://www.linkmarket.net/link_directory/World/Lietuviu/"
 arr << "http://www.linkmarket.net/link_directory/World/Magyar/"
 arr << "http://www.linkmarket.net/link_directory/World/Makedonski/"
 arr << "http://www.linkmarket.net/link_directory/World/Nederlands/"
 arr << "http://www.linkmarket.net/link_directory/World/Norsk/"
 arr << "http://www.linkmarket.net/link_directory/World/Other/"
 arr << "http://www.linkmarket.net/link_directory/World/Polska/"
 arr << "http://www.linkmarket.net/link_directory/World/Russian/"
 arr << "http://www.linkmarket.net/link_directory/World/Shqip/"
 arr << "http://www.linkmarket.net/link_directory/World/Slovensko/"
 arr << "http://www.linkmarket.net/link_directory/World/Slovensky/"
 arr << "http://www.linkmarket.net/link_directory/World/Srpski/"
 arr << "http://www.linkmarket.net/link_directory/World/Suomi/"
 arr << "http://www.linkmarket.net/link_directory/World/Svenska/"
 arr << "http://www.linkmarket.net/link_directory/World/Tagalog/"
 arr << "http://www.linkmarket.net/link_directory/World/Taiwanese/"
 arr << "http://www.linkmarket.net/link_directory/World/Tamil/"
 arr << "http://www.linkmarket.net/link_directory/World/Telugu/"
 arr << "http://www.linkmarket.net/link_directory/World/Thai/"
 arr << "http://www.linkmarket.net/link_directory/World/Ukrainian/"
 arr << "http://www.linkmarket.net/link_directory/World/Vietnamese/"

return arr
  
end  #def LM.getCatLink()



#########################
### for manual use, here only a recording.
########################
def LM.MANUAL


#ie.goto ("http://www.linkmarket.net/link_directory/Arts/")
ie.goto("http://www.linkmarket.net/link_directory/Business/")
ie.goto("http://www.linkmarket.net/link_directory/Computers/")
ie.goto("http://www.linkmarket.net/link_directory/Games/")
ie.goto("http://www.linkmarket.net/link_directory/Health/")
ie.goto("http://www.linkmarket.net/link_directory/Home/")
ie.goto("http://www.linkmarket.net/link_directory/Kids-and-Teens/")
ie.goto("http://www.linkmarket.net/link_directory/News/")
ie.goto("http://www.linkmarket.net/link_directory/Recreation/")
ie.goto("http://www.linkmarket.net/link_directory/Reference/")
ie.goto("http://www.linkmarket.net/link_directory/Science/")
ie.goto("http://www.linkmarket.net/link_directory/Shopping/")
ie.goto("http://www.linkmarket.net/link_directory/Society/")
ie.goto("http://www.linkmarket.net/link_directory/Sports/")
ie.goto("http://www.linkmarket.net/link_directory/World/")

ie.table(:index,17).links.each{|x| puts x.href }
  
end #def LM.MANUAL





end #module LM   