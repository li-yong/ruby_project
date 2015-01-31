$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require "watir"
require "misc"
require 'DBI'

loginPage = "http://forum.gfxnews.ru/login.php?logout=1"
torrentPage="http://forum.gfxnews.ru/tracker.php"
frompage=ARGV[0].to_i
topage=ARGV[1].to_i
#topage=topage-1


ie = Watir::Browser.new
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


#处理剩下的页面
for i in (frompage..topage-1)  
=begin
  #click 'next' button to go to next torrentpage
  ie.table(:index,8).link(:text,"Next").click
  Misc.savehtml2file("c:\\tmp\\torrents\\"+i.to_s+"torrents.htm",ie)
  puts "now is page "+i.to_s
  Misc.putSID(ie)
=end  

s=ie.table(:index,8).link(:text,"Next").href
sindex= s =~/search_id=/
sindex=sindex+1
eindex= s =~/&start/
eindex=eindex-sindex
sessionid=s[sindex,eindex]

number=(i-1)*50

url="http://forum.gfxnews.ru/tracker.php?search_id=" 
url=url+sessionid
url=url+"&start="
url=url+number.to_s
#puts url
puts "===== Page "+i.to_s+" ====="
ie.goto url
Misc.putSID(ie)

end



ie.close
