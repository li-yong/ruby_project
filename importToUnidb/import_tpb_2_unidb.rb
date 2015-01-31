$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require "misc"
require "iv"
require 'optparse'
require "watir"
require "misc"
require 'DBI'
require "osc"
require "iv"
require "cmm"
require "cmm2"
require "tpb"


##############
##  outputs: c:/tmp/2010-09-15.sql_zencart
##
##############

#--------- Start of parse option
options = {}

optparse = OptionParser.new do|opts|

   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
  
  
   options[:startpage] = nil
   opts.on( '-s', '--startpage ', 'start page of tpb' ) do|startpage|
     options[:startpage] = startpage
   end
   
   options[:offsetpage] = nil
   opts.on( '-o', '--offsetpage ', 'offset to startpage' ) do|offsetpage|
     options[:offsetpage] = offsetpage
   end   
  
   options[:category] = nil
   opts.on( '-c', '--category ', 'cateogry in tpb to parse and import' ) do|category|
     options[:category] = category
   end
  
end

optparse.parse!



if options[:category].nil? 
        puts "missing tpb category (-c) in input command, using -h show help"
        exit
elsif options[:startpage].nil? 
        puts "missing tpb startpage (-s) in input command, using -h show help"
        exit    
elsif options[:offsetpage].nil? 
        puts "missing tpb offsetpage (-o) in input command, using -h show help"
        exit        
else
   category =  options[:category]
   startpage= options[:startpage]
   offsetpage= options[:offsetpage] 
    
    
end
#--------- End of parse option






pagearr=[]
startpage=(startpage.to_i-1).to_s
endpage=(startpage.to_i+offsetpage.to_i).to_s

categoryHash={}
categoryHash["appwin"]="301"
categoryHash["appmac"]="302"
categoryHash["appunix"]="303"
categoryHash["apphandheld"]="304"
categoryHash["appotheros"]="399"
categoryHash["otherebook"]="601"
categoryHash["othercomic"]="602"
categoryHash["otherpicture"]="603"
categoryHash["othercover"]="604"
categoryHash["gamepc"]="401"
categoryHash["gamemac"]="402"
categoryHash["gameps2"]="403"
categoryHash["gamexbox360"]="404"
categoryHash["gamewii"]="405"
categoryHash["gamehandheld"]="406"
categoryHash["gameother"]="499"
categoryHash["audiomusic"]="101"
categoryHash["audiobook"]="102"
categoryHash["audiosoundclip"]="103"
categoryHash["audioflac"]="104"
categoryHash["audioother"]="199"
categoryHash["videomovie"]="201"
categoryHash["videomoviedvdr"]="202"
categoryHash["videomuscivideo"]="203"
categoryHash["videomovieclip"]="204"
categoryHash["videotvshow"]="205"
categoryHash["videohandheld"]="206"
categoryHash["videohighresmovie"]="207"
categoryHash["videohighrestvshow"]="208"
categoryHash["videoother"]="299"

categoryHashTop100={}
categoryHash.each {| key, value |  
   categoryHashTop100[key+"top100"] = value
}


categoryHash.merge!(categoryHashTop100)

if categoryHash[category].nil?
  puts "category in command should in"
  categoryHash.each {| key, value |  
   puts key
}
  exit
end


(startpage..endpage).each{|page|; 
  
  pagearr << "http://thepiratebay.org/browse/"+categoryHash[category]+"/"+page.to_s+"/3"
}




if category.include?("top100")
 	pagearr = []
	pagearr << "http://thepiratebay.org/top/"+categoryHash[category]
end
#p pagearr
#exit

pagearr.each{|thepage|
 ie=Watir::Browser.new
 Misc.cleanIE
  Cmm.launchIEwithTimeout(ie, thepage, 20)
 sidarr=[]
 ie.links.each{|x|;
  if x.href.include?("http://thepiratebay.org/torrent/");
    sidarr << x.href.split("/")[4];
  end
 }
 ie.close
 
# p sidarr
# exit
 
 sidarr.each{|sid| ; 
    putsstring= "\n====page: "+(pagearr.index(thepage)+1).to_s + " of total " + pagearr.length.to_s
    putsstring=putsstring+", item: "+(sidarr.index(sid)+1).to_s+" of total "+ sidarr.length.to_s
    putsstring=putsstring+", sid #{sid}, #{thepage}" 
    puts putsstring
    if Tpb.hasTpbSid(sid).to_s != 0.to_s
      puts "tpbid #{sid} already existed in unidb-main table, skip"
    else
     Tpb.saveSID(sid) 
    end #if Tpb.hasTpbSid(sid).to_s != 0.to_s
    
 } #a.each{|x| ;
 
 ie.close

} #pagearr.each{|thepage|

exit







=begin

frompage=ARGV[0].to_i
topage=ARGV[1].to_i


ie = Watir::Browser.new

for page in  (frompage..topage)  

ie.goto "http://www.bitme.org/browse.php?page="+page.to_s


idarr=[]


for i in 2..ie.table(:index,22).row_count

link= ie.table(:index,22).row(:index,i)[2].link(:index,1).href
link= link.split("=")[1]
link= link.split("&")[0]
link= link.strip
puts link 
idarr << link
end #for i in 2..filetable.row_count


idarr.each { |i| 
#if !i.src.to_s.include?("bitme")
#puts i.src.to_s 
puts "---- Process sid "+i.to_s+" ----"

if (Misc.dbshow("SELECT count(*) FROM `main` WHERE `site`=\"bitme\" and `softuid`="+i.to_s)=="0")
Bitme.saveSID(i) 
else
  puts "id "+i.to_s+" have existed for bitme in unidb"
end


#end
}

ie.close
end #for page in  (frompage..topage-1)  


=end
