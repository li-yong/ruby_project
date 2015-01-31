# -*- coding: utf-8 -*-
#usage: 
#  $0 $site $sid  $saveDrive 
#  $0 bitme 11222  F: (save 11222 of bitme to f:\btdownload)
#  $0 tpb   6169866   C: (save 1333 of tpb to c:\btdownload\ )
#  C:\ruby_project>c:\Ruby\bin\ruby.exe misc\btdownload.rb tpb   6169866   F:


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"

require 'rubygems'
load "bitme.rb"
load "tpb.rb"

#===== Step1 DOWNLOAD TORRENT FILE=====
puts "usage example: c:\\Ruby\\bin\\ruby.exe misc\\btdownload.rb tpb   6169866   F:"

softid=ARGV[1].to_s
torFile=Bitme.saveTorrent(softid) if ARGV[0].upcase=="BITME" 
torFile=Tpb.saveTorrent(softid) if ARGV[0].upcase=="TPB" 

begin puts "torrent file not download, exit"; exit;  end  if torFile == "error"
  
  
#====== Step2: Launch Utorrent, DOWNLOAD AND MONITOR JOB UNTIL SEEDING====

btsavedir=ARGV[2]+"\\btdownload\\"+torFile.split("\\")[-1]   
Bitme.uTorrentDownloadAndMonitorTorrent(torFile,btsavedir)

exit 0