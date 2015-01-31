$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require "misc"
require "iv"


#require "watir"
require "misc"
require 'DBI'
require "osc"
require "iv"
require "cmm"
require "cmm2"
require "bitme"

frompage=ARGV[0].to_i
topage=ARGV[1].to_i




for page in  (frompage..topage)
  puts "===== Processing page: " + page.to_s + " ======="

  dlink= "http://www.bitme.org/browse.php?page="+page.to_s
  
    btfilename="/cygdrive/c/tmp/bitmepage.htm"
    btfileverify="c:/tmp/bitmepage.htm"
    bitmecookie="/cygdrive/c/cygwin/script/Cookie/bitmeCookie.txt"
    File.delete(btfileverify) if File.exist?(btfileverify)
      puts  "wget will downloading "+dlink[0..40]+"..."
    wgetcmd="c:\\cygwin\\bin\\wget.exe -q  --tries=60 --continue --timeout=2   -U \"Mozilla/5.0 anything else...\" "
    wgetcmd += "--output-document  #{btfilename} "
    wgetcmd += " --load-cookies  #{bitmecookie} "
    wgetcmd += dlink
    system(wgetcmd) 
    
  
  
  
  
  
ie = Watir::Browser.new

ie.goto btfileverify


idarr=[]

for i in 2..ie.table(:index,22).row_count
link= ie.table(:index,22).row(:index,i)[2].link(:index,1).href
link= link.split("=")[1]
link= link.split("&")[0]
link= link.strip
puts link 
idarr << link
end #for i in 2..filetable.row_count
ie.close

idarr.each { |i| 
#if !i.src.to_s.include?("bitme")
#puts i.src.to_s 
Misc.close_all_windows
puts "---- Process sid "+i.to_s+" ----"

Dir.mkdir("c:/wamp/www/torrents/") if !(File.directory?("c:/wamp/www/torrents"))
Dir.mkdir("c:/wamp/www/torrents/bitme") if !(File.directory?("c:/wamp/www/torrents/bitme"))

if (Misc.dbshow("SELECT count(*) FROM `main` WHERE `site`=\"bitme\" and `softuid`="+i.to_s)=="0")
  puts "this id not existed in unidb, download id and torrent"
  
Bitme.saveSID(i)
puts "end of Bitme.SaveSID"
Bitme.saveTorrentWget(i)

elsif !Bitme.isBitmeTorrentSaved(i)
  puts "id existed, but torrent not exist, download torrent only"
  Bitme.saveTorrentWget(i)
else
  puts "id "+i.to_s+"  and torrents have existed for bitme in unidb"
end
File.delete(btfileverify) if File.exist?(btfileverify)

#end
}

File.delete(btfileverify) if File.exist?(btfileverify)

end #for page in  (frompage..topage-1)  
