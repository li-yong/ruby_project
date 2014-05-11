$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"

require 'fscan'
require 'commondb'
 

=begin
gaven 'pc' as root folder, then 'adobe_cs3_master_collection"
will be 3, 
then call progam as 
$0 path_of_pc  3

warn will be triger if any file found before layer 3, 
  or any folder found after layer 3

pc
  |_ company
      |_adobe
          |_adobe_cs3_master_collection

=end



 
#mydir="c:\\temp\\"
#p "layer"+scanlayer+"==="

mydir=ARGV[0].to_s
scanlayer=ARGV[1].to_s

p "=== SCAN "+mydir+" with layer"+scanlayer+"==="


 
### Update Folder table ####
Fscan.dbsetTabFolderExistto1()

if scanlayer =="1"
  scanlist=Fscan.getlayer1Dir(mydir)
elsif scanlayer =="2"
  scanlist=Fscan.getlayer2Dir(mydir)
elsif scanlayer =="3"
  scanlist=Fscan.getlayer3Dir(mydir)
elsif scanlayer =="4"
  scanlist=Fscan.getlayer4Dir(mydir)
end #if scanlayer==1



scanlist.each{|x| 
 
if Fscan.ifPathExistInTabFolder(x)
  Fscan.dbupdateTabFolderLastSeeTime(x)
else
  puts x+",folder not existed, insert"
  Fscan.dbinsert2TabFolder(x) 
end
}

##### Update File table ####
 Fscan.updateFileExistInFileTab("1","where 1")
 scanlist.each{|x| Fscan.getFileInfoInFolder(x)}



