module Netfirms   
require 'DBI'
require "misc"




def Netfirms.dbprocess_wp_files24x7(sql)
  #puts sql
  dbh_netfirm=DBI.connect('DBI:ODBC:netfirms_wp_files24x7','u70727560','@Ap3#ple') 
  dbh_netfirm.do(sql) 
  dbh_netfirm.disconnect if dbh_netfirm  
end 





def Netfirms.dbprocess_myvpsoft(sql)
  #puts sql
  dbh_netfirm=DBI.connect('DBI:ODBC:netfirms_wp_myvpsoft','u70415274','@Ap3#ple') 
  dbh_netfirm.do(sql) 
  dbh_netfirm.disconnect if dbh_netfirm  
end 



def Netfirms.update_wp_files24x7()  
  file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_wp29"  
  sql=Misc.readFileAsString("file")
  self.dbprocess_wp_files24x7(sql)
  File.delete(file)
end



def Netfirms.update_myvpsoft()
  file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_osc20090708"  
  sql=Misc.readFileAsString("file")
  self.dbprocess_myvpsoft(sql)  
  File.delete(file)
end



def Netfirms.dbshowWholeArray(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  #puts selectsql
  resultarr=[]
  dbh = DBI.connect('DBI:ODBC:netfirms_wp_myvpsoft','u70415274','@Ap3#ple') 
  sth = dbh.prepare(selectsql)
  sth.execute
     while row=sth.fetch do
        #p row
        resultarr << row
        #p resultarr
  end
  dbh.disconnect if dbh
  return resultarr
end#def Netfirms.dbshowWholeArray(selectsql)





end #module Netfirms