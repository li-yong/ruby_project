# -*- coding: utf-8 -*-

def usage()
  p "usage: "
    p "example: c:\ruby\bin\ruby.exe #{__FILE__} "
    p "   uploadfolder  server,port,username,password,lPath,rPath"
    p "   getfolder     server,port,username,password,lPath,rPath"
    p "   deletefolder  server,port,username,password,rPath"

  
  
  
  p "example:" 
  p " c:\ruby\bin\ruby.exe #{__FILE__} uploadfolder localhost 21 ryan 1 \ruby_projece\lib  /home/hi"
  exit
end
#

usage if (ARGV.length < 6 and ARGV[0] == "delfolder") 
usage if ARGV.length < 7
  

  
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"
require "cmm"


#lPath="\\ruby_project\\lib"  
#rPath="/home/hi"
#username="ryan"
#password="1"
#server="localhost"
#port="21"




flag = ARGV[0].to_s
server=ARGV[1]
port=ARGV[2]
username=ARGV[3]
password=ARGV[4]
lPath=ARGV[5].to_s
rPath=ARGV[6]

ARGV.each do|a|
   puts "Argument: #{a}"
 end
 

if flag == "uploadfolder"
  Cmm.ftpUploadFolder(server,port,username,password,lPath,rPath)
elsif flag == "getfolder"  
  Cmm.ftpGetFolder(server,port,username,password,lPath,rPath)
elsif flag == "delfolder"  
  Cmm.ftpDeleteFolder(server,port,username,password,rPath)
else
   puts "unknow flag #{flag}"
end