
module Stock
  load "misc.rb"
  require 'date'
  
  def Stock.getResult(tsName,rstHash,rstHash2) #rstHash for appear count, rstHash2 store content. 
    rstHash=rstHash
    rstHash2=rstHash2
    tsname=tsName
    fileBase="c:/stock/eval/#{tsname}_eval_last.txt"
    fileBuy="C:/stock/buy/#{tsname}_buy_last.txt"
    fileResult="c:/stock/result/#{tsname}_result.txt"
    
    
    fhResult=File.new(fileResult, "w+")
    fhResult.rewind
    
    
    fhBuyContent=""
    fhBuy = File.open(fileBuy)
    fhBuy.each{|line| fhBuyContent=fhBuyContent+line}
    fhBuy.close
    
    fhBase = File.open(fileBase)
    fhBase.each {|line| 
      code=line.split[1]
      tsSuccessRate=line.split[7]
      tsProfitRate=line.split[6]
      if fhBuyContent.include?(code) and tsSuccessRate.to_i > 85 and tsProfitRate.to_i > 5 #THE KEYPOINT FOR SELECTION
        fhResult.puts("buy #{line}")
        stockDetail=self.grep(fileBuy,code)
        if rstHash.keys.include?(code)
          rstHash[code]=rstHash[code].to_i+1
          rstHash2[code]=rstHash2[code]+"\n"+"\t"+line.strip+"\t"+tsname.strip
        else
          rstHash[code]= 1
          rstHash2[code]="\t"+self.getTitleLine(fileBuy).strip
          rstHash2[code]=rstHash2[code]+"\n"+"\t"+stockDetail
          rstHash2[code]=rstHash2[code]+""+"\t"+self.getTitleLine(fileBase).strip
          rstHash2[code]=rstHash2[code]+"\n"+"\t"+line.strip+"\t"+tsname.strip
        end
        
        puts code
      end    
    }
    
    fhBase.close
    fhResult.close
    
    return [rstHash,rstHash2]
    
  end #def Stock.getResult  
  
  
  def Stock.grep(file,keyword)
    rtn=""
    fh = File.open(file)
    fh.each{|line| 
      if line.include?(keyword)
        rtn=rtn+line
      end
    }
    fh.close
    
    return rtn
  end #def Stock.grep
  
  
  def Stock.getTitleLine(file)
    rtn=""
    fh = File.open(file)
    rtn=fh.readline
    fh.close
    
    return rtn
  end #def Stock.getTitleLine
  
  
  
  
  def Stock.getHash(fileAllResult)
    rtnHash={}
    fhAllResult = File.open(fileAllResult)
    fhAllResult.each{|line| 
      
      if line.nil?
        next
      end
      
      if line.include?("=>")
        tmp=[]
        tmp=line.split("=>")
        stockcode=tmp[0].strip
        appeartime=tmp[1].strip
        
        #puts "#{stockcode} #{appeartime}"      
        rtnHash[stockcode]=appeartime
        next
      end
      
    }
    
    
    fhAllResult.close
    return rtnHash
    
  end #def Stock.getHash(fhAllResult)
  
  
  
  def Stock.getSummary(date,fileSum,stockcode,appeartime,fileIn)
    fhSum=File.open(fileSum)
    fhIn=File.open(fileIn,"a+")
    
    fhSum.each{|line|
      #puts line
      if line.include?(stockcode) and line.split(/\t/).length==11
        tsname=line.split(/\t/)[-1].strip
        str="#{date},buy,#{stockcode},#{appeartime},#{tsname}"
        fhIn.puts(str)
      end
    } #fhSum.each{|line|s
    
    fhSum.close
    fhIn.close
    
  end # Stock.getSummary
  
  
  
  
  def Stock.getStockInfo(code)
    filesh="c:/stock/dapanhistory/sh_last.txt"
    filesz="c:/stock/dapanhistory/sz_last.txt"
    #code="600000"
   
    if (code=~/^6/) == 0
      file=filesh
      fcode="SH#{code}"
    end
    
    if (code=~/^0/) == 0
      file=filesz
      fcode="SZ#{code}"
    end
    
    if (code=~/^3/) == 0
      file=filesz
      fcode="SZ#{code}"
    hash={}
 # :todo add code start with 3  
    hash["stockCode"]=code
    hash["stockName"]="STOCKTMP"
    hash["ths_pingJi"]="1"
    hash["currentPrice"]="1"
    hash["meigujinzichan"]="1"
    
    
    
    return hash
    end    
    
    
    
    line=self.grep(file,fcode)
    
    tmp=line.split
    hash={}
    
    hash["stockCode"]=code
    hash["stockName"]=tmp[1]
    hash["ths_pingJi"]=tmp[2]
    hash["currentPrice"]=tmp[5]
    hash["meigujinzichan"]=tmp[17]
    
    
    
    return hash
  end #def Stock.getStockInfo(code)
  
  
  
  def Stock.inSertDB_makeInputFile()
    date=Misc.datenow3
    fileAllResult="c:/stock/result/OVERALL_result.txt"
    fileAllResultIn="c:/stock/result/OVERALL_result_"+date+".in"
    fileAllResultInToday="c:/stock/result/OVERALL_result.in"

    FileUtils.rm(fileAllResultIn) if File.exist?(fileAllResultIn)
    fhAllResultIn=File.new(fileAllResultIn,"a+")
    
    rtnHash={}
    rtnHash=self.getHash(fileAllResult)
    
    
    rtnHash.each{|stockcode,appeartime|
      self.getSummary(date,fileAllResult,stockcode,appeartime,fileAllResultIn)
      
    }
    
    print "\n    analyze OVERALL_result.txt finished."
    
    #ryan commented in 2011/03/02,  qq zhulizengcang not suitable as a trading system. 
    #self.qqZhuLiZenCang_Entrance(fileAllResultIn)
    #print "\n    analyze QQ Finance finished."
    
    FileUtils.cp fileAllResultIn, fileAllResultInToday
    
    return fileAllResultInToday
  end #def Stock.inSertDB_makeInputFile()
  
  
  
  
  
  def Stock.getMaxholdid(odbc)
    sql="SELECT MAX(holdid) FROM hold_statistic WHERE 1"
    a=Misc.dbshowCommon(odbc,sql)  
    a="0" if a.nil?
    a="0" if a==""
    return a
  end #def Stock.getMaxMyid(odbc)            
  
  def Stock.resetBuyPoint(odbc)
    sql="UPDATE `hold_statistic` SET `buypoint` = \'0\'  WHERE  1 ;"
    Misc.dbprocessCommon(odbc, sql)   
  end #def Stock.resetBuyPoint()
  
  def Stock.resetSellPoint(odbc)
    sql="UPDATE `hold_statistic` SET `sellpoint` = \'0\' WHERE  1 ;"
    Misc.dbprocessCommon(odbc, sql)
  end #def Stock.resetSellPoint()
  
  def Stock.resetLastscanForHoldid(odbc,holdid)
    holdid=holdid.to_s
    sql="UPDATE `hold_dynamic` SET `islastscan` = \'0\'  WHERE  holdid=#{holdid}"
    Misc.dbprocessCommon(odbc, sql)
  end #def Stock.resetLastscanForHoldid(odbc,holdid)
  
  def Stock.isHoldidTxnFinished(odbc,holdid)
    holdid=holdid.to_s
    sql="SELECT `outdate` FROM `hold_statistic` WHERE `holdid`=#{holdid} ;"
   
   stat=Misc.dbshowCommon(odbc, sql)
   #puts "stat=#{stat}" 
    if stat==""
      rtn=false
    else
      rtn=true
    end

    return rtn
  end #def Stock.resetSellPoint()

  
  def Stock.insertDB_insertTodaySuggestion2HoldstaticTable(odbc,dbFileIN)
    self.resetBuyPoint(odbc)
    fhdbFileIN=File.open(dbFileIN)
    
    fhdbFileIN.each{|line|
      
      tmpArr=line.strip.split(",")
      date=tmpArr[0]
      buyOrSell=tmpArr[1]
      stockId=tmpArr[2]
      suggestWeight=tmpArr[3]
      suggestTSname=tmpArr[4]
      
      tmpHashStockInfo=Stock.getStockInfo(stockId)
      
      holdid=(self.getMaxholdid(odbc).to_i+1).to_s
      suggestweight=suggestWeight
      holdtype="test"
      stockid=stockId
      stockname=tmpHashStockInfo["stockName"]
      accordingtsname=suggestTSname
      inprice=tmpHashStockInfo["currentPrice"]
      indate=(Date.strptime(date)+1).to_s
      ammount="100"
      outprice="NULL"
      outdate="NULL"
      soldreason="NULL"
      buypoint="1"
      sellpoint="0"
      
      sql="INSERT INTO `hold_statistic` (`holdid`, `suggestweight`, `holdtype`, `stockid`, `stockname`, `accordingtsname`, `inprice`, `indate`, `ammount`, `outprice`, `outdate`,`soldreason`,`buypoint`,`sellpoint`) VALUES ('"
      sql=sql+holdid+"\', \'"
      sql=sql+suggestweight+"\', \'"
      sql=sql+holdtype+"\', \'"
      sql=sql+stockid+"\', \'"
      sql=sql+stockname+"\', \'"
      sql=sql+accordingtsname+"\', \'"
      sql=sql+inprice+"\', \'"
      sql=sql+indate+"\', \'"
      sql=sql+ammount+"\', "
      sql=sql+outprice+", "
      sql=sql+outdate+", "
      sql=sql+soldreason+", "
      sql=sql+buypoint+", "
      sql=sql+sellpoint+")"
      
      #puts sql
      
      dbcount= self.hasHoldStatisticEntry(odbc,indate,stockid,accordingtsname )
      
      
      if inprice.to_i == 0
         puts " #{stockid} #{stockname} be suggested but inprice is 0, can not buy. "
      elsif dbcount.to_i == 0
         Misc.dbprocessCommon(odbc, sql)
         puts "bought #{stockid} #{stockname}"
      end
      
    } #fhdbFileIN.each{|line|
    
  end #def Stock.insertDB_insertTodaySuggestion2HoldstaticTable(odbc,dbFileIN)                 
  
  
  
  
  def Stock.hasHoldStatisticEntry(odbc,indate,stockid,accordingtsname )
    
    sql="SELECT count( * ) \
      FROM `hold_statistic` \
      WHERE `indate` =\""    
    sql=sql+indate.to_s+"\" and stockid=\""
    sql=sql+stockid.to_s+"\" and accordingtsname=\""
    sql=sql+accordingtsname+"\""    
    #    puts sql      
    Misc.dbshowCommon(odbc,sql)
    end#=def Stock.hasHoldStatisticEntry(odbc,indate,stockid,accordingtsname )
    
    
    
    def Stock.hasHoldDynamicEntry(odbc,checkdate,holdid)
      
      sql="SELECT count( * ) \
      FROM `hold_dynamic` \
      WHERE `checkdate` =\""    
      sql=sql+checkdate.to_s+"\" and holdid=\""
      sql=sql+holdid.to_s+"\""   
      #    puts sql      
      Misc.dbshowCommon(odbc,sql)
      end#=def Stock.hasHoldDynamicEntry 
      
      
      
      
      
      
      def Stock.getHoldstatistic(odbc,holdid,tablefield)
        holdid=Misc.txt2Sql(holdid)
        sql="SELECT `#{tablefield}` FROM `hold_statistic` WHERE `holdid`= '" 
        sql=sql+holdid+"'"  
        Misc.dbshowCommon(odbc,sql)        
      end # def Stock.getHoldstatistic(odbc,holdid,tablefield)
      
      
      
      def Stock.getHolddynamic(odbc,holdid,tablefield,holdhours)
        holdid=Misc.txt2Sql(holdid)
        sql="SELECT `#{tablefield}` FROM `hold_dynamic` WHERE `holdid`= \'#{holdid}\' and `holdedhour`=\'#{holdhours}\'" 
        Misc.dbshowCommon(odbc,sql)        
      end # def Stock.getHolddynamic(odbc,holdid,tablefield)      
      
      
      def Stock.getTradingsystem(odbc,tsnameid,tablefield)
        holdid=Misc.txt2Sql(holdid)
        sql="SELECT `#{tablefield}` FROM `tradingsystem` WHERE `tsnameid`= '" 
        sql=sql+tsnameid+"'"  
        
        
        Misc.dbshowCommon(odbc,sql)        
      end # def Stock.getHolddynamic(odbc,holdid,tablefield)      
    
      
      def Stock.getMaxScanID(odbc,holdid)
        sql="SELECT max(`scan`) FROM `hold_dynamic` WHERE `holdid`=#{holdid}"
        rtn=Misc.dbshowCommon(odbc,sql)
        if rtn==""
          rtn=0
        end
        return rtn
      end #def Stock.getScanID(holdid)
      
      def Stock.insertDB_insertTodayActualSituation2HoldDynamicTableOneHoldid(odbc,holdid)
        
        checkdateStr=Misc.datenow3
        checkdate=Date.parse(checkdateStr)
        
        holdid=holdid.to_s
        scan=self.getMaxScanID(odbc,holdid).to_i+1
        stockid=self.getHoldstatistic(odbc,holdid,"stockid")
        inprice= self.getHoldstatistic(odbc,holdid,"inprice").to_f
        indate=self.getHoldstatistic(odbc,holdid,"indate")
        amount= self.getHoldstatistic(odbc,holdid,"ammount").to_f
        
        
        indate=Date.parse(indate)
        
        passedday=(checkdate-indate).to_i+1
        holdedhour=(passedday*4).to_s #4 tqrading hours per day
        
        hash=self.getStockInfo(stockid) 
        thsrate=hash["ths_pingJi"]
        currentPrice=hash["currentPrice"].to_f
        
        
        
         if inprice.to_i == 0
           puts "\nholdid #{holdid} Inprice is 0, not update this scan to dynamic table"
           return 
         end
         
         if currentPrice.to_i == 0 
           puts "\nholdid #{holdid} currentPrice is 0, not update this scan to dynamic table"
           return
         end
        
        
        
        meigujinzichan=hash["meigujinzichan"]
        if meigujinzichan == "--"
          meigujinzichanV="NULL" 
        else
          meigujinzichanV=((meigujinzichan.to_f/currentPrice)*100)
          meigujinzichanV=meigujinzichanV.round(2) 
        end
        
 
        profitrate=(currentPrice-inprice)/inprice*(100.to_f)-0.75
        profitammount=(currentPrice-inprice)*amount*(1-0.0075)
 


      
      
        
        
        
        self.resetLastscanForHoldid(odbc,holdid)
        islastscan="1"
        
        sql="INSERT INTO `hold_dynamic` (`holdid`, `scan`, `checkdate`, `holdedhour`, `checkprice`, `profitrate`, `profitammount`, `thsrate`, `meigujinzichanx100`, `islastscan`) VALUES ('"
        sql=sql+holdid.to_s+"\', \'"
        sql=sql+scan.to_s+"\', \'"
        sql=sql+checkdateStr.to_s+"\', \'"
        sql=sql+holdedhour.to_s+"\', \'"
        sql=sql+currentPrice.to_s+"\', \'"
        sql=sql+profitrate.to_s+"\', \'"
        sql=sql+profitammount.to_s+"\', \'"
        sql=sql+thsrate.to_s+"\', \'"
        sql=sql+meigujinzichanV.to_s+"\', \'"
        sql=sql+islastscan.to_s+"\' )"
               
        
        
        dbcount= self.hasHoldDynamicEntry(odbc,checkdateStr,holdid )
        
        
        Misc.dbprocessCommon(odbc, sql) if dbcount.to_i == 0
        
      end #def Stock.insertDB_insertTodayActualSituation2HoldDynamicTableOneHoldid(odbc,holdid)
      
      def Stock.getHoldStockArray(odbc)
        selectsql="SELECT `holdid` FROM `hold_statistic` WHERE `outprice` IS NULL"
        holdarray=Misc.dbshowMultiArrayCommon(odbc,selectsql)
        return holdarray
      end #def Stock.getHoldStockArray(odbc)
      
      def Stock.insertDB_insertTodayActualSituation2HoldDynamicTable(odbc)
        holdarray=self.getHoldStockArray(odbc)
        holdarray.each {|x| self.insertDB_insertTodayActualSituation2HoldDynamicTableOneHoldid(odbc,x)
        }    
      end #def Stock.insertDB_insertTodayActualSituation2HoldDynamicTable(odbc)
      
      
      def Stock.initTradingsystemTable(odbc)
        a=[]
        a<<"J01_MACD"
        a<<"J02_BuLinDai"
        a<<"J03_QuXiangZhiBiao"
        a<<"J04_GuaiLiXiTong"
        a<<"J05_KDJXiTong"
        a<<"J07_RongLiangBiLvXiTong"
        a<<"J08_WeiLianXiTong"
        a<<"J09_PaoWuZhuanXiangXiTong"
        a<<"J10_JunXianXiTong"
        a<<"J11_SuiJiZhiBiaoZhuanJia"
        a<<"J12_QuShiZhiBiao"
        a<<"J15_DongLianXian"
        a<<"J16_XinLiXian"
        a<<"J17_BianDongSuLv"
        a<<"J18_XiangDuiQiangRuoZhiBiao"
        a<<"J19_qqZhuLiZengCang"
        a<<"J20_qqZhuLiZengCang5Day"
        
        a.each{|tsname|
          sql="INSERT INTO `stock`.`tradingsystem` (`tsnameid`, `stopwin`, `stoplost`, `maxholdhour`, `tssuccessrate`) VALUES ('#{tsname}', '10', '5', '32', '0');"
          Misc.dbprocessCommon(odbc, sql) 
        }
      end #def Stock.initTradingsystemTable  
      
      
      def Stock.soldStock(odbc) 
        
        soldfile="c:/stock/sold.txt"
        FileUtils.rm(soldfile) if File.exist?(soldfile)
        fhsoldfile=File.open(soldfile,"a+")        

        self.resetSellPoint(odbc)
        holdarray=self.getHoldStockArray(odbc)
        holdarray.each{|holdid|   
          
          sql="SELECT max(`holdedhour`) FROM `hold_dynamic` WHERE `holdid`=#{holdid}"
          maxholdedhour=Misc.dbshowCommon(odbc,sql)
          profitrate=self.getHolddynamic(odbc,holdid,"profitrate",maxholdedhour)
          tsnameid=self.getHoldstatistic(odbc,holdid,"accordingtsname")
          soldprice=self.getHolddynamic(odbc,holdid,"checkprice",maxholdedhour)
          
          if maxholdedhour.to_i >  (self.getTradingsystem(odbc,tsnameid,"maxholdhour")).to_i
            msg= "holdid #{holdid} sold as MAXHOUR Reached, holded hours:"+maxholdedhour.to_s
            puts msg
            fhsoldfile.puts(msg)
            soldreason= "MAXHOUR<"+maxholdedhour.to_s
            self.updateHoldstaticTable2Sold(odbc,holdid,soldprice,soldreason)
            
          end      
          
          if profitrate.to_f >  self.getTradingsystem(odbc,tsnameid,"stopwin").to_f
            msg= "holdid #{holdid} sold as STOPWIN Reached, profit:"+profitrate.to_s
            puts msg
            fhsoldfile.puts(msg)
            soldreason= "STOPWIN, profit:"+profitrate.to_s
            self.updateHoldstaticTable2Sold(odbc,holdid,soldprice,soldreason)
            
          end     
          
          
          if profitrate.to_f < self.getTradingsystem(odbc,tsnameid,"stoplost").to_f
             msg="holdid #{holdid} sold as STOPLOST Reached, profit:"+profitrate.to_s
             puts msg
            fhsoldfile.puts(msg)
            soldreason= "STOPLOST, profit:"+profitrate.to_s
            self.updateHoldstaticTable2Sold(odbc,holdid,soldprice,soldreason)
          end
          
        }#holdarray.each{|holdid| 

      fhsoldfile.close
        
      end  #def Stock.soldStock(odbc,holdid) 
      
      
      def Stock.updateHoldstaticTable2Sold(odbc,holdid,soldprice,soldreason)
        today=Misc.datenow3
        today=Date.strptime(today)
        solddate=(today+1).to_s
        sql="UPDATE  `hold_statistic` SET `outprice` = \'#{soldprice}\',`outdate` = \'#{solddate}\',`soldreason` = \'#{soldreason}\',`sellpoint`=\"1\" WHERE `holdid` =#{holdid}  ;"
        Misc.dbprocessCommon(odbc, sql)
      end #def Stock.updateHoldstaticTable2Sold(odbc,holdid,soldreason)
      
 
    def Stock.qqZhuLiZenCang_Entrance(inFile)
       link="http://finance.qq.com/stock/sother/zldx.htm"
       ie=Watir::Browser.new
       ie.goto(link)
       
       self.qqZhuLiZengCang(ie,inFile)
       #self.qqZhuLiZengCang5Day(ie,inFile) #5day is much duplicate
       ie.close
    end #Stock.qqZhuLiZenCang_Entrance(inFile)
      
     def Stock.qqZhuLiZengCang(ie,inFile)
       #parse qq zhulidadan page and insert to DB hold_statistic table
       today=Misc.datenow3
       ie.span(:id,"s0").click
       #inFile="c:/stock/result/OVERALL_result_qqZhuLiZengCang_#{today}.in"
       dTable=ie.div(:id,"dData").table(:class,"list")
       dTable.rows.each{|r|
       stockId=r.link(:index,1).href.split("/")[-1].gsub(".shtml","")
       str="#{today},buy,#{stockId},1,J19_qqZhuLiZengCang"
       Misc.saveTxt2File(str,inFile)
       } #dTable.rows.each{|r|
       #self.insertDB_insertTodaySuggestion2HoldstaticTable("stock",inFile)
     end  #def Stock.qqZhuLiZengCang(ie)
     
     
     def Stock.qqZhuLiZengCang5Day(ie,inFile)
       today=Misc.datenow3
       #parse qq zhulidadan5days page and insert to DB hold_statistic table
       ie.span(:id,"s2").click
       #inFile="c:/stock/result/OVERALL_result_qqZhuLiZengCang5Day_#{today}.in"
       dTable=ie.div(:id,"dData").table(:class,"list")
       dTable.rows.each{|r|
       stockId=r.link(:index,1).href.split("/")[-1].gsub(".shtml","")
       str="#{today},buy,#{stockId},1,J20_qqZhuLiZengCang5Day"
       Misc.saveTxt2File(str,inFile)
         
       } #dTable.rows.each{|r|
       #self.insertDB_insertTodaySuggestion2HoldstaticTable("stock",inFile)
     end  #def Stock.qqZhuLiZengCang5Day(ie)
    
      
    end #end of the module Stock