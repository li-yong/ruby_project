# encoding: UTF-8
# encoding: utf-8
#Encoding.default_internal

module Misc
  require 'rubygems'
  require 'DBI'
  require 'cmm'
  #require "rtranslate"
  require 'net/smtp'
  require "watir"
  require "zencart"
  require "pathname"
  require "bitme"

  def Misc.datenow()

    year=DateTime.now.year.to_s
    mon=DateTime.now.month.to_s; mon="0"+mon if mon.length==1
    day=DateTime.now.day.to_s;day="0"+day if day.length==1
    hour=DateTime.now.hour.to_s;hour="0"+hour if hour.length==1
    min=DateTime.now.min.to_s;min="0"+min if min.length==1
    sec=DateTime.now.sec.to_s;sec="0"+sec if sec.length==1

    #puts year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
    return year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
  end #def Misc.datenow()

  def Misc.datenow2()

    year=DateTime.now.year.to_s
    mon=DateTime.now.month.to_s; mon="0"+mon if mon.length==1
    day=DateTime.now.day.to_s;day="0"+day if day.length==1
    hour=DateTime.now.hour.to_s;hour="0"+hour if hour.length==1
    min=DateTime.now.min.to_s;min="0"+min if min.length==1
    sec=DateTime.now.sec.to_s;sec="0"+sec if sec.length==1

    #puts year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
    return year+"-"+mon+"-"+day+"_"+hour+"_"+min+"_"+sec
  end #def Misc.datenow()

  def Misc.datenow3()

    year=DateTime.now.year.to_s
    mon=DateTime.now.month.to_s; mon="0"+mon if mon.length==1
    day=DateTime.now.day.to_s;day="0"+day if day.length==1
    hour=DateTime.now.hour.to_s;hour="0"+hour if hour.length==1
    min=DateTime.now.min.to_s;min="0"+min if min.length==1
    sec=DateTime.now.sec.to_s;sec="0"+sec if sec.length==1

    #puts year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
    return year+"-"+mon+"-"+day
  end #def Misc.datenow()

  #APPEND TXT TO FILENAME , should works for both Win and Lnx
  def Misc.saveTxt2File(txt,filename)
    path=Pathname.new(filename).split[0].to_s
    basename=Pathname.new(filename).split[1].to_s # or File.basename(filename)
    basename=Misc.removeWindowsInvalidCharFileName(basename)

    filename=path+"/"+basename

    comments="-- "+self.datenow()
    myfile=File.new(filename,"a+")
    #myfile.puts(comments)
    myfile.puts(txt)
    myfile.close
  end #def Misc.saveTxt2File(txt,file)

  #OVERWRITE TXT TO FILENAME , should works for both Win and Lnx
  def Misc.saveTxt2FileOverwrite(txt,filename)
    path=Pathname.new(filename).split[0].to_s
    basename=Pathname.new(filename).split[1].to_s # or File.basename(filename)
    basename=Misc.removeWindowsInvalidCharFileName(basename)

    filename=path+"/"+basename
    FileUtils.mkdir_p path

    comments="-- "+self.datenow()
    myfile=File.new(filename,"w+")
    #myfile.puts(comments)
    myfile.puts(txt)
    myfile.close
    # puts filename +" was saved"
  end #def Misc.saveTxt2File(txt,file)

  def Misc.dbprocess(sql)
    #sql=self.txt2Sql(sql.to_s)
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
    #dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','')

    #puts sql

    file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_unidb"
    sql=sql+";"

    self.saveTxt2File(sql,file)
    dbh.do(sql)
    print "."
    sleep 0.01
    dbh.disconnect if dbh
  end

  def Misc.dbprocessTEST(sql)
    dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','')
    dbh.do(sql)
    dbh.disconnect if dbh
  end

  #back first record with selectsql result
  def Misc.dbshow(selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    resultarr=[]
    #puts selectsql
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
    #dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    # sleep 2
    while row=sth.fetch do
      #p row
      resultarr << row
    end

    dbh.disconnect if dbh

    if resultarr.length > 0
      return resultarr[0][0].to_s
      #puts resultarr[0][0]
    else
      return ""
    end#  if resultarr.length > 0
  end#def Misc.dbshow(selectsql)

  #Common back first record with selectsql result
  def Misc.dbshowCommon(odbc,selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    resultarr=[]
    #puts selectsql
    dbh = DBI.connect("DBI:ODBC:#{odbc}",'root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    # sleep 2
    while row=sth.fetch do
      #p row
      resultarr << row
    end

    dbh.disconnect if dbh

    if resultarr.length > 0
      return resultarr[0][0].to_s
      #puts resultarr[0][0]
    else
      return ""
    end#  if resultarr.length > 0
  end#def Misc.dbshowCommon(selectsql)

  #Common back one column  array with selectsql result
  def Misc.dbshowArray(selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    resultarr=[]
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    sth = dbh.prepare(selectsql)
    #puts selectsql
    sth.execute
    while row=sth.fetch do
      #p row[0]
      resultarr << row[0]
    end

    #puts sth
    dbh.disconnect if dbh

    if resultarr.length > 0
      return resultarr
    else
      return ""
    end#  if resultarr.length > 0
  end#def Misc.dbshowArray(selectsql)

  #back one row  array with selectsql result, like 'select * from main where myID=1'
  def Misc.dbshowArrayCommon(odbc,selectsql)

    #selectsql=self.txt2Sql(selectsql.to_s)
    resultarr=[]
    tmparr=[]
    dbh = DBI.connect("DBI:ODBC:#{odbc}",'root','')
    #puts selectsql

    sth = dbh.prepare(selectsql)
    sth.execute

    resultarr = sth.fetch
    resultarr=[] if resultarr.nil?
    dbh.disconnect if dbh

    if resultarr.length > 0
      #p resultarr
      return resultarr
    else
      return ""
    end#  if resultarr.length > 0

  end #def Misc.dbshowArrayCommon(odbc,selectsql)

  #################
  #back multi row  array with selectsql result, like 'select * from main where myID > 1'
  #uage:
  #
  #  return.fetch do |row|
  #  printf "First Name: %s, Last Name : %s\n", row[0], row[1]
  #  printf "Age: %d, Sex : %s\n", row[2], row[3]
  #  printf "Salary :%d \n\n", row[4]
  #  end
  #
  # or for a COLUMN : "SELECT `holdid` FROM `hold_statistic` WHERE 1"
  #################

  def Misc.dbshowMultiArrayCommon(odbc,selectsql)

    #selectsql=self.txt2Sql(selectsql.to_s)

    dbh = DBI.connect("DBI:ODBC:#{odbc}",'root','')
    #puts selectsql

    sth = dbh.prepare(selectsql)
    sth.execute

    resultarr=[]
    sth.fetch do |row|
      myarr=[]
      row.to_a.each{|data| myarr << data   }
      resultarr <<  myarr
    end

    resultarr=[] if resultarr.nil?
    dbh.disconnect if dbh
    return resultarr

  end #def Misc.dbshowMultiArrayCommon(odbc,selectsql)

  def Misc.dbprocessCommon(odbc,sql)
    #sql=self.txt2Sql(sql.to_s)
    dbh = DBI.connect("DBI:ODBC:#{odbc}",'root','')

    #puts sql

    sql=sql+";"

    dbh.do(sql)
    file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_#{odbc}"

    self.saveTxt2File(sql,file)

    print "."
    sleep 0.01
    dbh.disconnect if dbh

    return true
  end #  def Misc.dbprocessCommon(odbc,sql)

  def Misc.dbprocessCommonUTF8FromFile(odbc,db,user,passwd,sql)

    fileexecute="C:/tmp/tmpExecute.sql"
    Misc.saveTxt2FileOverwrite(sql,fileexecute)
    cmd="mysql -u#{user} -p#{passwd} #{db} < #{fileexecute}"
    system(cmd)

    file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_#{odbc}"
    self.saveTxt2File(sql,file)

    print "."
    sleep 0.01

    return true
  end #  def Misc.dbprocessCommonUTF8FromFile(odbc,sql)

  def Misc.dbshowMultiResults(selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    #puts selectsql
    resultarr=[]
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    resultarr=sth.fetch_all.join(",").split(",")
    dbh.disconnect if dbh
    return resultarr  # ["1", "2", "3", "4", "5", "6"]
  end#def Misc.dbshowMultiResults(selectsql)

  def Misc.dbshowMultiResultsCommon(odbc,selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    #puts selectsql
    #puts 'DBI:ODBC:#{odbc}'
    resultarr=[]
    dbh = DBI.connect("DBI:ODBC:#{odbc}",'root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    resultarr=sth.fetch_all.join(",").split(",")
    dbh.disconnect if dbh
    return resultarr  # ["1", "2", "3", "4", "5", "6"]
  end#def Misc.dbshowMultiResultsCommon(selectsql)

  #dbshowWholeArray HAVE PROBLEM, careful use
  def Misc.dbshowWholeArray(selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    #puts selectsql
    resultarr=[]
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    while row=sth.fetch do
      #p row
      resultarr << row
      #p resultarr
    end

    dbh.disconnect if dbh
    return resultarr

  end#def Misc.dbshowWholeArray(selectsql)

  #back multi column  array with selectsql result
  def Misc.getfiles(selectsql)
    #selectsql=self.txt2Sql(selectsql.to_s)
    resultarr=[]
    #puts selectsql
    dbh = DBI.connect('DBI:ODBC:unidb','root','')
    sth = dbh.prepare(selectsql)
    sth.execute
    while row=sth.fetch do
      #p row
      #resultarr << row[0]+"<mysep,>"+row[1]+"<mysep,>"+row[2]
      judge = row[0].nil? or row[1].nil? or row[2].nil?
      if !judge
        resultarr << [row[0],row[1],row[2]]
        #puts resultarr
      end
    end

    dbh.disconnect if dbh

    if resultarr.length > 0
      return resultarr
    else
      return ""
    end#  if resultarr.length > 0
  end#def Misc.getfiles(selectsql)

  #return 1 if give softid existed. (softid is the uid in each software site)
  #return 0 if give softid not existed.
  def Misc.hasID(id,site)
    site=site.to_s.strip
    id=self.txt2Sql(id.to_s)
    sql="SELECT count( * ) \
FROM `main` \
WHERE `softuid` ="
    sql=sql+ id.to_s
    sql=sql+" and `site`=\""+site+"\""

    #puts sql
    self.dbshow(sql)

  end

  #return 1 if give softid existed. (softid is the uid in each software site)
  #return 0 if give softid not existed.
  def Misc.hasFile(myid)
    id=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `files` \
WHERE `myID` ="
    sql=sql+id.to_s
    #puts sql
    self.dbshow(sql)
  end #def Misc.hasFile(myid)

  #return 1 if give myID is featured.
  #return 0 if give myID is not featured
  def Misc.hasFeatured(myid)
    id=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `featured` \
WHERE `myID` ="
    sql=sql+id.to_s
    #puts sql
    self.dbshow(sql)
  end #def Misc.hasFeatured(myid)

  #return 1 if give softid existed title image. (softid is the uid in each software site)
  #return 0 if give softid not existed  title image.
  def Misc.hasTitleImg(myid)
    id=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `images` \
WHERE `myID` ="
    sql=sql+id.to_s

    sql=sql+" AND `titleimage`=\"1\" AND `imgLclPth` != \"dlerr:imgnotdownload\"  AND `imgLclPth` != \"dlerr:imgtoosmall\" "

    #puts sql
    self.dbshow(sql)
  end #def Misc.hasTitleImg(myid)

  #return 1 if give softid existed. (softid is the uid in each software site)
  #return 0 if give softid not existed.
  def Misc.hasImgLocal(myid)
    id=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `images` \
WHERE `myID` ="
    sql=sql+id.to_s
    sql=sql+" AND `imgLclPth` IS NOT NULL"
    sql=sql+" AND `imgLclPth` NOT LIKE \"dlerr%\""
    #puts sql
    self.dbshow(sql)
  end #def Misc.hasImgLocal(myid)

  #return0 if give myid existed in `description` table
  def Misc.hasmyIDDescription(myid)
    myid=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `description` \
WHERE `myID` ="
    sql=sql+myid.to_s

    self.dbshow(sql)
    #puts sql

  end #def Misc.hasmyIDDescription(myid)

  def Misc.hasSoftName(softname)
    softname=self.txt2Sql(softname.to_s)
    sql="SELECT count( * ) \
FROM `main` \
WHERE `softname` ='"
    sql=sql+softname.to_s
    sql=sql+"';"
    #puts sql
    self.dbshow(sql)

  end #def Misc.hasSoftName(softname)

  def Misc.hasdlpathmap(myid)
    id=self.txt2Sql(myid.to_s)
    sql="SELECT count( * ) \
FROM `dlpathmap` \
WHERE `myID` ="
    sql=sql+id.to_s
    #puts sql
    self.dbshow(sql)
  end #def Misc.hasdlpathmap(myid)

  def Misc.getMyID(softname)
    softname=self.txt2Sql(softname.to_s)
    sql="select  `myID` \
FROM `main` \
WHERE `softname` =  "
    sql= sql+ "\""+ softname+"\""
    sql=sql+";"
    #puts sql
    self.dbshow(sql)

  end #def Misc.getMyID(softname)

  def Misc.getSoftname(myid)
    myid=self.txt2Sql(myid.to_s)
    sql="select  `softname` \
FROM `main` \
WHERE `myID` =  "
    sql= sql+ "\""+  myid +"\""
    sql=sql+";"
    #puts sql
    self.dbshow(sql)

  end #def Misc.getSoftname(myid)

  def Misc.getSoftSite(myid)
    myid=self.txt2Sql(myid.to_s)
    sql="select  `site` \
FROM `main` \
WHERE `myID` =  "
    sql= sql+ "\""+  myid +"\""
    sql=sql+";"
    #puts sql
    self.dbshow(sql)

  end #def Misc.getSoftSite(myid)

  def Misc.getDescriptionHtml(myid)
    myid=self.txt2Sql(myid.to_s)
    sql="select  `html` \
FROM `description` \
WHERE `myID` =  "
    sql= sql+ "\""+  myid +"\""
    sql=sql+";"
    #puts sql
    self.dbshow(sql)

  end #def Misc.getDescriptionHtml(myid)

  def Misc.delete_id_from_tbl(table,id)
    table=table.to_s
    id=id.to_s
    sql="delete from `"+table+"` WHERE `myID`= "+'"' +id + '"'
    self.dbprocess(sql)
    puts "deleted "+id+" from tbl "+table
  end #def Misc.delete_id_from_tbl(table,id)

  def Misc.delete_from_db_by_vendor(site)
    site=site.to_s
    sql="SELECT `myID` FROM `main` WHERE `site` = " +'"'+ site +'"'
    idlist= self.dbshowArray(sql)
    if idlist != ""
      idlist_str=""
      idlist.each{|x|  idlist_str=idlist_str+", '"+x.to_s+"'"}
      idlist_str=idlist_str.sub(",","")
      where="where `myID` in ("+idlist_str+")"

      sql="DELETE FROM `description` "+where;  self.dbprocess(sql)
      sql="DELETE FROM `dlpathmap` "+where;  self.dbprocess(sql)
      sql="DELETE FROM `files` "+where;  self.dbprocess(sql)
      sql="DELETE FROM `images` "+where;  self.dbprocess(sql)
      sql="DELETE FROM `url` "+where;  self.dbprocess(sql)
      sql="DELETE FROM `main` "+where;  self.dbprocess(sql)
    end #if idlist != ""
    #idlist.each { |id| id=id.to_s; Misc.deleteBySID(id)  }
  end #def Misc.delete_from_db_by_vendor(site)

  def Misc.deleteBySID(sid)
    sid=sid.to_s
    self.delete_id_from_tbl("description",sid)
    self.delete_id_from_tbl("dlpathmap",sid)
    self.delete_id_from_tbl("files",sid)
    self.delete_id_from_tbl("images",sid)
    self.delete_id_from_tbl("url",sid)
    self.delete_id_from_tbl("featured",sid)
    self.delete_id_from_tbl("main",sid) #delte main last to avoid orphan records

  end #def Misc.deleteBySID(sid)

  def Misc.delBySoftName(softname)
    sid=self.getMyID(softname)
    self.deleteBySID(sid)
  end #def Misc.delBySoftName(softname)

  def Misc.orphanDelete()
    sql="SELECT `myID` FROM `main` WHERE 1"
    mainlist= self.dbshowArray(sql)

    sql="SELECT `myID` FROM `description` WHERE 1"
    desclist= self.dbshowArray(sql)
    desclist=desclist- mainlist if desclist !=""

    sql="SELECT `myID` FROM `dlpathmap` WHERE 1"
    dlpathlist= self.dbshowArray(sql)
    dlpathlist=dlpathlist- mainlist if dlpathlist !=""

    sql="SELECT `myID` FROM `files` WHERE 1"
    filelist= self.dbshowArray(sql)
    filelist=filelist- mainlist if filelist !=""

    sql="SELECT `myID` FROM `images` WHERE 1"
    imagelist= self.dbshowArray(sql)
    imagelist=imagelist- mainlist if imagelist !=""

    sql="SELECT `myID` FROM `url` WHERE 1"
    urlist= self.dbshowArray(sql)
    urlist=urlist- mainlist if urlist !=""

    sql="SELECT `myID` FROM `featured` WHERE 1"
    featuredlist= self.dbshowArray(sql)
    featuredlist=featuredlist- mainlist if urlist !=""

    desclist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("description",id)  }
    dlpathlist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("dlpathmap",id)  }
    filelist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("files",id)  }
    imagelist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("images",id)  }
    urlist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("url",id)  }
    featuredlist.each { |id| id=id.to_s; Misc.delete_id_from_tbl("featured",id)  }

  end # def Misc.orphanDelete()

  def Misc.removeEmptyDescriptionProduct()

    sql="SELECT `myID` FROM `description` WHERE `html` = ''"

    resultArray=self.dbshowArray(sql)
    resultArray.each{|myID|

      if self.getDescriptionHtml(myID)== ""
        self.deleteBySID(myID)
      end #if Misc.getDescriptionHtml(myID)== ""

    }

  end #def Misc.removeEmptyDescriptionProduct()

  def Misc.hasInFileName(myid, insoftname) #check if individual file already insert into database
    insoftname=self.txt2Sql(insoftname.to_s)
    myid=self.txt2Sql(myid.to_s)

    sql="SELECT count( * ) \
FROM `files` \
WHERE `myID`=" + myid   + \
"AND `filename` ='"
    sql=sql+insoftname.to_s
    sql=sql+"';"
    #puts sql

    self.dbshow(sql)

  end

  def Misc.wordProcess(x)
    x1=self.removeCrackerOrg(x)
    x2=self.removeKW(x1)
    #donot include self.removeDot here
    #it suppose used for 9iv.ftp only
  end

  def Misc.txt2Sql(x)
    x=x.to_s
    x=Iv.removeDBCS(x)
    x=x.gsub("\\'","'")  # \' --> '
    x=x.gsub("\\\"","\"") # \" --> "
    x=x.gsub(/'/,"''")  #' --> ''

    #   x2=x1.gsub(/"/,'')
    #   x3=x2.gsub(//,'')

  end

  def Misc.txt2SqlNotRemoveDBCS(x)
    x=x.to_s

    x=x.gsub("\\'","'")  # \' --> '
    x=x.gsub("\\\"","\"") # \" --> "
    x=x.gsub(/'/,"''")  #' --> ''

  end

  def Misc.removeCrackerOrg(x)
    x=x.to_s
    if !x.nil?
      i="-ACME|" \
      +"-AGAiN|" \
      +"-AiR|" \
      +"-DaD|" \
      +"-QUANTiZ|" \
      +".Cracked|" \
      +"-CODePD|" \
      +"-CFFPDA|" \
      +"-AiRISO|" \
      +"-ALiAS|" \
      +"-APXiSO|" \
      +"-ArCADE|" \
      +"-ARN|" \
      +"-Ayan13|" \
      +"-BACKLASH|" \
      +"-BB3D|" \
      +"-BBL|" \
      +"-BEAN|" \
      +"-BiNPDA|" \
      +"-BLiZZARD|" \
      +"-CAXiSO|" \
      +"-BRD|" \
      +"-BReWErS|" \
      +"-BSOUNDZ|" \
      +"-CAUiSO|" \
      +"-CFE|" \
      +"-CHiCNCREAM|" \
      +"-CoL|" \
      +"-CORE|" \
      +"-CRD|" \
      +"-CROSSFiRE|" \
      +"-CYGiSO|" \
      +"-CzW|" \
      +"-DAJEWS|" \
      +"-DDU|" \
      +"-DELiGHT|" \
      +"-DIGERATI|" \
      +"-DJiNN|" \
      +"-DOA|" \
      +"-DRL|" \
      +"-DVD9|" \
      +"-DVT|" \
      +"-DVTiSO|" \
      +"-DYNAMiCS|" \
      +"-DYNAMiCS|" \
      +"-EDGE|" \
      +"-ELPUTOGRANDE|" \
      +"-EMBRACE|" \
      +"-EMBRACE|" \
      +"-ENGiNE|" \
      +"-EQUiNOX|" \
      +"-ErESPDA|" \
      +"-ESET|" \
      +"-F4CG|" \
      +"-FALLEN|" \
      +"-FAS|" \
      +"-FCNiSO|" \
      +"-FEGPDA|" \
      +"-FOSI|" \
      +"-FtpDown|" \
      +"-G1R0cKz|" \
      +"-GETLiB|" \
      +"-GFX|" \
      +"-GFXnews|" \
      +"-GiZPDA|" \
      +"-GRB|" \
      +"-HACKERSVIEW|" \
      +"-Head of an Arab|" \
      +"-HEiRLOOM|" \
      +"-HELL|" \
      +"-HERiTAGE|" \
      +"-HMX0101|" \
      +"-HOTiSO|" \
      +"-HS|" \
      +"-HSpda|" \
      +"-iMST|" \
      +"-iND|" \
      +"-iNK|" \
      +"-iPA|" \
      +"-ISO|" \
      +"-JANOSiK|" \
      +"-JGTiSO|" \
      +"-JGTiSO 2009 2|" \
      +"-JUSTiSO|" \
      +"-KiMERA|" \
      +"-L3F0U|" \
      +"-LAME|" \
      +"-LAXiTY|" \
      +"-LiGHTHELL|" \
      +"-LMi|" \
      +"-LND|" \
      +"-Lz0|" \
      +"-MAGNiTUDE|" \
      +"-MAZE|" \
      +"-MiSSiON|" \
      +"-MP3|" \
      +"-MSGPDA|" \
      +"-NeoX|" \
      +"-NGEN|" \
      +"-nIV|" \
      +"-NoPE|" \
      +"-NULL|" \
      +"-oDDiTy|" \
      +"-OUTLAWS|" \
      +"-PARADOX|" \
      +"-PGN|" \
      +"-PH|" \
      +"-PlanB|" \
      +"-QUASAR|" \
      +"-RC4Y|" \
      +"-RECOiL|" \
      +"-RECOiL|" \
      +"-RENOiSE|" \
      +"-REUNION|" \
      +"-rG|" \
      +"-rGPDA|" \
      +"-RiFT|" \
      +"-RiSE Oracle|" \
      +"-RiTUEL|" \
      +"-ROGU|" \
      +"-ROGUE|" \
      +"-SaG|" \
      +"-SCENE|" \
      +"-SFNightmare|" \
      +"-SHOCK|" \
      +"-SHooTERS|" \
      +"-SiMPLiFY|" \
      +"-SiNiSTER|" \
      +"-SL|" \
      +"-SoS|" \
      +"-SoSISO|" \
      +"-SQUARE|" \
      +"-TBE|" \
      +"-TDA|" \
      +"-TE|" \
      +"-TFT|" \
      +"-TSG|" \
      +"-TYPO|" \
      +"-uIV|" \
      +"-UNION|" \
      +"-UNiQUE|" \
      +"-Unleashed|" \
      +"-VACE|" \
      +"-ViH|" \
      +"-ViP|" \
      +"-ViRiLiTY|" \
      +"-ViRiLiTY|" \
      +"-WiNK|" \
      +"-WoG|" \
      +"-XFORCE|" \
      +"-XiSO|" \
      +"-XiSO ERP|" \
      +"-XXII|" \
      +"-YPOGEiOS|" \
      +"-YYePGiSO|" \
      +"-ZuM|" \
      +"-ZWT|" \
      +"-ZWTiSO|" \
      +"-FoRTuNe|" \
      +"-ABSOKT|" \
      +"-SUNiSO|" \
      +".DVDR-|" \
      +"-TACTiLE|" \
      +"-BNT|" \
      +"-AMPLiFYiSO|" \
      +"-PANTHEON|" \
      +"-iPWNPDA|" \
      +"-ZZGiSO|"  \
      +"-NiGHTNiNG|" \
      +"-EAT|" \
      +"-AG|"

      x.gsub(/#{i}/i,"")
    end #if !x.nil?
  end

  def Misc.removeDot(x)
    x=x.to_s
    if !x.nil?
      # i="([a-zA-Z])\.([a-zA-Z)] "
      #x.gsub(/#{i}/,'\1 \2')
      x1=x.gsub(/([a-zA-Z])\.([a-zA-Z])/,'\1 \2')
      x2=x1.gsub(/([0-9])\.([a-zA-Z])/,'\1 \2')
      x3=x2.gsub(/([a-zA-Z])\.([0-9])/,'\1 \2')
    end #if !x.nil?
  end

  def Misc.removeKW(x)
    x=x.to_s
    if !x.nil?

      i="crack|"
      i=i+"torrent|"
      i=i+"emule|"
      i=i+"seed|"
      i=i+"gfxnews|"
      i=i+"mininova|"
      i=i+"9down|"
      i=i+"hxsd|"
      i=i+"thepiratebay|"
      i=i+"rarbg|"
      i=i+"taobao|"
      i=i+"qq|"
      i=i+"Wangwang|"
      i=i+"Alipay|"
      i=i+"rarbg|"
      i=i+"NOD32|"
      i=i+"DonkeyServer|"
      i=i+"Donkey|"
      i=i+"eDonkey|"
      i=i+"emule|"
      i=i+"verycd|"
      i=i+"9iv|"

      x.gsub(/#{i}/i,"")
    end #if !x.nil?
  end  #def Misc.removeKW(x)

  def Misc.isFeaturedProduct(string)

    string=string.to_s
    rtn=false
    #COMPANY
    kwarray=["adobe"]
    kwarray=kwarray+["Microsoft"]
    kwarray=kwarray+["Autocad"]
    kwarray=kwarray+["3DS "]
    kwarray=kwarray+["Quicken"]
    kwarray=kwarray+["Quickbooks"]
    kwarray=kwarray+["Parallels"]
    kwarray=kwarray+["quicken"]
    #kwarray=kwarray+["MAC"]
    kwarray=kwarray+["GarageBand"]
    kwarray=kwarray+["Matlab"]
    kwarray=kwarray+["Rosetta"]

    # PRODUCT
    kwarray=kwarray+["iwork"]
    kwarray=kwarray+["photoshop"]
    kwarray=kwarray+["office"]
    kwarray=kwarray+["rhino"]
    kwarray=kwarray+["ilife"]
    kwarray=kwarray+["cs5"]
    kwarray=kwarray+["cs4"]
    kwarray=kwarray+["cs3"]
    #  kwarray=kwarray+["photoshop"]
    #  kwarray=kwarray+["photoshop"]

    kwarray.each {|x|

      return true if string.upcase.include?(x.to_s.upcase)

    }

    return rtn

  end #def Misc.isFeaturedProduct(x)

  def Misc.removeWindowsInvalidCharFileName(s)
    s=s.to_s
    #s="< > : \" / \ | ? *"
    s=s.gsub(/\</,"")
    s=s.gsub(/\>/,"")
    s=s.gsub(/:/,"")
    s=s.gsub(/\//,"")
    s=s.gsub(/\\/,"") #this is moved "\" which in windows path
    s=s.gsub(/\"/,"")
    s=s.gsub(/\|/,"")
    s=s.gsub(/\?/,"")
    s=s.gsub(/\*/,"")

    return s
  end #def Misc.removeWindowsInvalidCharFileName(x)

  def Misc.putSID(ie)
    maintable=ie.table(:class,"borderbottom")

    arrSID = [ ]
    maintable.each { |x|
      if x.column_count == 15
        softid = x[4].html.split("?t=")[1].to_s.split("\"")[0].to_s
        if softid.to_i > 0
          if self.hasID(softid.to_s, "gfxnews").to_s=="0"
            arrSID << softid.to_s
            puts softid+" push to array"
          else
            print self.hasID(softid.to_s,"gfxnews")
            puts softid+" existed, skip."
          end

        end
        #system(ru3_saveEachSoftPage.rb ie softid)
      end
    }

    arrSID.each{|softid| self.saveSID(softid) }

  end

  def Misc.getMaxMyID()
    sql="SELECT MAX(myID) FROM main WHERE 1"
    a=self.dbshow(sql)
    a="0" if a.nil?
    #a="0" if a.empty
    return a
  end

  def Misc.getNewMyID()
    maxMyID=self.getMaxMyID()
    newMyID=maxMyID.to_i + 1
    newMyID=newMyID.to_s
    return newMyID
  end

  def Misc.getMaxFeaturedID()
    sql="SELECT MAX(myID) FROM `featured` WHERE 1"
    a=self.dbshow(sql)
    a="0" if a.nil?
    return a
  end

  def Misc.getMaxMyIDHasTitleImage()
    sql="SELECT MAX(myID) FROM `images`  WHERE `titleimage` = 1"
    a=self.dbshow(sql)
    a="0" if a.nil?
    return a
  end

  def Misc.savehtml2file(file,ie)
    myfile=File.new(file,"w+")
    myfile.puts(ie.html)
    myfile.close
  end

  # Most important function,
  # Save page to DB
  def Misc.saveSID(sid)
    sid=sid.to_s
    maxMyID=self.getMaxMyID()
    newMyID=maxMyID.to_i + 1
    newMyID=newMyID.to_s

    ie = Watir::Browser.new
    ie.goto "http://forum.gfxnews.ru/viewtopic.php?t="+sid.to_s.chomp
    fullHtmlfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".full.htm"
    descHtmfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".desc.htm"
    descTxtfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".desc.txt"
    allSoftIdFile="C:\\tmp\\torrents\\all.txt"
    csvfile="C:\\tmp\\torrents\\all.csv"

    if !ie.text.include?("No posts exist for this topic") and !ie.text.include?("Could not obtain user information")

      #?????????????????????¨°3????¦Ì?????????
      fullHtml=File.new(fullHtmlfile.to_s,"w+")
      fullHtml.puts(ie.html)
      fullHtml.close

      #??????????????????,?????????,?????????,¡Á¡é??????¨º¡À??????,??????????????D?,???¨¦¡¤???????????????,
      softid=sid.to_s
      softname=ie.table(:index,2)[1][1].div(:index,2).text
      softname=self.wordProcess(softname)

      if  self.hasSoftName(self.txt2Sql(softname)).to_s=="0"#sid is same as softid

        category= ie.table(:index,2)[1][1].div(:index,1).text.split("\>")[1]
        maintable=ie.div(:class,"post").table(:class, "btTbl")
        regDate=maintable.row(:index,3).text.split( )[1]
        sizeNumber=maintable.row(:index,5).text.split( )[1]
        sizeUnion=maintable.row(:index,5).text.split( )[2]
        canDownload=maintable.row(:index,6).text.split()[2]

        puts "softid is: "+softid
        puts "softname is: "+softname
        puts "category is: "+category
        puts "regDate is: "+regDate
        puts "sizeNumber is: "+sizeNumber
        puts "sizeUnion is: "+sizeUnion
        puts "canDownload is: "+canDownload

        #???????????????????????????¡é
        fileinfotable=maintable.row(:id,"filesinfo").table(:class,"btTbl")
        fileCount=fileinfotable.row_count - 1
        sqlfilearr=[]
        for i in 2..fileinfotable.row_count
          #puts "inFileName is:"+fileinfotable.row(:index,i)[1].text

          filesizetext=fileinfotable.row(:index,i)[2].text.sub(/,/, ".").sub(/ +/," ")

          eachFilename=self.txt2Sql(fileinfotable.row(:index,i)[1].text)
          eachFilesizeV=self.txt2Sql(filesizetext.split()[0])
          eachFilesizeU=self.txt2Sql(filesizetext.split()[1].upcase)
          if eachFilesizeU.strip.upcase=="B"
            eachFilesizeU="Byte"
          end #if eachFilesizeU.strip="B"

          #puts "inFileSizeNum is:"+ filesizetext.split()[0]
          #puts "inFileSizeUnit is:"+filesizetext.split()[1]
          #if self.hasInFileName(newMyID,fileinfotable.row(:index,i)[1].text)=="0"

          sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5` ) VALUES ("
          sqlF=sqlF+ \
          newMyID +",'"  \
          + eachFilename+"','"  \
          + eachFilesizeV+"','"  \
          + eachFilesizeU+"','"  \
          + "NULL"+"'" \
          +"); "

          sqlfilearr << sqlF
          #end #if self.hasInFileName(myID,filename).to_s=="0"

        end #for i in 2..fileinfotable.row_count

        #?????????????????????_text
        destable=ie.div(:class,"post")
        tableDescText=destable.text.to_s

        if tableDescText.include?("Description")
          start=tableDescText =~ /Description/
        else
          start=0
        end

        start=start+ "Description".length
        start=start+1
        #sflag=softname+".torrent" #some page not using "softname.torrent" pattern
        sflag=".torrent"
        send=tableDescText =~ /#{sflag}/
        send=send.to_i - start

        desctxt= tableDescText[start,send]
        desctxt= self.wordProcess(desctxt)
        #puts "desctxt is: "+desctxt

        #?????????????????????_html
        tableDescHtml=destable.html.to_s
        if tableDescText.include?("Description")
          hstart= tableDescHtml=~ /Description/
          hstart=hstart+"Description</SPAN>:".length
        else
          hstart=0
        end

        hend= tableDescHtml=~ /js\/ajax.js/
        hend=hend-hstart
        hend=hend-15
        descHtm=tableDescHtml[hstart,hend]
        descHtm=self.wordProcess(descHtm)
        #puts "descHtm is: "+descHtm

        #¨ª???
        imgarr=[]
        ie.images.each { |i|
          if !i.src.to_s.include?("gfxnews")
            #puts i.src.to_s
            imgarr << i.src.to_s
          end
        }

        #????????????????????
        fdescHtm=File.new(descHtmfile,"a")
        fdescHtm.puts(descHtm)
        fdescHtm.close

        fdescTxt=File.new(descTxtfile,"a")
        fdescTxt.puts(desctxt)
        fdescTxt.close

        #csv=File.new(csvfile,"a")
        #csv.puts(softid+","+softname+","+category+","+regDate+","+sizeNumber+","+sizeUnion+","+canDownload+","+fileCount)
        #csv.close

        sqlD="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
        sqlD=sqlD+"VALUES ("
        sqlD=sqlD + \
        newMyID +",'"  \
        + self.txt2Sql(descHtm)+"','"  \
        + self.txt2Sql(desctxt)+"'"  \
        +"); "
        #puts sqlD

        sqlM="INSERT INTO `main` \
( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
        sqlM=sqlM+"VALUES ("
        sqlM=sqlM + \
        newMyID +",'"  \
        + "gfxnews"+"','"  \
        + self.txt2Sql(category)+"','"  \
        + self.txt2Sql(softid.to_s)+"','"  \
        + self.txt2Sql(softname)+"','"  \
        + self.txt2Sql(regDate)+"','"  \
        + self.txt2Sql(sizeNumber)+"','"   \
        + self.txt2Sql(sizeUnion)+"','"  \
        + self.txt2Sql(fileCount.to_s)+"','"   \
        + self.datenow()+"'" \
        +"); "

        if  self.hasSoftName(softname.to_s).to_s=="0".to_s
          self.dbprocess(sqlM)
          puts "executed:  " +sqlM

          self.insert2file(sqlfilearr)
          self.insert2image(newMyID,imgarr)

          if self.hasmyIDDescription(newMyID).to_s=="0".to_s
            self.dbprocess(sqlD)
          end #if !self.hasmyIDDescription(newMyID)

        else # if self.hasID(softid.to_s).to_s=="0"
          puts softid.to_s+" have exists"
          puts self.hasID(softid.to_s,"gfxnews")
          puts self.hasSoftName(softname.to_s)

        end # if self.hasID(softid.to_s).to_s=="0"

      end #if self.hasID(sid.to_s).to_s=="0"
    end #if !ie.txt.include?("No posts exist for this topic") and !ie.text.include?("Could not obtain user information")
    ie.close
  end  #def Misc.saveSID(sid)

  def Misc.insert2file(sqlfilearr)
    if ! sqlfilearr.nil?
      if !sqlfilearr.empty?
        sqlfilearr.each{|sql|
          self.dbprocess(sql)
        }
      end #if !sqlfilearr.empty?
    end # if ! sqlfilearr.nil?

  end #def Misc.insert2file(sqlfilearr)

  def Misc.insert2featured(myid)
    if ! myid.nil?
      softname=self.getSoftname(myid)
      if self.isFeaturedProduct(softname)

        if self.hasFeatured(myid.to_s).to_s == "0"

          sql= "INSERT INTO `featured` (`myID`) VALUES ('"
          sql= sql+myid.to_s
          sql= sql+"\"');"
          self.dbprocess(sql)
        else
          puts "myID #{myid} already in featured table, not insert again."
        end  #if self.hasfeaturedID(myid.to_s).to_s == "0"
      else #if self.isFeaturedProduct(self.getSoftname(myid))
        puts "myID #{myid}'s name #{softname} not included feature product keywords. not insert."

      end # if Misc.isFeaturedProduct(self.getSoftname(myid))

    end # if ! myid.nil?

  end #def Misc.insert2featured(myid)

  def Misc.insertTitleImage(newMyID,singleImage)

    if !singleImage.nil?

      i="1000" #title image id is 1000
      if self.hasTitleImg(newMyID).to_i > 0
        puts "title image already existed for myID #{myid}, will not processing it."
      else

        fullsavepath=Cmm.saveHttpImg(newMyID,singleImage.to_s,"image",i)

        sql="INSERT INTO `images` ( `myID` , `imagepath` , `imgLclPth`, `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
        sql=sql+"VALUES ("
        sql=sql + \
        newMyID +",'"  \
        + self.txt2Sql(singleImage.to_s)+"','"  \
        + fullsavepath +"','"  \
        +"1','0','0');"

        self.dbprocess(sql)
      end # if self.hasTitleImg(myid).to_i > 0

    end #if !singleImage.nil?
  end #def Misc.insertTitleImage(newMyID,singleImage)

  def Misc.removeKWImage(imgarr)
    if !imgarr.nil? and !imgarr.empty?
      kwimgarr=["TOP.gif"]
      kwimgarr=kwimgarr+["iStore001.gif"]
      kwimgarr=kwimgarr+["iStore002.gif"]
      kwimgarr=kwimgarr+["iStore003.gif"]
      kwimgarr=kwimgarr+["bottom.gif"]
      kwimgarr=kwimgarr+["T1TPhsXoRlXXXXXXXX-18-18.png"]
      kwimgarr=kwimgarr+["T17QhgXcbM5tKrJrg4_052111.jpg"]

      removeimgarr=[]

      imgarr.each{|x|
        #p "hah"
        kwimgarr.each{|y| removeimgarr << x if x.to_s.include?(y)  }
      }

      return imgarr - removeimgarr
    else
      puts "imgarr is nil or empty"
    end
  end  #def Misc.removeKWImage(imgarr)

  def Misc.insert2image(newMyID,imgsrcarr)
    puts "checking images in page..."
    imgarr=removeKWImage(imgsrcarr)

    if imgarr.nil?
      puts "no image to insert"
      return
    elsif  !imgarr.empty?
      imgarr.each{|i|

        #Cmm.saveHttpImg(myid,imglink,folder,indexnumberofarray)
        fullsavepath=Cmm.saveHttpImg(newMyID,i.to_s,"image",imgarr.index(i).to_s)

        sql="INSERT INTO `images` ( `myID` , `imagepath` , `imgLclPth`, `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
        sql=sql+"VALUES ("
        sql=sql + \
        newMyID +",'"  \
        + self.txt2Sql(i.to_s)+"','"  \
        + fullsavepath +"','"  \
        +"1','0','0');"

        self.dbprocess(sql)
      }
    end #if !sqlfilearr.empty?

  end #def Misc.insert2image(sqlfilearr)

  def Misc.readytobeRegularExpress(str)
    rtrn=str.to_s
    if !rtrn.nil?
      rtrn=rtrn.gsub(/\?/,"")
      rtrn=rtrn.gsub(/\+/,"")
      rtrn=rtrn.gsub(/\-/,"")
      rtrn=rtrn.gsub(/\*/,"")
      rtrn=rtrn.gsub(/\\/,"")
    else
      rtrn=""
    end   #  if !rtrn.nil?

    return rtrn
  end #def Misc.readytobeRegularExpress(str)

  def Misc.splitSizeUnion(str)

    x=str
    x=Iv.dbsc2onespace(x)
    x=Iv.descTextProcess(x)
    x=Iv.removespace(x)

    x=x.upcase
    if x.include?("MB")
      size=x.split("MB")[0]
      union="MB"
    elsif  x.include?("GB")
      size=x.split("GB")[0]
      union="GB"
    elsif  x.include?("KB")
      size=x.split("KB")[0]
      union="KB"
    elsif  x.include?("BYTE")
      size=x.split("KB")[0]
      union="Byte"
    else
      size="0"
      union="KB"
    end #if x.include?("MB")

    return [size,union]

  end #def Misc.splitSizeUnion(str)

  def Misc.removeEmail(str)
    if !str.nil?
      str=str.gsub(/([a-z0-9_.-]+)@([a-z0-9-]+)\.[a-z.]+/,"s")
    end #  if !str.nil?
    return str
  end #def Misc.removeEmail(str)

  #use this translate short message
  def Misc.googletranslatetoen(cntxt)
    #puts "start translate cn->en"
    #b=Translate.t("\344\270\255\345\233\275", "zh-CN", "en")
    rtn=""
    if cntxt.nil?
      rtn=cntxt
    else
      rtn=Translate.t(cntxt, "zh-CN", "en")
      rtn=rtn.gsub(/[^[:alnum:][:punct:] ]+/,"")
      rtn = rtn.gsub(/\?/,"")
      if rtn.upcase.include?("Error:".upcase)  #error: suspected terms of service abuse. please see http://code.google.com/apis/errors
        puts "\n google translate error: #{rtn}"
        exit
      end # if rtn.include?("Error:")

    end #if cntxt.nil?
    #                    puts " translated <==>"+cntxt+"</==> to "+rtn
    return rtn
  end #def Misc.googletranslatetoen(cntxt)

  def Misc.cleanIE()
    mydir=File.dirname(__FILE__)
    cmd=mydir+"/bin/"+"QLaunch.exe"
    cmd=cmd+" deletecache,deletecookies,deleteall"
    #p cmd
    if system(cmd)
      puts "success cleaned IE caches "
    else
      puts "Fail to clean IE cache"
    end
  end #def Misc.cleanIE()

  def Misc.googletranslatetoenWeb(cntxt,transURL='http://translate.google.com/#zh-CN|en|')

    #self.cleanIE()  #bitme required login, so comment this line out.
    #url='http://translate.google.com/#zh-CN|en|'
    url=transURL
    ie=Watir::Browser.new
    Cmm.launchIEwithTimeout(ie, url, 15)

    #puts "started IE, Cmm.launchIEwithTimeout(ie, url, 15)"
    timeIE=0
    while true do
      timeIE=timeIE+1
      puts "    load google translate page time "+timeIE.to_s

      if ie.select_list(:id,"gt-sl").exist?
        ie.select_list(:id,"gt-sl").set("Chinese")
        puts "set source language to Chinese"
      else
        puts "not found source language dropdown list"
      end

      if ie.select_list(:id,"gt-tl").exist?
        ie.select_list(:id,"gt-tl").set("English")
        puts "set target language to English"
      else
        puts "not found target language dropdown list"
      end

      if ie.text_field(:id,"source").exist?
        sleep 3
        ie.text_field(:id,"source").value=cntxt.to_s
        puts "    found source panel and set translation source"
        break
      elsif timeIE > 5
        puts "    failed load #{url},give up and exit"
        break
      else
        puts  "    not found source panel etc, reopen ie and try agin."
        ie.focus; ie.send_keys("!{F4}")
        sleep 1
        ie=Watir::Browser.new
        Cmm.launchIEwithTimeout(ie, url, 15)
      end#if ie.text_field(:id,"source").exist?

    end#while true do

    #sleep 5

    if ie.button(:value,"Translate").exist?
      ie.button(:value,"Translate").click
      puts "    found trnaslate button and clicked"
    else
      puts "    Did not found google 'Trnaslate' button"
    end

    puts "    starting translate"

    time=0
    while true do
      sleep 1
      time=time+1
      rtn=""
      puts "\n ie status is "+ie.status.to_s
      puts  " time is "+ time.to_s
      puts "ie status: " + ie.status
      if time.to_i > 10.to_i
        puts "    timeout 10s for google ajax translate result load"
        break
      elsif ie.status == "Done" or ie.status == "" or ie.status.downcase.include?("error")
        puts "    tanaslate ajax load completed"
        break
      else
        # print "waiting IE status to done"
        print "."
      end  #if time.to_i > 10.to_i

    end #while true do
    #puts "" #puts end "\n"

    time=0
    while true do
      sleep 1
      time=time+1

      if time.to_i > 30.to_i
        puts "    timeout 30s for wait ie tanaslate result_box"
        break
      end

      #suppose the result box should appeared now
      if ie.span(:id,"result_box").exist?
        rtn = ie.span(:id,"result_box").text
        rtn =  rtn.gsub(/[^[:alnum:][:punct:] ]+/,"") #sometimes gtranslate also contain DBCS,so remove them
        rtn = rtn.gsub(/\?/,"")
        puts "    tanaslate rssult_box appeared."
        if rtn==""
          next
        else
          break
        end

      else
        print time.to_s
        print " of 30,"
        puts "    translate page load completed, but not found span id is result_box"
      end #if ie.span(:id,"result_box").exist?
    end #while true do

    if ( rtn  =~  /Error:/ ).to_s == 0.to_s
      #Error: suspected terms of service abuse. please see http://code.google.com/apis/errors
      #Error: 414 Request-URI Too Large
      puts "\n    google translate error: #{rtn}"
      exit
    elsif (rtn =~ /Translating/).to_s == 0.to_s
      puts "\n    google translate not work, keeps on #{rtn}"
    else
      print "    translate finished with success,output is "
      puts rtn[0..200]+"..."
    end # if rtn.include?("Error:")

    if ie.text_field(:id,"source").exist?
      ie.text_field(:id,"source").value=""
      sleep 1
      if ie.button(:value,"Translate").exist?
        ie.button(:value,"Translate").click
        puts "    cleaned up google translate."
        sleep 1
      else
        puts "    Did not found google 'Trnaslate' button when clean up,cleanup failed"
      end

    else
      puts "    Did not found google 'source' text_field when clean up, cleanup failed."

    end

    ie.close

    rtn=rtn.gsub(/\/ /,"/") #google web translate "/*" to "/ *"

    if rtn.nil? or rtn.gsub(/\s/,"")==""
      errmsg= "google web translate got a blank return"
      puts errmsg
      raise errmsg
    end

    return rtn

  end #def Misc.googletranslatetoenWeb(cntxt)

  def Misc.cn2en(longMixTxt)
    #s="\344\270\255\345\233\275\344\270\255\345\233\275china,\344\270\255\345\233\275,china2."

    s=self.replacePunCn2En(longMixTxt.to_s)

    myarray=[]
    cnarray=[]
    cnhash={}
    cnarray_leng=[]
    enarray=[]

    #collect all the continues dbcs block, and save them as array.
    myarray=s.scan(/[^[:alnum:][:punct:] ]+/);

    myarray.each{ |x|
      if !( x=="\n" or x=="\r\n" or x=="\r" ) ;
        cnarray << x;
      end;  # if !( x=="\n" or x=="\r\n" or x=="\r" ) ;

    }    #myarray.each{ |x|

    cnarray=self.sortArrayByLength(cnarray)  #replace patter which has longer length first.
    cnarray=cnarray.reverse

    cnarraylength=cnarray.length.to_s
    puts "translation queue length is: "+cnarraylength
    #p cnarray

    #cnarray.each{ |x|   print cnarray.index(x).to_s+" of "+cnarraylength+" length: "+x.length.to_s ; enarray << self.googletranslatetoen(x).downcase }
    print "translating"
    cnarray.each{ |x| print "."; enarray << " "+self.googletranslatetoen(x).downcase+" " }
    #                    print "enarray is"
    #                    p enarray
    #                    print "cnarray is"
    #                    p cnarray
    enarray.each{ |x| i=enarray.index(x) ;  s=s.gsub(/#{cnarray[i]}/, " "+x.to_s+" ");   }
    s=s.gsub(/[^[:alnum:][:punct:] ]+/,"")
    s= s.gsub(/ +/," ")
    return s
  end #Misc.cn2en(longMixTxt)

  def Misc.replacePunCn2En(longMixTxt)
    s=longMixTxt
    s=""  if s.nil?

    s=s.gsub("?€?",".") ;
    s= s.gsub("???",",")
    s=s.gsub("?€?","<")
    s=s.gsub("?€?",">")
    s=s.gsub("???",";") ;
    s=s.gsub("???",":")
    s=s.gsub("a€?","'")
    s=s.gsub("a€?","\"")
    s=s.gsub("?€?","[")
    s=s.gsub("?€¡®","]")
    s=s.gsub("?€?","{")
    s=s.gsub("?€?","}") ;
    s=s.gsub("?€?",",")
    s=s.gsub("|","|")
    s=s.gsub("???","!")
    s=s.gsub("???","")

    s=s.gsub("???","?")
    s=s.gsub("??¡ê","-")
    s=s.gsub("a€¡±","-");
    s=s.gsub("???","<")
    s=s.gsub("???",">")
    return s

  end #def Misc.replacePunCn2En(longMixTxt)

  def Misc.sortArrayByLength(myarr)
    myarr.sort_by { |s| s.length }
  end #def Misc.sortArrayByLength(myarr)

  def Misc.send_email(smtpsrv,from, from_alias, to, to_alias, subject, message)
    msg = <<END_OF_MESSAGE
From: #{from_alias} <#{from}>
To: #{to_alias} <#{to}>
Subject: #{subject}

#{message}
END_OF_MESSAGE

    smtpsrv="192.168.160.2" if smtpsrv==""
    from="ruby@192.168.160.132" if from==""
    from_alias="ruby@192.168.160.132" if from_alias==""
    to="sunraise2005@gmail.com" if  to==""
    to_alias="ryan" if to_alias==""
    subject="subject is blank" if subject==""
    message="message is blank" if message==""

    Net::SMTP.start(smtpsrv) do |smtp|
      smtp.send_message msg, from, to
    end
  end  #def Misc.send_email(smtpsrv,from, from_alias, to, to_alias, subject, message)

  def Misc.readFileAsString(file)
    file=file.to_s
    rtn=""
    if File.exist?(file)
      File.open(file).each_line{ |s|
        rtn=rtn+s
      }
    else
      puts "warning: file not exist: "+file
    end #if File.exist?(file)

    return rtn

  end #def Misc.readfile(file)

  #search google, download img file and insert to unidb.
  def Misc.googleSearchTitleImg(myid)

    puts "google title image..."
    if self.hasTitleImg(myid).to_i > 0
      puts "title image already existed for myID #{myid}, will not processing it."
    else
      softname=Zencart.getproducts_name(myid)
      kw=softname.gsub(/\(.*\)/, "").gsub(/ /,"\+")

      url=""
      url=url+"http://www.google.com/images?as_q="
      url=url+"#{kw}"
      url=url+"&hl=en&biw=1430&bih=748&gbv=2&btnG=Google+Search&as_epq=&as_oq=&as_eq=&imgtype=&imgsz=m&imgw=&imgh=&imgar=&as_filetype=&imgc=&as_sitesearch=&as_rights=&safe=images&as_st=y"

      #url="http://www.google.com/images?hl=en&biw=1440&bih=731&gbv=2&tbs=isch%3A1&sa=1&q=hh&btnG=Search&aq=f&aqi=&aql=&oq="
      ieGI=Watir::Browser.new
      ieGI.goto(url)

      if ieGI.images.length < 1

        puts "google image search did not return enough result, img No in page is"
        #+ ie.images.length.to_s
        ieGI.close
        return
      end

      for i in 45..ieGI.links.length #check first 6 search return pictures, until download one picture (with out timeout,and size > 10k)

        is=i.to_s
        #puts i.to_s, ie.links[i].href
        if !(ieGI.links[i].href.include?("imgurl="))
          #print "link # #{is}: not found imgurl=, try next link "
          next
        end
        imglink=ieGI.links[i].href.split("imgurl=")[1].split("&imgrefurl=")[0]
        #imglink="http://"+ie.images[i].src.split("http://")[-1].to_s
        folder="image"
        indexnumberofarray="1000"  #using 1000 as a flag of title image
        #puts myid,imglink,folder,indexnumberofarray;
        fullsavepath=Cmm.saveHttpImg(myid,imglink,folder,indexnumberofarray)
        if fullsavepath.include?("dlerr:")
          puts " not download, try next pic number: " + i.to_s
          next
        else
          myid=myid.to_s
          sql2="INSERT INTO `images` ( `myID` , `imagepath`, `imgLclPth` , `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
          sql2=sql2+"VALUES ("
          sql2=sql2 + \
          myid +",'"  \
          + self.txt2Sql(imglink)+"','"  \
          + fullsavepath +"','"  \
          +"1','0','0');"
          self.dbprocess(sql2)

          break
        end  #if fullsavepath == "dlerr:imgnotdownload"

      end #for i in 2..6
      ieGI.close
    end #if self.hasTitleImg(myid).to_s == 1.to_s

  end #def Misc.googleSearchTitleImg(myid)

  def Misc.removeSoftNameHasKW(keyword)
    keyword=keyword.to_s
    if keyword.nil?
      puts "keywords for remove is nil, exit"
      return
    else
      sql="SELECT `myID`  FROM `main` WHERE `softname` LIKE '%#{keyword}%'"
      sidarry=self.dbshowArray(sql)
      sidarry.each {|x| self.deleteBySID(x) }
    end # if keyword.nil?
  end #def Misc.removeSoftNameHasKW(keyword)

  def Misc.removeSoftDescHasKWPattern(keyword_RegExpPatten)
    keyword=keyword.to_s
    if keyword.nil?
      puts "keywords for remove is nil, exit"
      return
    else
      sql="SELECT * FROM `description` WHERE `html` REGEXP '"
      sql=sql+keyword_RegExpPatten
      sql=sql+"'"
      #sql="SELECT `myID`  FROM `description` WHERE `html` LIKE '#{keyword_RegExpPatten}%'"
      p sql
      #      exit
      sidarry=self.dbshowArray(sql)
      sidarry.each {|x|

        puts x.to_s
        self.deleteBySID(x); Zencart.removeMyID(x)

      }
    end # if keyword.nil?
  end #def Misc.removeSoftDescHasKWPattern(keyword_RegExpPatten)

  def  Misc.insertUrl(newMyID,url)
    if !(url.nil? or url == "")
      self.dbprocess("insert into `url` (`myID`,`url`) values (\""+newMyID.to_s+"\",\""+self.txt2Sql(url)+"\")")
    end #if !(url.nil? or url == "")
  end #def  Misc.insertUrl(newMyID,url)

  def  Misc.insertDlPathmap(newMyID,protocol,server,port,ppath,path)

    return if newMyID.nil?;
    return if protocol.nil?;
    return if server.nil?;
    return if port.nil?;
    return if ppath.nil?;
    return if path.nil?;

    newMyID  =self.txt2Sql(newMyID.to_s.strip)
    protocol =self.txt2Sql(protocol.to_s.strip)
    server   =self.txt2Sql(server.to_s.strip)
    port     =self.txt2Sql(port.to_s.strip)
    ppath    =self.txt2Sql(ppath.to_s.strip)
    path     =self.txt2Sql(path.to_s.strip)

    return if newMyID==""
    return if protocol==""
    return if server==""
    return if port==""
    return if ppath==""
    return if path==""

    sql="INSERT INTO `dlpathmap` ( `myID` , `protocol` , `server` , `port` , `ppath` , `path`, `valid` )"
    sql=sql+"VALUES ('"
    sql=sql+newMyID
    sql=sql+"', '"
    sql=sql+protocol
    sql=sql+"', '"
    sql=sql+server
    sql=sql+"', '"
    sql=sql+port
    sql=sql+"', '"
    sql=sql+ppath
    sql=sql+"', '"
    sql=sql+path
    sql=sql+"', '"
    sql=sql+"1"
    sql=sql+"');"

    self.dbprocess(sql)
  end # def  Misc.insertDlPathmap(newMyID,protocol,server,port,ppath,path)

  def  Misc.insertMain(newMyID,site,category,softuid,softname,regDate,sizevalue,sizeunion,filecount,adddaytime)
    sqlM="INSERT INTO `main` \
( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
    sqlM=sqlM+"VALUES ("
    sqlM=sqlM + \
    self.txt2Sql(newMyID.to_s.strip) +",'"  \
    + self.txt2Sql(site.to_s.strip)+"','"  \
    + self.txt2Sql(category.to_s.strip)+"','"  \
    + self.txt2Sql(softuid.to_s.strip)+"','"  \
    + self.txt2Sql(softname.to_s.strip)+"','"  \
    + self.txt2Sql(regDate.to_s.strip)+"','"  \
    + self.txt2Sql(sizevalue.to_s.strip)+"','"   \
    + self.txt2Sql(sizeunion.to_s.strip)+"','"  \
    + self.txt2Sql(filecount.to_s.strip)+"','"   \
    + self.txt2Sql(adddaytime.to_s.strip)+"'" \
    +"); "

    if self.hasSoftName(self.txt2Sql(softname)).to_s !="0"
      puts "softname #{softname} already existed"
      return 1
    end

    self.dbprocess(sqlM)
    return 0

  end #def  Misc.insertMain(newMyID,site,category,softuid,softname,regDate,sizevalue,sizeunion,filecount,adddaytime)

  def Misc.insertDescription(newMyID,descHtm,desctxt)

    return if newMyID.nil?;

    newMyID  =self.txt2Sql(newMyID.to_s.strip)

    return if newMyID==""

    sqlD="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
    sqlD=sqlD+"VALUES ("
    sqlD=sqlD +  newMyID.to_s.strip + ",'"  \
    + self.txt2Sql(descHtm.to_s.strip)+"','"  \
    + self.txt2Sql(desctxt.to_s.strip)+"'"  \
    +"); "
    self.dbprocess(sqlD)
  end  #def Misc.insertDescription(newMyID,descHtm,desctxt)

  def  Misc.insertOneFile(newMyID, filename,filesize,sizeunion,md5)

    return if newMyID.nil?;
    return if filename.nil?;
    filesize="0" if filesize.nil?;
    sizeunion="byte" if sizeunion.nil?;
    md5="NULL" if md5.nil?

    newMyID  =self.txt2Sql(newMyID.to_s.strip)
    filename =self.txt2Sql(filename.to_s.strip)
    filesize   =self.txt2Sql(filesize.to_s.strip)
    sizeunion     =self.txt2Sql(sizeunion.to_s.strip)

    return if newMyID==""
    return if filename==""
    filesize="0" if filesize==""
    sizeunion="byte" if sizeunion==""
    md5="NULL" if md5==""

    sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5` ) VALUES ("
    sqlF=sqlF+ \
    self.txt2Sql(newMyID) +",'"  \
    + self.txt2Sql(filename)+"','"  \
    + self.txt2Sql(filesize)+"','"  \
    + self.txt2Sql(sizeunion)+"','"  \
    + self.txt2Sql(md5)+"'" \
    +"); "
    self.dbprocess(sqlF)
  end  #def  Misc.insertOneFile(newMyID, filename,filesize,sizeunion,md5)

  def Misc.executeSqls(sqlarr)
    sqlarr.each{|sql|
      #sql=self.txt2Sql(sql).to_s
      self.dbprocess(sql) if  !(sql.nil? or sql=="" )

    } #sqlarr.each{|sql|
  end #def Misc.executeSqls(sqlarr)

  def Misc.getTitleImage(myid)
    if self.hasTitleImg(myid).to_s == "0"
      puts "no title image for myID #{myid} in unidb"
      return
    end

    sql="SELECT `imgLclPth` FROM `images` WHERE `myID`=#{myid} and `titleimage`=1"
    productTitleImage=Misc.dbshowArrayCommon("unidb",sql)
    return productTitleImage[0]
  end

  def Misc.close_all_windows
    loop do
      begin
        Watir::Browser.attach(:title, //).close
      rescue Watir::Exception::NoMatchingWindowFoundException
        break
      rescue
        retry
      end
    end
  end  #def Misc.close_all_windows

  def Misc.removeOneLineFromFile(file,line)

    if line.nil?
      puts "replace line is nil, return"
      return
    end

    if !File.exist?(file)
      puts "#{file} not exist,return"
      return
    end

    oldfile=file
    newfile=file+".new"

    File.delete(newfile) if File.exists?(newfile)

    fhold = File.open(oldfile)
    fhnew = File.open(newfile,"w+")

    fhold.each {|lineold|
      # print lineold.chop
      if lineold.chop==line
        puts "remove #{line} from #{oldfile}"
      else
        fhnew.puts(lineold)
      end

    }

    fhnew.close; fhold.chmod(0777); fhold.close;

    File.delete(oldfile)
    File.rename(newfile,oldfile)

  end #def Misc.removeOneLineFromFile(file,line)

  def Misc.save_httpFile(filepath)
    prompt_message = "Do you want to open or save this file?"
    window_title = "File Download"
    save_dialog = WIN32OLE.new("AutoItX3.Control")
    sleep 1
    save_dialog_obtained = save_dialog.WinWaitActive(window_title,prompt_message, 25)
    save_dialog.ControlFocus(window_title, prompt_message, "&Save")
    sleep 1

    #save_dialog.Send("S")
    save_dialog.ControlClick(window_title, prompt_message, "&Save")
    puts "\tclicked SAVE btn"
    #save_dialog.WinSetTitle(window_title, prompt_message, "This is ForTesting" )
    saveas_dialog_obtained = save_dialog.WinWait("Save As", "Save&in", 5)
    sleep 1
    puts "\tshould see SAVE AS WINDOW"
    path = filepath
    #path = File.dirname(__FILE__).gsub("/" , "\\" )+ "\\" + fileName
    save_dialog.ControlSend("Save As", "", "Edit1",path)
    sleep 1
    puts "\tshould set save as FIlE PATH"

    File.delete(filepath) if File.exist?(filepath)

    save_dialog.ControlClick("Save As", "Save &in", "&Save")
    puts "\tclicked SAVE AS BUTTON"
    #save_fileAlreadyExists = save_dialog.WinWait("Save As", " ", 5)
    save_dialog.ControlClick("Download complete", "", "Close")
    puts "\tclicked CLOSE btn"

  end  #def Misc.save_httpFile(filepath)

  def Misc.isLive?(url)
    passList=["301","200"]

    begin
      uri = URI.parse(url)
      response = nil
      Net::HTTP.start(uri.host, uri.port) { |http|
        response = http.head(uri.path.size > 0 ? uri.path : "/")
      }
      rspC=response.code
    rescue
      puts "EXCEPTION when process #{url}"
      rspC=""
    end

    rtn= passList.include?(rspC)

    return [rtn,rspC]
  end # def Misc.isLive?(url)

  #rst=1: the link is working.
  #rst=0: the link is broken.
  def Misc.updatetValRst(myID,rst)
    myID=myID.to_s
    rst=rst.to_s
    sqlUp="UPDATE dlpathmap SET valid = \'"
    sqlUp=sqlUp+rst
    sqlUp=sqlUp+"\' WHERE myID =#{myID}"
    self.dbprocess(sqlUp)
  end #def Misc.updatetValRst(myID,rst)

  def Misc.validate(startID)
    dbh = DBI.connect('DBI:ODBC:unidb','root','')

    sql="SELECT a.myID, b.site, a.protocol,a.server,a.port,a.ppath,a.path  "
    sql=sql+" FROM dlpathmap a, main b "
    sql=sql+" WHERE a.myID = b.myID"
    sql=sql+" AND a.myID >= "
    sql=sql+startID.to_s

    sth = dbh.prepare(sql)
    sth.execute

    # Print out each row
    while row=sth.fetch do
      h = Hash.new
      h = row.to_h

      url=h["protocol"] + "://" +h["server"]+":"+h["port"]+"/"+h["ppath"]+"/"+h["path"]
      myArr=self.isLive?(url)
      valdrst=myArr[0]
      rspC=myArr[1]
      rst = valdrst ? 1 : 0

      print "\n #{valdrst},rspC: #{rspC}"
      print ", myID:"+ h["myID"].to_s+", "
      puts url

      self.updatetValRst(h["myID"],rst)

    end #def validate

    # Close the statement handle when done
    sth.finish
  end #def Misc.validate

  def Misc.validateBitme(startID)

    sql="SELECT `myID`  "
    sql=sql+" FROM `main`  "
    sql=sql+" WHERE `site` = \"bitme\""
    sql=sql+" AND `myID` >= "
    sql=sql+startID.to_s

    arrMyIDBitmeUnidb=[]
    arrMyIDBitmeUnidb=self.dbshowArray(sql)

    arrMyIDBitmeUnidb.each{|myid|
      puts "\n\n== validating myid #{myid} ==="
      bitmeid= self.getSoftuid(myid)

      puts "--checking if bitme.org still host this item"
      if Bitme.isPageLivedinBitme(bitmeid)
        puts "myID #{myid},bitmeId #{bitmeid} still hosted in bitme.org"

        puts "--checking if torrent file downloaded to local c/wamp/www/torrents/bitme/"
        if Bitme.isBitmeTorrentSaved(bitmeid) != false
          torrentName=Bitme.getSavedBitmeTorrentFilename(bitmeid)
          puts "torrent file is saved in local,filename #{torrentName}"
          puts "--checking if unidb.dlpathmap has the record"
          #if  Bitme.isBitmeTorrentSavedToDlpathmapTbl(bitmeid)
          #   puts "the torrent was saved in unidb.dlpathmap"
          #else #Bitme.isBitmeTorrentSavedToDlpathmapTbl(bitmeid) #coment this line, force update dlpathmap even it has records.
          puts "--updating unidb.dlpathmap table"
          myid=Misc.getMyidBySoftuid("bitme",bitmeid)
          protocol="http"
          server="localhost"
          port="80"
          ppath="torrents"
          path="bitme/#{torrentName}"
          Zencart.updateOrAddDlpathmap(myid,protocol,server,port,ppath,path)
          #end #Bitme.isBitmeTorrentSavedToDlpathmapTbl(bitmeid)
        else #if Bitme.isBitmeTorrentSaved(bitmeid)
          Bitme.saveTorrentWget(bitmeid)
        end #if Bitme.isBitmeTorrentSaved(bitmeid)

      else#if Bitme.isPageLivedinBitme(bitmeid)
        puts "myID #{myid},bitmeId #{bitmeid} no longer hosted in bitme.org"

        puts "remove myID #{myid} from unidb"
        self.deleteBySID(myid)

        puts "remove bitmeId #{bitmeid} from zencart.bitme db"
        Zencart.removeMyID("zencart.bitme",myid)
      end # if Bitme.isPageLivedinBitme(bitmeId)

    } #arrMyIDBitmeUnidb.each{|myid|

  end #def Misc.validateBitme

  def Misc.getSoftuid(myid)
    myid=self.txt2Sql(myid.to_s)
    sql="select  `softuid` \
       FROM `main` \
       WHERE `myID` =  "
    sql= sql+ "\""+  myid +"\""
    sql=sql+";"
    #puts sql
    self.dbshow(sql)
  end #def Misc.getSoftuid(myid)

  def Misc.getMyidBySoftuid(site,softuid)
    site=self.txt2Sql(site.to_s)
    softuid=self.txt2Sql(softuid.to_s)
    sql="SELECT `myID` FROM `main` WHERE `site`= \"#{site}\" and `softuid`=\"#{softuid}\""
    self.dbshow(sql)
  end #def Misc.getMyidBySoftuid(site,softuid)

  #####################################
end #end of whole module