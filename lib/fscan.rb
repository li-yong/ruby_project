module Fscan
require "commondb"
require "misc"
require 'digest/md5'

def Fscan.winPath2RubyPath(s)
   s=s.gsub(/\//,"//")
  
end # Fscan.winPath2RubyPath(s)





def Fscan.insertOrUpdateTabFile(file) #MAIN FUNCTION
  if self.fileNotExistInDB(file)
    puts file+" ,file not existed, insert"
    self.dbinsert2TabFile(file)
    self.dbupdateStatusofTabFolder("1",file)
  elsif fileMtimeChange(file)
      puts file+" Mtime changed,update"
    self.dbremoveRecordTabFile(file)
    self.dbinsert2TabFile(file)
    self.dbupdateStatusofTabFolder("1",file)
  else
    self.dbupdateNoModifiedTabFile(file)
       
  end #  if filenotexist
 end  #def Fscan.insertOrUpdateTabFile(fileInFullpath)















def Fscan.returnSqlFormatTime(date) 
 year=date.year.to_s
 mon=self.singleTodouble(date.month.to_s)
 day=self.singleTodouble(date.day.to_s)
 hour=self.singleTodouble(date.hour.to_s)
 min=self.singleTodouble(date.min.to_s)
 sec=self.singleTodouble(date.sec.to_s)
 #puts year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
 return year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
end




def Fscan.singleTodouble(i)
  rtn=i.to_s
  if i.to_i < 10
    rtn="0"+i.to_s
  end
  return rtn
end #def Fscan.singleTodouble(i)

  






def Fscan.dbinsert2TabFile(file) #new file first time found and insert
  #puts file
  #puts "----"
  fileID=(self.getMaxFileID().to_i+1).to_s
  filename=file.split("/")[-1]
  modifyTime=self.returnSqlFormatTime(File.new(file).mtime) #modified, edit a txt file eg.
  filesize=File.size(file).to_s
  folderId=self.getFolderID(File.dirname(File.expand_path(file)) ) #先得到全路径，然后dirname
  fmd5 = Digest::MD5.hexdigest(File.read(file))
  lastseetime=Misc.datenow()
  
sql="INSERT INTO `file` ( `fileID` , `folderID` , `fname` ,"
sql=sql+"`fsize` , `mtime` , `modified` , `fmd5`,`exist`,lastseetime ) VALUES ("
sql=sql+ "\'"+fileID
sql=sql+"\', \'"
sql=sql+folderId+"\', \'"
sql=sql+filename+"\', \'"
sql=sql+filesize+"\', \'"
sql=sql+modifyTime+"\', \'"
sql=sql+'1'+"\', \'"
sql=sql+fmd5
sql=sql+"\',\'"
sql=sql+"0"
sql=sql+"\',"
sql=sql+"\'"+lastseetime+"\');"

CommonDB.dbprocess("DBI:ODBC:files",sql)
end #def Fscan.dbinsert2TabFile(f)


def Fscan.getFileInfoInFolder(folder) #folder need in  absolute full path format
  Dir.chdir(folder)
  Dir.foreach(folder) {|x|
  fileInFullpath=x
    fileInFullpath=File.expand_path(x)
    #fileInFullpath=self.winPath2RubyPath(fileInFullpath) #可加可不加， 加上c://temp//f2//f21//2//＃;  不加 c:/temp/f2/f21/2/
    #puts fileInFullpath
    if !File.directory?(fileInFullpath)
      #puts fileInFullpath
      self.insertOrUpdateTabFile(fileInFullpath)
    elsif x=="." or x==".."
      nil
    else
      puts "ERROR: suppose no floder here, "+fileInFullpath
    end # if !File.directory?(x)
  }
  
end #def Fscan.getFileInfoInFolder(folder) #folder need in  absolute full path format

  
  


  
def Fscan.fileMtimeChange(file) #return True if Mtime changed, False is not change.
  dbMtime=self.getDB_Mtime(file).split(".")[0]
  nowMtime=self.getMtime(file)
  
  #puts dbMtime
  #puts nowMtime
  
  return !(dbMtime==nowMtime)
end #def Fscan.fileMtimeChange(file)

def Fscan.dbremoveRecordTabFile(file)
  fileid=self.getFileID(file)
  sql="DELETE FROM `file` where `fileID`=\'"+fileid +"\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql)
end  #def Fscan.dbremoveRecordTabFile(file)


def Fscan.getDB_Mtime(file)
  fileid=self.getFileID(file)  
  sql="SELECT `mtime` FROM `file` WHERE `fileID`=\'"+fileid+"\' "
  return CommonDB.dbshow("DBI:ODBC:files",sql)  
end  #def Fscan.getDB_Mtime(file)

def Fscan.getMtime(file)
  return self.returnSqlFormatTime(File.new(file).mtime) 
end #def Fscan.getMtime(file)


def Fscan.dbupdateNoModifiedTabFile(file)
  fileid=self.getFileID(file)
  folderid=self.getFolderID(file)
  sql= "UPDATE `file` SET `modified` = '0',`exist` = '0'  WHERE `fileID` =\'"
  sql=sql+ fileid
  sql=sql+ "\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql)
  
  
  sql= "UPDATE `file` SET `lastseetime` = '"+Misc.datenow()+"\' WHERE `fileID` =\'"
  sql=sql+ fileid
  sql=sql+ "\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql) 
  
  
  sql= "UPDATE `file` SET `lastseetime` = '"+Misc.datenow()+"\' WHERE `fileID` =\'"
  sql=sql+ fileid
  sql=sql+ "\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql)  
  
  
    sql= "UPDATE `folder` SET `Status` = \'0\' WHERE `FolderID` =\'"
  sql=sql+ folderid
  sql=sql+ "\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql)  
  
  
  
end #def Fscan.dbupdateNoModifiedTabFile(file)

  
def Fscan.dbupdateStatusofTabFolder(status,file)
  if ["0","1"].include?(status.to_s)
   folderId=self.getFolderID(file) 
   sql="update `folder` set `Status`=\'"
  sql=sql+ status
  sql=sql+ "\' WHERE `FolderID`=\'"
  sql=sql+ folderId
  sql=sql+ "\'"
  CommonDB.dbprocess("DBI:ODBC:files",sql)
  end #  if ["0","1"].include?(status.to_s)
   
end #def Fscan.dbupdateStatusofTabFolder(status,fileInFullpath)

  
def Fscan.updateFileExistInFileTab(status, sqlwherefield)
  if ["0","1"].include?(status.to_s)
  sql="update `file` set `exist`=\'" + status.to_s + "\' "+ sqlwherefield.to_s
  CommonDB.dbprocess("DBI:ODBC:files",sql)
  end
end #def Fscan.updateFileExistInFileTab(status)


def Fscan.fileNotExistInDB(file) #return True if not exist, False for exist
    return self.getFileID(file).empty?
end #def Fscan.fileNotExistInDB(file)

  
 def  Fscan.getFileID(file)
  folderId=self.getFolderID(file)
  filename=self.getFilename(file)
  sql="SELECT `fileID` FROM `file` WHERE `fname`=\'"
  sql=sql+   filename 
  sql=sql+       "\' and `folderID`=\'"
  sql=sql+   folderId
  sql=sql+  "\'"   
  return CommonDB.dbshow("DBI:ODBC:files",sql)  
 end # def  Fscan.getFileID(file)
 
 def Fscan.getFilename(file)
 return File.expand_path(file).split("/")[-1]
end  #def Fscan.getFilename(file)

  
 def  Fscan.getFolderInfoInFolder(folder)
  #return a hash,the hash key is 'folder', element is 'sunfolders in the folder'
  #puts "Scaning "+folder
  
  Dir.chdir(folder)
 
  subFolderAry=[]
  Dir.foreach(folder) {|x|
    fileInFullpath=x
    fileInFullpath=File.expand_path(x)
        
    if File.directory?(fileInFullpath) and x!="." and x!=".."
      #Dir.chdir(fileInFullpath)
      #puts "we are now at  " +fileInFullpath
      subFolderAry << fileInFullpath
      #puts "  Found subfolder: "+fileInFullpath

    end # File.directory?(fileInFullpath) and x!="." and x!=".."
}
   hash={folder =>  subFolderAry }
   #puts subFolderAry.length
   #puts hash
   return subFolderAry
 end # def  Fscan.getFolderInfoInFolder(folder)
 


def Fscan.getlayer1Dir(folder)  
  layer1FolderList=[]
  layer1FolderList=Fscan.getFolderInfoInFolder(folder)
  return layer1FolderList
end #def Fscan.getlayer1Dir(folder)



def Fscan.getlayer2Dir(folder)
  layer2FolderList=[]
  layer1FolderList=self.getlayer1Dir(folder)
  layer1FolderList.each { |x| layer2FolderList = layer2FolderList+ Fscan.getFolderInfoInFolder(x) }
  return layer2FolderList
end #def Fscan.getlayer2Dir(folder)

def Fscan.getlayer3Dir(folder)
  layer3FolderList=[]
  layer2FolderList=self.getlayer2Dir(folder)
  layer2FolderList.each { |x| layer3FolderList = layer3FolderList+ Fscan.getFolderInfoInFolder(x) }
  return layer3FolderList
end #def Fscan.getlayer3Dir(folder)

def Fscan.getlayer4Dir(folder)
  layer4FolderList=[]
  layer3FolderList=self.getlayer3Dir(folder)
  layer3FolderList.each { |x| layer4FolderList = layer4FolderList+ Fscan.getFolderInfoInFolder(x) }
  return layer4FolderList
end #def Fscan.getlayer4Dir(folder)



def Fscan.dbinsert2TabFolder(folder)
  foldername=folder.split("/")[-1]
  folderID=self.getMaxFolderID.to_i+1
  datenow=Misc.datenow()
  
  insertFolderSql="INSERT INTO `folder` ( `ServerID` , `FolderID` ,`FolderName`, `Path` , `FirstFndTime` , `LastSeeTime` , `Status`, `Exist` )\
   VALUES  (\'1\', \'"+folderID.to_s+"\',\'"+foldername+"\', \'"+folder+"\', \'"+datenow+"\', \'"+datenow+"\', \'0\',\'0\');"  
  CommonDB.dbprocess("DBI:ODBC:files",insertFolderSql)
  
end #def Fscan.dbinsert2TabFolder


def Fscan.ifPathExistInTabFolder(folder)
  queryPathSql="select `FolderID` from `folder` where `Path`=\'"+folder+"\'"
  return !CommonDB.dbshow("DBI:ODBC:files",queryPathSql).empty? 
end  #def Fscan.ifPathExistInTabFolder(folder)

def Fscan.getMaxFolderID()
  sql="SELECT MAX(FolderID) FROM folder WHERE 1"
  return CommonDB.dbshow("DBI:ODBC:files",sql) 
end  #def Fscan..getMaxFolderID()

def Fscan.getMaxFileID()
  sql="SELECT MAX(fileID) FROM file WHERE 1"
  return CommonDB.dbshow("DBI:ODBC:files",sql) 
end  #def Fscan.getMaxFileID()


def Fscan.getFolderID(folderOrfile)
  if File.directory?(folderOrfile)
    dir=folderOrfile
  else
    dir=File.dirname(File.expand_path(folderOrfile))
 end     #if File.directory?(folderOrfile)

  sql="SELECT FolderID FROM folder where Path=\'"+dir+"\'"
  return CommonDB.dbshow("DBI:ODBC:files",sql) 
end #def Fscan.getFolderID(folder)



def Fscan.dbupdateTabFolderLastSeeTime(folder)
  folderID=self.getFolderID(folder)
  datenow=Misc.datenow()
  insertFolderSql="UPDATE `folder` set `LastSeeTime`=\'"+datenow+"\',`Exist`=\'0\' where FolderID=\'"+folderID+"\'" 
  
  CommonDB.dbprocess("DBI:ODBC:files",insertFolderSql)
end #def Fscan.dbupdateTabFolderLastSeeTime(folder)

def Fscan.dbsetTabFolderExistto1
  sql="UPDATE `folder` set `Exist`=\'1\' where 1" 
   CommonDB.dbprocess("DBI:ODBC:files",sql)
end #def Fscan.dbsetTabFolderExistto1


#def Fscan.

end #module Fscan
  