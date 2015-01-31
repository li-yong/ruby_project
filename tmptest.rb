$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"



require 'iv'
require 'misc'
require 'DBI'
require "watir"
load "verycd.rb"
load "bitme.rb"

sid="143460"

Bitme.saveTorrentWget(sid)

    bitmecookie="c:/cygwin/script/Cookie/bitmeCookie.txt"

file = File.open(bitmecookie)
contents = ""
file.each {|line|
  contents << line
}



tmpcookie="www.bitme.org\tFALSE\t/\tFALSE\t0\tpass  88e58aae4c3c756c62397587b8047b38"
tmpcookie += "\n"+"www.bitme.org FALSE / FALSE 0 uid 149689"
tmpcookie += "\n"+"www.bitme.org FALSE / FALSE 0 PHPSESSID 2549bb7486db488b3e30bc25732b5454"

ie = Watir::Browser.new
ie.document.cookie = contents

ie.goto "http://www.bitme.org/browse.php?page=100"










exit

ie= Watir::Browser.new
y=2895810
link="http://www.verycd.com/topics/"+y.to_s
 




Verycd.parseItem(ie,y)
