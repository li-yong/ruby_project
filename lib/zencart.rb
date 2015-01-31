# This lib file used when "import contents from unidb to zencart"

module Zencart
  require "misc"
  require "iv"
  require "cmm"
  require "cmm2"
  include FileUtils
  
  
  
  def Zencart.cat2OscCatNum(site,sitecatname)
    site=site.to_s.downcase
    if site == "gfxnews"
      return self.gfxnewsCat2OscCat(sitecatname)
    elsif site == "9iv"
      return self.jivCat2OscCat(sitecatname)
      
    elsif site == "bitme"
      return self.bitmeCat2OscCat(sitecatname)
      
    elsif site == "verycd"
      return self.verycdCat2OscCat(sitecatname)
      
    else 
      return "23" ##23 is others cat in OSC
    end # if site == "gfxnews"
  end #def Zencart.cat2OscCatNum(site,sitecatname)
  
  
  
  def Zencart.verycdCat2OscCat(verycdcatname)
    verycdcatname=verycdcatname.to_s.downcase
    h = Hash.new("23") #23 is others cat in OSC
    h["OS".downcase] = 48.to_s #OS
    h["Internet".downcase] = 49.to_s #Internet
    h["Utility".downcase] = 50.to_s   #Utilities
    h["MutliMedia".downcase] = 51.to_s  #MutliMedia
    h["Productivity".downcase] = 52.to_s  #Business
    h["Program".downcase] = 53.to_s   #Developer Tools 
    h["Security".downcase] = 54.to_s  #Security
    h["App".downcase] = 30.to_s  #App   
    return h[verycdcatname]
  end #def Zencart.verycdCat2OscCat(bitmecatname)
  
  
  def Zencart.gfxnewsCat2OscCat(gfxnewscatname)
    gfxnewscatname=gfxnewscatname.to_s.downcase
    h = Hash.new("23") #23 is others cat in OSC
    h["TUTORIALS".downcase] = 21.to_s
    h["art"] = 22.to_s 
    return h[gfxnewscatname]
  end #def Zencart.gfxnewsCat2OscCat(gfxnewscatname)
  
  def Zencart.jivCat2OscCat(jivcatname)
    jivcatname=jivcatname.to_s.downcase
    h = Hash.new("23") #23 is others cat in OSC
    h["TUTORIALS".downcase] = 21.to_s
    h["art"] = 22.to_s 
    
    return h[jivcatname]
  end #def Zencart.jivCat2OscCat(gfxnewscatname)
  
  
  
  def Zencart.bitmeCat2OscCat(bitmecatname)
    bitmecatname=bitmecatname.to_s.downcase
    h = Hash.new("23") #23 is others cat in OSC
    h["TUTORIALS".downcase] = 21.to_s
    h["art"] = 22.to_s 
    return h[bitmecatname]
  end #def Zencart.bitmeCat2OscCat(bitmecatname)
  
  
  
  
  
  
  
  
  
  
   
  

    
    
    def Zencart.hasProductName(odbc,productname)
      productname=Misc.txt2Sql(productname.to_s) 
      sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ="
      sql=sql+productname.to_s
      #puts sql
      
      Misc.dbshowCommon(odbc,sql)
      end#=def Zencart.ifproductnameExist(productname)
      

      
      
      def Zencart.getCategory_name(odbc,category_id)
        optionValueName=Misc.txt2Sql(category_id)
        sql="SELECT `categories_name`  \
          FROM `categories_description` WHERE `categories_id` = '" 
        sql=sql+category_id+"'"  
        Misc.dbshowCommon(odbc,sql)        
      end      
      
      
      
      
      
      def Zencart.getProducts_options_values_id(odbc,optionValueName)
        optionValueName=Misc.txt2Sql(optionValueName)
        sql="SELECT `products_options_values_id`  \
          FROM `products_options_values` WHERE `products_options_values_name` = '" 
        sql=sql+optionValueName+"'"  
        Misc.dbshowCommon(odbc,sql)
        
      end
      
      
      def Zencart.getProducts_options_id(odbc,optionName)
        optionName=Misc.txt2Sql(optionName)
        sql="SELECT `products_options_id` FROM `products_options` WHERE `products_options_name` = '"+optionName+"'"
        Misc.dbshowCommon(odbc,sql)
      end
      
      
      
      
      #return 0 if no id find
      def Zencart.hasId(odbc,id)
        id=Misc.txt2Sql(id.to_s) 
        sql="SELECT count( * ) \
      FROM `products` \
      WHERE `products_id` ="
        sql=sql+id.to_s
        #puts sql
        
        Misc.dbshowCommon(odbc,sql)
        end#def Zencart.hasId(id)
        
        
        def Zencart.hasmyID(odbc,myid)
          id=Misc.txt2Sql(id.to_s) 
          sql="SELECT count( * ) \
      FROM `products` \
      WHERE `myID` ="
          sql=sql+myid.to_s
          #puts sql
          
          Misc.dbshowCommon(odbc,sql)
          end#def Zencart.hasmyID(odbc,id)
          
          
          
          #return 0 if no softname find
          def Zencart.hasSoftname(odbc,softname)
            sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ="
            sql=sql+"'"+Misc.txt2Sql(softname.to_s)+"'"
            
            
            #puts sql
            
            Misc.dbshowCommon(odbc,sql)
            end#Zencart.hasSoftname(hasSoftname,softname)
            
            
            
            
            def Zencart.hasId_products_description(odbc,id)
              id=Misc.txt2Sql(id.to_s) 
              sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_id` ="
              sql=sql+id.to_s
              #puts sql
              
              Misc.dbshowCommon(odbc,sql)
            end #def hasId_products_description(odbc,id)
            
            
            def Zencart.hassoftname_description(odbc,products_name)
              id=products_name
              id=Misc.txt2Sql(id.to_s) 
              sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ='"
              sql=sql+id.to_s
              sql=sql+"'"
              #puts sql
              
              Misc.dbshowCommon(odbc,sql)
            end #def hadsoftname__description(odbc,products_name)
            
            
            
            def Zencart.hasId_products_to_categories(odbc,id)
              id=Misc.txt2Sql(id.to_s) 
              sql="SELECT count( * ) \
      FROM `products_to_categories` \
      WHERE `products_id` ="
              sql=sql+id.to_s
              #puts sql
              
              Misc.dbshowCommon(odbc,sql)
            end #def OSc.hasId_products_to_categories(odbc,id)
            
            
            
            
            def Zencart.geteachfileHtmlDesc(myid)
              sql="SELECT `filename` , `filesize` , `sizeunion` FROM `files` WHERE `myID` ="+myid.to_s
              
              if !(Misc.hasFile(myid).to_s == "0".to_s)
                indivifileTablehtml ="<table width=\"100%\" border=\"1\" bgcolor=\"#FFFFEC\">\n      <tr bgcolor=\"#FFFFAC\">\n        <td width=\"80%\"> <div align=\"left\">Title </div></td><td width=\"20%\"><div align=\"left\">Size</div></td>\n      </tr>\n  "  
              else
                return ""  
              end
              
              filearray=Misc.getfiles(sql)
              
              
              
              
              filearray.each{|x| 
                filename=x[0]
                filesizeval=x[1]
                filesizeuni=x[2]
                
                indivifileTablehtml=indivifileTablehtml+ " <tr>\n        <td>"+filename
                indivifileTablehtml=indivifileTablehtml+"</td>\n        <td>"+filesizeval+" "+filesizeuni
                indivifileTablehtml=indivifileTablehtml+ " </td>\n      </tr>\n " 
              }
              
              indivifileTablehtml=indivifileTablehtml+    "</table>"
              
            end #def Zencart.geteachfile(myid)
            

            
            
            def Zencart.getMaxMyid(odbc)
              sql="SELECT MAX(myID) FROM products WHERE 1"
              a=Misc.dbshowCommon(odbc,sql)  
              a="0" if a.nil?
              a="0" if a==""
              return a
            end #def Zencart.getMaxMyid(odbc)            
            
            def Zencart.getMaxPID(odbc)
              sql="SELECT MAX(products_id) FROM products WHERE 1"
              a=Misc.dbshowCommon(odbc,sql)  
              a="0" if a.nil?
              a="0" if a==""
              return a
            end #def Zencart.getMaxPID(odbc)
            
  
 def Zencart.getMaxFeaturedID(odbc)
  sql="SELECT MAX(`featured_id`) FROM `featured` WHERE 1"
  
  a=Misc.dbshowCommon(odbc,sql)
  a="0" if a.nil?
  return a
end       #  def Zencart.getMaxFeaturedID(odbc)
            
            
            def Zencart.getMaxproducts_attributes_id (odbc)
              sql="SELECT MAX(products_attributes_id) FROM products_attributes  WHERE 1"
              a=Misc.dbshowCommon(odbc,sql)  
            end #def Zencart.getMaxproducts_attributes_id(odbc)
            
            
            
            
            
            #get image from given myid
            def Zencart.gettitleimg(myid)
              sql="SELECT `imgLclPth` \
              FROM `images` \
              WHERE `myID` ="
              sql=sql+myid.to_s
              sql=sql+" AND `imgLclPth` IS NOT NULL"
              sql=sql+" AND `imgLclPth` NOT LIKE \"dlerr%\""
              sql=sql+" AND `titleimage` = \"1\"  "
              
              
              sql2="SELECT `imgLclPth` \
              FROM `images` \
              WHERE `myID` ="
              sql2=sql2+myid.to_s
              sql2=sql2+" AND `imgLclPth` IS NOT NULL"
              sql2=sql2+" AND `imgLclPth` NOT LIKE \"dlerr%\""
               
                           
                      
              result=Misc.dbshow(sql)
              result2=Misc.dbshow(sql2)
              
              if result.length > 0
                return result.sub(/^image\//,"")               
              elsif result2.length > 0
                return result2.sub(/^image\//,"") 
              else  
                return ""
              end #if result.length > 0
            end #def Zencart.gettitleimg(myid)
            
            
            
            def Zencart.getcatname(myid)
              myid=myid.to_s
              sql="select `category` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getproducts_sizenum()
            
            
            
            def Zencart.getregday(myid)
              myid=myid.to_s
              sql="select `register` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getregday(myid)
            
            def Zencart.gettotalsizevalue(myid)
              myid=myid.to_s
              sql="select `sizevalue` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.gettotalsizevalue(myid)
            
            
            
            def Zencart.gettotalsizeunion(myid)
              myid=myid.to_s
              sql="select `sizeunion` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.gettotalsizeunion(myid)
            
            
            def Zencart.getfilecount(myid)
              myid=myid.to_s
              sql="select `filecount` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getfilecount(myid)
            
            
            
            def Zencart.getsitename(myid)
              myid=myid.to_s
              sql="select `site` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getsitename(myid)
            
            
            
            
            def Zencart.getproducts_sizenum(myid)
              myid=myid.to_s
              sql="select `sizevalue`, `sizeunion` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getproducts_sizenum()
            
            def Zencart.getproducts_sizeunion(myid)
              myid=myid.to_s
              sql="select `sizeunion` from `main` where `myID`="
              sql=sql+myid
              Misc.dbshow(sql)
            end #def Zencart.getproducts_sizeunion()
            
            
            def Zencart.getsizeInBytes(myid)
              products_sizenum=self.getproducts_sizenum(myid).to_i
              products_sizeunion=self.getproducts_sizeunion(myid).to_s
              
              case products_sizeunion
                when "Byte"
                return products_sizenum*1
                when "KB"
                return products_sizenum*1024    
                when "MB"
                return products_sizenum*1024*1024    
                when "GB"
                return products_sizenum*1024*1024*1024
                
              end #case products_sizeunion
              
            end #def Zencart.getsizeInBytes(myid)
            
            
            def Zencart.calcprice(sizeinbyte)
              sizeinbyte=sizeinbyte.to_i
              if sizeinbyte<=10*1024*1024  #10M
                return "30"
              elsif  sizeinbyte<=100*1024*1024  #300M
                return "40"
              elsif  sizeinbyte<=500*1024*1024  #500M
                return "50"
              elsif  sizeinbyte<=1024*1024*1024  #1G
                return "60"
              elsif  sizeinbyte<=2*1024*1024*1024  #2G
                return "80"
              elsif  sizeinbyte<=4*1024*1024*1024  #4G
                return "90"        
              else 
                return "56"
              end #if sizeinbyte<100
              
            end #def Zencart.calcprice(sizeinbyte)
            
            
            
            def Zencart.getproducts_name(myid)
              sql= "SELECT `softname` FROM `main` WHERE `myID`="+myid.to_s
              Misc.dbshow(sql) 
            end #def Zencart.getproducts_name(myid)
            
            
            
            def Zencart.insertProduct(odbc,myID,products_id,products_image,products_sizenum,products_sizeunion,categories_id)
              
              
              products_id=products_id
              products_type="1"
              products_quantity="1000"
              products_model="NULL"
              products_image=products_image
              products_price=self.calcprice(self.getsizeInBytes(myID))
              
              products_virtual="0"
              products_date_added=Misc.datenow()
              products_last_modified=""
              products_date_available="NULL"
              products_weight="1"
              products_status="1"
              products_tax_class_id="0"
              manufacturers_id=Cmm.publicgetCommManu(self.getproducts_name(myID)+"_"+self.getcatname(myID))
              puts "man id is: "+manufacturers_id
              products_ordered="0"
              products_quantity_order_min="1"
              products_quantity_order_units="1"
              products_priced_by_attribute="0"
              product_is_free="0"
              product_is_call="0"
              products_quantity_mixed="1"
              product_is_always_free_shipping="0"
              products_qty_box_status="0"
              products_quantity_order_max="0"
              products_sort_order="0"
              products_discount_type="0"
              products_discount_type_from="0"
              products_price_sorter= products_price
              master_categories_id=categories_id
              products_mixed_discount_quantity="1"
              metatags_title_status="0"
              metatags_products_name_status="0"
              metatags_model_status="0"
              metatags_price_status="0"
              metatags_title_tagline_status="0"
              
              
              
              
              sql1=""
              
              
              
              
              
              
              sql1= "INSERT INTO `products` "
              sql1=sql1 +  "(`myID`, 
`products_id`, \
`products_type`, \
`products_quantity`, \
`products_model`, \
`products_image`, \
`products_price`, \
`products_virtual`, \
`products_date_added`, \
`products_last_modified`, \
`products_date_available`, \
`products_weight`, \
`products_status`, \
`products_tax_class_id`, \
`manufacturers_id`, \
`products_ordered`, \
`products_quantity_order_min`, \
`products_quantity_order_units`, \
`products_priced_by_attribute`, \
`product_is_free`, \
`product_is_call`, \
`products_quantity_mixed`, \
`product_is_always_free_shipping`, \
`products_qty_box_status`, \
`products_quantity_order_max`, \
`products_sort_order`, \
`products_discount_type`, \
`products_discount_type_from`, \
`products_price_sorter`, \
`master_categories_id`, \
`products_mixed_discount_quantity`, \
`metatags_title_status`, \
`metatags_products_name_status`, \
`metatags_model_status`, \
`metatags_price_status`, \
`metatags_title_tagline_status` \
) "
              
              sql1=sql1 +      "  VALUES ("
              
              sql1=sql1 +    myID  #myID
              sql1=sql1 +   "," +   "'"+   products_id + "'" #products_id
              sql1= sql1 +  "," +   "'"+   products_type + "'"    #products_type                 
              sql1= sql1 +  "," +   "'"+   products_quantity + "'"  #products_quantity           
              sql1= sql1 +  "," +   ""+   products_model+ ""  #products_model
              sql1= sql1 +  "," +   "'"+   products_image + "'"  #products_image
              sql1= sql1 +  "," +   "'" +  products_price+ "'"  #products_price
              sql1= sql1 +  "," +   "'" +  products_virtual + "'" #products_virtual
              sql1= sql1 +  "," +   "'" +  products_date_added + "'" #products_date_added
              sql1= sql1 +  "," +   "'" +  products_last_modified + "'" #products_last_modified
              
              sql1= sql1 +  "," +   "" +  products_date_available + ""  #products_date_available
              sql1= sql1 +  "," +   "'" +  products_weight + "'"  #products_weight
              sql1= sql1 +  "," +   "'" +  products_status + "'" #products_status
              sql1= sql1 +  "," +   "'" +  products_tax_class_id  + "'"   #   products_tax_class_id
              sql1= sql1 +  "," +   "'" +  manufacturers_id  + "'"     #manufacturers_id
              
              sql1= sql1 +  "," +   "'" +  products_ordered  + "'"     #products_ordered
              
              sql1= sql1 +  "," +   "'" +  products_quantity_order_min  + "'"      #products_quantity_order_min
              sql1= sql1 +  "," +   "'" +  products_quantity_order_units   +"'"  #products_quantity_order_units
              sql1= sql1 +  "," +  "'" +   products_priced_by_attribute   + "'"  #products_priced_by_attribute  
              
              sql1= sql1 +  "," +   "'" +  product_is_free  + "'"     #product_is_free
              sql1= sql1 +  "," +  "'"  +  product_is_call+   "'"      #product_is_call
              sql1= sql1 +  "," +  "'" +   products_quantity_mixed + "'"  #products_quantity_mixed
              sql1= sql1 +  "," +  "'" +   product_is_always_free_shipping + "'"  #product_is_always_free_shipping
              sql1= sql1 +  "," +  "'" +   products_qty_box_status + "'"  #products_qty_box_status
              sql1= sql1 +  "," +  "'" +   products_quantity_order_max + "'"  #products_quantity_order_max
              sql1= sql1 +  "," +  "'" +   products_sort_order + "'"  #products_sort_order
              
              sql1= sql1 +  "," +  "'" +   products_discount_type + "'"  #products_discount_type
              sql1= sql1 +  "," +  "'" +   products_discount_type_from + "'"  #products_discount_type_from
              sql1= sql1 +  "," +  "'" +   products_price_sorter + "'"  #products_price_sorter
              
              sql1= sql1 +  "," +  "'" +   master_categories_id + "'"  #master_categories_id
              
              sql1= sql1 +  "," +   "'" +  products_mixed_discount_quantity  + "'"      #products_mixed_discount_quantity
              sql1= sql1 +  "," +   "'" +  metatags_title_status + "'"     #metatags_title_status
              sql1= sql1 +  "," +   "'" +  metatags_products_name_status  + "'"      #metatags_products_name_status
              sql1= sql1 +  "," +   "'" +  metatags_model_status  + "'"      #metatags_model_status
              sql1= sql1 +  "," +   "'" +  metatags_price_status  + "'"      #metatags_price_status
              sql1= sql1 +  "," +   "'" +  metatags_title_tagline_status  + "'"      #metatags_title_tagline_status
              
              
              sql1= sql1 + ")"
              
              #     puts sql1
              
              
              
              
              if Zencart.hasId(odbc,products_id).to_s == "0".to_s and Zencart.hasmyID(odbc,myID).to_s=="0"
                Misc.dbprocessCommon(odbc, sql1)
              else
                puts "id "+products_id.to_s + " have already in table Products"
              end #if !Zencart.hasId(odbc,products_id)
              
            end #def Zencart.insertProduct()
            
            def Zencart.getDeschtml(myid)
              myid=myid.to_s
              sql="SELECT `html` FROM `description` where myID="+myid
              deschtml=Misc.dbshow(sql)
              deschtml=Misc.txt2Sql(deschtml)
              return deschtml
            end #def Zencart.getDeschtml(myid)
            
            def Zencart.getproducts_url(myid)
              myid=myid.to_s
              sql="SELECT `url` FROM `url` where myID="+myid
              products_url=Misc.dbshow(sql)
              products_url=products_url.downcase
              products_url=products_url.gsub(/http:\/\//,"") 
              products_url=Misc.txt2Sql(products_url)
              
              if !products_url.nil?
                return products_url
              else
                return ""
              end #  if !products_url.nil?
            end  #def Zencart.getproducts_url(myid)
            
            
            
            
            def Zencart.assembleFullHDescHtml(myid)
              puts "\n============"
              puts "myid is: "+myid.to_s
              regday=self.getregday(myid).to_s
              totalsizevalue=self.gettotalsizevalue(myid)
              totalsizeunion=self.gettotalsizeunion(myid)
              filenumber=self.getfilecount(myid).to_s
              deschtml=self.getDeschtml(myid)
              #comment because some descrption contain line break "-----" etc, and "\n\r" will be removed too.
              #deschtml=Iv.removeContinuesChat(deschtml)
              
              #exit
              
           
              filestablecode=self.geteachfileHtmlDesc(myid)
              imgtablecode=self.geteachImgLocalHtmlDesc(myid)
              
              fullhtml= "\n<table width=\"100%\" height=\"100%\" border=\"0\" bgcolor=\"#EAEEFD\">\n  "
              
              #puts "regday:"+regday.to_s+"end"
              if !(regday.to_s=="0000-00-00".to_s or regday.to_s=="")
                fullhtml= fullhtml + "<tr>\n    <td width=\"115\" valign=\"top\">Registered</td>\n    <td width=\"647\">"
                fullhtml= fullhtml + regday
              else
                puts "regday: is 0000, will not show in description html code"
              end #if !(regday.to_s=="0000-00-00".to_s)              
              
              
               
              puts "totalsizevalue: "+totalsizevalue.to_s
              if !(totalsizevalue.to_s=="0".to_s)
              fullhtml= fullhtml + "</td>\n  </tr>\n  <tr>\n    <td>Download Size</td>\n    <td>"
              fullhtml= fullhtml + totalsizevalue+" "+totalsizeunion
              fullhtml= fullhtml + "</td>\n  </tr>\n  "
              else
                puts "totalsizevalue: is 0, will not show in description html code"
              end #if !(totalsizevalue.to_s=="0".to_s)
                            
                                          
                                          
                                                                                                                                    
              
              
              
              
              
              
              puts "filenumber: "+filenumber.to_s
              if !(filenumber.to_s=="0".to_s)
                fullhtml= fullhtml + "<tr>\n    <td width=\"115\">Files count</td>\n    <td>"
                fullhtml= fullhtml + filenumber+"</td>\n  </tr>\n "
              else
                puts "filenumber is 0, will not show in description html code"
              end #if !filenumber.to_s=="0"
              
              
              fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">Discription</td>\n    <td>"
              fullhtml= fullhtml + deschtml
              fullhtml= fullhtml + "</td>\n  </tr>\n "
              if !(filestablecode=="")
                fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">Included Files</td>\n    <td>"
                fullhtml= fullhtml + filestablecode+ "</td>\n  </tr>\n"
              end  #if !filestablecode==""
              
              if !(imgtablecode=="")
                fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">ScreenShots</td>\n    <td>"
                fullhtml= fullhtml + imgtablecode+ "</td>\n  </tr>\n"
              else
                puts "no additional image, screenshot will not show in description html code"
              end  #if !filestablecode==""
              
              fullhtml= fullhtml + "</table>\n\n"
              
              #puts fullhtml
              
            end #def Zencart.assembleFullHDescHtml(myid)
            
            
            def Zencart.insertProducts_description(odbc,myid, products_id,products_name,products_description)
              #products_id="3"
              #products_description="pro's desc"
              #products_name="prod's name"
              
              language_id="1"
              #product url
              products_url=self.getproducts_url(myid)
              products_viewed="0"
              # products_seo_url=""
              
              
              
              products_name=Misc.txt2Sql(products_name)
              products_description=Misc.txt2Sql(products_description)
              products_url=Misc.txt2Sql(products_url)
              #products_seo_url=Misc.txt2Sql(products_seo_url)
              
              
              
              
              sql2=""
              
              
              sql2= "INSERT INTO `products_description` "
              sql2=sql2 +  "(`products_id`, `language_id`, `products_name`,"
              sql2=sql2 +      "`products_description`, `products_url`, `products_viewed`) "
              
              sql2=sql2 +      "  VALUES ("
              
              sql2=sql2 +    "'" + products_id + "'"  #products_id
              sql2=sql2 +  ", " +  "1"  #language_id
              sql2= sql2 +   ", " + "'" + products_name+ "'"  #products_name
              sql2= sql2 +   ", " + "'" + products_description+ "'"  #products_description
              
              sql2= sql2 +   ", " + "'" + products_url+ "'"  #products_url
              sql2= sql2 +  ", " + "'" +   products_viewed + "'"   #products_viewed
              
              
              
              sql2= sql2 + ")"
              
              #puts sql2
              
              
              
              
              if self.hasSoftname(odbc,products_name).to_s == "0".to_s and self.hasId_products_description(odbc,products_id).to_s=="0" and self.hassoftname_description(odbc,products_name).to_s=="0"
                Misc.dbprocessCommon(odbc,sql2)
              else
                puts products_name.to_s + " have already in table products_description "
              end #if Zencart.hasSoftname(products_name).to_s == "0".to_s
              
            end #def Zencart.insertProducts_description()
            
            def Zencart.insertProducts_to_categories(odbc,insertOscPID,categories_id)
              
              if categories_id.nil?
                categories_id="23" #23 is others 
              end #  if categories_id.nil?
              
              sql3="INSERT INTO `products_to_categories` (`products_id`, `categories_id`) VALUES ("
              sql3=sql3+ "'" + insertOscPID+ "'" +", "
              sql3=sql3+ "'" + categories_id+ "'" 
              sql3=sql3+");"
              
              
              if self.hasId_products_to_categories(odbc,insertOscPID).to_s == "0".to_s
                Misc.dbprocessCommon(odbc,sql3)
              else
                puts "id"+insertOscPID +" already existed in table products_to_categories"
              end #if self.hasId_products_to_categories
              
            end #def Zencart.insertProducts_to_categories(insertOscPID,categories_id)
         
    

          def Zencart.insertFeatured(odbc,myID,products_id)
            
            if Misc.hasFeatured(myID).to_s== "0".to_s
              p "#{myID} is not a featured item in unidb, not insert to zencart"
            else   
              
            featured_id=(self.getMaxFeaturedID(odbc).to_i+1).to_s
            products_id=products_id.to_s
            featured_date_added="NULL"
            featured_last_modified="NULL"
            expires_date="0001-01-01"
            date_status_change="NULL"
            status="1"
            featured_date_available="0001-01-01"
            
            
                
             sql1="INSERT INTO `featured` ( \
            `featured_id`, \
            `products_id`, \
            `featured_date_added`, \
            `featured_last_modified`, \
            `expires_date`, \
            `date_status_change`, \
            `status`, \
            `featured_date_available`) "
              
              sql1=sql1 +      "  VALUES ('"
              
              sql1=sql1 +  featured_id   + "'"
              sql1=sql1 + ",'" + products_id + "'"
              sql1=sql1 + ",'" + featured_date_added + "'"
              sql1=sql1 + ",'" + featured_last_modified + "'"
              sql1=sql1 + ",'" + expires_date + "'"
              sql1=sql1 + ",'" + date_status_change + "'"
              sql1=sql1 + ",'" + status + "'"
              sql1=sql1 + ",'" + featured_date_available + "'"   

              sql1=sql1 + ")"
              
              
              
              
              Misc.dbprocessCommon(odbc,sql1)
              
            end # if Misc.isFeatured(myID).to_s== "0".to_s
            
            
 
            
          end #def Zencart.insertFeatured(myID)




            def Zencart.generateDownloadTxtFile(myID,site)
              txt=self.getdllink(myID)            
              
              
              if site=="verycd"
                foldername="C:/wamp/www/zencSubsites/verycd_yottaftp.com/download/"
              elsif site=="bitme"
                foldername="C:/wamp/www/zencSubsites/bitme_io24x7.com/download/"  
              elsif site=="gfxnews"
                foldername="C:/wamp/www/zencSubsites/gfxnews_ivgov.com/download/" 
              elsif site=="taobao"
                foldername="C:/wamp/www/zencSubsites/taobao_serverisready.com/download/"  
              elsif site=="tpb"
                foldername="C:/wamp/www/zencSubsites/tpb_o2soft.com/download/"  
              else  
                foldername="C:/wamp/www/zenc/download/"  
              end
              
              #this folder is used by FTP upload to netfirms after each updates
              tmpdownloadfolder="C:/tmp/downloadfile/#{site}/"
              
              #FileUtils.mkdir_p foldername
             # FileUtils.mkdir_p tmpdownloadfolder
              
              filename=foldername+ self.getDownloadFileName(myID)
              filenameTmp=tmpdownloadfolder +  self.getDownloadFileName(myID)
              
              
              Misc.saveTxt2FileOverwrite(txt,filename)
              Misc.saveTxt2FileOverwrite(txt,filenameTmp)
              
            end #Zencart.generateDownloadTxtFile(myID)
            
            
            def self.haszencartdlpathmap(myid)
              id=Misc.txt2Sql(myid.to_s) 
              sql="SELECT count( * ) \
              FROM `dlpathmap` \
              WHERE `myID` ="
              sql=sql+id.to_s
              #puts sql
              cnt=Misc.dbshow(sql)
              rtn=true
              rtn=false if cnt.to_s=="0"
              #puts "cnt is : "+ cnt.to_s
              return rtn
            end #def self.haszencartdlpathmap(myid)
            
            
            
            def Zencart.insertProducts_attributes_download(odbc,products_attributes_id,products_attributes_filename)
              
              products_attributes_id=products_attributes_id.to_s
              products_attributes_filename=products_attributes_filename.to_s
              
              products_attributes_maxdays="7"
              products_attributes_maxcount="5"
              
              sql1="INSERT INTO `products_attributes_download` ( \
            `products_attributes_id`, \
            `products_attributes_filename`, \
            `products_attributes_maxdays`, \
            `products_attributes_maxcount`)  "
              
              sql1=sql1 +      "  VALUES ('"
              
              sql1=sql1 +  products_attributes_id   + "'"
              sql1=sql1 + ",'" + products_attributes_filename + "'"
              sql1=sql1 + ",'" + products_attributes_maxdays + "'"
              sql1=sql1 + ",'" + products_attributes_maxcount + "'"
              sql1=sql1 + ")"
              
              #p sql1
              #exit
              Misc.dbprocessCommon(odbc,sql1)
              
            end #def Zencart.insertProducts_attributes_download(products_attributes_id,products_attributes_filename)
            
            
            
            
            
            def Zencart.insertProducts_attributes(odbc,products_attributes_id,products_id,options_id,options_values_id,options_values_price,products_options_sort_order,product_attribute_is_free,attributes_default)
              
              products_attributes_id=products_attributes_id.to_s
              products_id=products_id.to_s
              options_id=options_id.to_s
              options_values_id=options_values_id.to_s
              options_values_price=options_values_price.to_s
              price_prefix="+"
              products_options_sort_order=products_options_sort_order.to_s
              product_attribute_is_free=product_attribute_is_free.to_s
              products_attributes_weight="0"
              products_attributes_weight_prefix="+"
              attributes_display_only="0"
              attributes_default=attributes_default.to_s
              attributes_discounted="1"
              attributes_image="NULL"
              attributes_price_base_included="1"
              attributes_price_onetime="0"
              attributes_price_factor="0"
              attributes_price_factor_offset="0"
              attributes_price_factor_onetime="0"
              attributes_price_factor_onetime_offset="0"
              attributes_qty_prices="NULL"
              attributes_qty_prices_onetime="NULL"
              attributes_price_words="0"
              attributes_price_words_free="0"
              attributes_price_letters="0"
              attributes_price_letters_free="0"
              attributes_required="0"
              
              
              sql1="INSERT INTO `products_attributes` (
`products_attributes_id`, \
`products_id`, \
`options_id`, \
`options_values_id`, \
`options_values_price`, \
`price_prefix`, \
`products_options_sort_order`, \
`product_attribute_is_free`, \
`products_attributes_weight`, \
`products_attributes_weight_prefix`, \
`attributes_display_only`, \
`attributes_default`, \
`attributes_discounted`, \
`attributes_image`, \
`attributes_price_base_included`, \
`attributes_price_onetime`, \
`attributes_price_factor`, \
`attributes_price_factor_offset`, \
`attributes_price_factor_onetime`, \
`attributes_price_factor_onetime_offset`, \
`attributes_qty_prices`, \
`attributes_qty_prices_onetime`, \
`attributes_price_words`, \
`attributes_price_words_free`, \
`attributes_price_letters`, \
`attributes_price_letters_free`, \
`attributes_required`)  "
              
              sql1=sql1 +      "  VALUES ("
              
              sql1=sql1 +    products_attributes_id  
              
              sql1=sql1 + ",'" + products_id + "'"
              sql1=sql1 + ",'" + options_id + "'"
              sql1=sql1 + ",'" + options_values_id + "'"
              sql1=sql1 + ",'" + options_values_price + "'"
              sql1=sql1 + ",'" + price_prefix + "'"
              sql1=sql1 + ",'" + products_options_sort_order + "'"
              sql1=sql1 + ",'" + product_attribute_is_free + "'"
              sql1=sql1 + ",'" + products_attributes_weight + "'"
              sql1=sql1 + ",'" + products_attributes_weight_prefix + "'"
              sql1=sql1 + ",'" + attributes_display_only + "'"
              sql1=sql1 + ",'" + attributes_default + "'"
              sql1=sql1 + ",'" + attributes_discounted + "'"
              sql1=sql1 + "," + attributes_image + ""
              sql1=sql1 + ",'" + attributes_price_base_included + "'"
              sql1=sql1 + ",'" + attributes_price_onetime + "'"
              sql1=sql1 + ",'" + attributes_price_factor + "'"
              sql1=sql1 + ",'" + attributes_price_factor_offset + "'"
              sql1=sql1 + ",'" + attributes_price_factor_onetime + "'"
              sql1=sql1 + ",'" + attributes_price_factor_onetime_offset + "'"
              sql1=sql1 + "," + attributes_qty_prices + ""
              sql1=sql1 + "," + attributes_qty_prices_onetime + ""
              sql1=sql1 + ",'" + attributes_price_words + "'"
              sql1=sql1 + ",'" + attributes_price_words_free + "'"
              sql1=sql1 + ",'" + attributes_price_letters + "'"
              sql1=sql1 + ",'" + attributes_price_letters_free + "'"
              sql1=sql1 + ",'" + attributes_required  + "'"
              sql1=sql1 + ")"
              
              Misc.dbprocessCommon(odbc,sql1)
              
            end #def Zencart.insertProducts_attributes()
            
            
            
            
            
            
            def Zencart.insertMyID(odbc,myid)
              myid=myid.to_s
              
              
  
              myIDinZencart=self.myID2Products_id(odbc,myid)
              if !(myIDinZencart.nil? or myIDinZencart.to_s=="")
                puts "myID "+myid+" existed in #{odbc},skip"
                return
              end
              
              products_description=self.assembleFullHDescHtml(myid)
              #puts products_description
              
              #get OscPID
              insertOscPID=(self.getMaxPID(odbc).to_i+1).to_s
              
              #puts insertOscPID
              
              
              
              #get image of title
              products_image=self.gettitleimg(myid)
              
              #size number and value
              products_sizenum=self.getproducts_sizenum(myid)
              products_sizeunion=self.getproducts_sizeunion(myid)
              
              #product name
              products_name=self.getproducts_name(myid)
              
              
              #category id
              
              #if (self.getsitename(myid)=="verycd")
              #  categories_id=self.cat2OscCatNum(self.getsitename(myid),self.getcatname(myid))
              #else
              #  categories_id=Cmm2.publicgetcatID(self.getproducts_name(myid)+"_"+self.getcatname(myid))
              #end
              
              categories_id=Cmm2.publicgetcatID(self.getproducts_name(myid)+"_"+self.getcatname(myid))
              
              puts "categories_id is: "+categories_id
              
              #get 'delivery type' optionid
              optionsOptID=self.getProducts_options_id(odbc,"Options")
              
              #get 'shipping disk' option value id.
              shippingDiskOptValue=self.getProducts_options_values_id(odbc,"Get Shipping Disk(s)")
              
              
              #get 'download' option value id.
              downloadOptValue=self.getProducts_options_values_id(odbc,"Download From Server (Free!)")
              
              
              #get other option value id
              getInstallGuideDocumentOptValue =self.getProducts_options_values_id(odbc,"Get Install Guide Document")
              getRemoteInstallServiceOptValue =self.getProducts_options_values_id(odbc,"Get Remote Install Service")
              getThreeMonthWarrantyOptValue =self.getProducts_options_values_id(odbc,"Get Three Month Warranty")
              
              
              judge= self.hasSoftname(odbc,products_name).to_s == "0".to_s and self.hasId_products_description(odbc,insertOscPID) ==0 
              judge = judge and self.hasId_products_to_categories(odbc,insertOscPID).to_s == "0".to_s
              judge = judge and self.hasId(odbc,insertOscPID).to_s == "0".to_s and self.hasmyID(odbc,myid).to_s=="0"
              
              #puts judge
              if judge 
                self.generateDownloadTxtFile(myid, Misc.getSoftSite(myid))
                self.insertProduct(odbc,myid,insertOscPID,products_image,products_sizenum,products_sizeunion,categories_id);  
                self.insertProducts_description(odbc,myid, insertOscPID,products_name,products_description);  
                self.insertProducts_to_categories(odbc,insertOscPID,categories_id)
                
                products_attributes_id_download=(self.getMaxproducts_attributes_id(odbc).to_i+1).to_s
                self.insertProducts_attributes(odbc,products_attributes_id_download,insertOscPID,optionsOptID,downloadOptValue,"0","1","1","1" )
                self.insertProducts_attributes_download(odbc,products_attributes_id_download, self.getDownloadFileName(myid))
          
                self.insertProducts_attributes(odbc,(self.getMaxproducts_attributes_id(odbc).to_i+1).to_s,insertOscPID,optionsOptID,shippingDiskOptValue,"30","2","1","0" )
                self.insertProducts_attributes(odbc,(self.getMaxproducts_attributes_id(odbc).to_i+1).to_s,insertOscPID,optionsOptID,getInstallGuideDocumentOptValue,"15","3","1","0" )
                self.insertProducts_attributes(odbc,(self.getMaxproducts_attributes_id(odbc).to_i+1).to_s,insertOscPID,optionsOptID,getRemoteInstallServiceOptValue,"30","4","1","0" )
                self.insertProducts_attributes(odbc,(self.getMaxproducts_attributes_id(odbc).to_i+1).to_s,insertOscPID,optionsOptID,getThreeMonthWarrantyOptValue,"10","5","1","1" )
                
  
                
                
                self.insertFeatured(odbc,myid,insertOscPID)
                
                
              else #if judge
                puts "product,product_description,productsToCategory might have duplicate record."
              end #if judge 
            end #def zencart.insertMyID(myid)
            
            
            
            
            
            
            
            
            
            
            def Zencart.myID2Products_id(odbc,myID)
              if myID.nil?
                puts "myID is nil ,exit"
              else	
                myID=myID.to_s.strip
                sql="SELECT `products_id` FROM `products` WHERE `myID`="+myID
                products_id=Misc.dbshowCommon(odbc,sql)
                return products_id
              end #if myID.nil?
            end #def Zencart.myID2Products_id(myID)
            
            
            def Zencart.Products_id2myID(odbc,products_id)
              if products_id.nil?
                puts "products_id is nil ,exit"
              else	
                products_id=products_id.to_s.strip
                sql="SELECT `myID` FROM `products` WHERE `products_id`="+products_id
                myID=Misc.dbshowCommon(odbc,sql)
                return myID
              end #if products_idnil?
            end #def Zencart.Products_id2myID(products_id)
            
            
            
            
            
            
            def Zencart.removeProducts_id(odbc,products_id)
              
              products_id=products_id.to_s
              puts products_id
              myID=self.Products_id2myID(odbc,products_id).to_s
              
              if (self.hasId(odbc,products_id).to_s == "0".to_s)
                then 
                puts "products_id "+products_id+" does not existed in zencart products table"
                return
              else
                
                Misc.dbprocessCommon(odbc,"delete from `products` where `products_id` = "+ products_id)
                Misc.dbprocessCommon(odbc,"delete from `products_description` where `products_id` = " + products_id)
                Misc.dbprocessCommon(odbc,"delete from `products_to_categories` where `products_id` = "+products_id)
                Misc.dbprocessCommon(odbc,"delete from `products_attributes` where `products_id` = "+products_id)
                

              
                Misc.dbprocessCommon(odbc,"delete from `products_discount_quantity` where `products_id` = "+products_id)
                Misc.dbprocessCommon(odbc,"delete from `products_notifications` where `products_id` = "+products_id)
          
                
                
                self.removeProductAttributes(odbc,products_id)
 
                
                
               # Misc.dbprocessCommon(odbc,"delete from `dlpathmap` where `myID` = " + myID)
                puts "products_id "+products_id+" was removed from zencart"
              end #if (self.hasId(products_id).to_s == "0".to_s)	
            end #def Zencart.removeProducts_id(products_id)
            
            
            
             def Zencart.removeProductAttributes(odbc,products_id)
               array=Misc.dbshowArrayCommon(odbc,"select `products_attributes_id` from  `products_attributes` where `products_id` = #{products_id}")
               array.each{|products_attributes_id|               
               self.removeproducts_attributes_download(odbc,products_attributes_id)               
               }
               Misc.dbprocessCommon(odbc,"delete from  `products_attributes` where `products_id` = "+products_id)
               
               
             end #def Zencart.removeProductAttributes(products_id)
            
            
            
             def Zencart.removeproducts_attributes_download(odbc,products_attributes_id)
               products_attributes_id=products_attributes_id.to_s
               Misc.dbprocessCommon(odbc,"delete from  `products_attributes_download` where `products_attributes_id` = "+products_attributes_id.to_s)
               puts "removed download attribute for attributeid #{products_attributes_id}"
             end
            
            def Zencart.removeMyID(odbc,myID)
              if myID.nil?
                puts "myID is nil,can not delete , exit"
              else	
                myID=myID.to_s.strip
                myIDinZencart=self.myID2Products_id(odbc,myID)
                if (myIDinZencart.nil? or myIDinZencart.to_s=="")
                  puts "myID "+myID+" not existed in Zenc #{odbc}"
                else
                  self.removeProducts_id(odbc,myIDinZencart)
                end # if (myIDinZencart.nil? or myIDinZencart.to_s=="")
                
              end  # if myID.nil? 	
            end #def Zencart.removeMyID(myID)
            
            
            
            
            def Zencart.geteachImgLocalHtmlDesc(myid)
              sql="SELECT `imgLclPth` \
      FROM `images` \
      WHERE `myID` ="
              sql=sql+myid.to_s
              sql=sql+" AND `imgLclPth` IS NOT NULL"
              sql=sql+" AND `imgLclPth` NOT LIKE \"dlerr%\""
              
              if !(Misc.hasImgLocal(myid).to_s == "0".to_s)
                individeImgTablehtml ="<table width=\"100%\" border=\"0\">\n "  
              else
                return ""  
              end
              
              imglocalArray=Misc.getfiles(sql) #it actual return ImgLocal of the myid, but not files.
              softname=Zencart.getproducts_name(myid)
              
              imglocalArray.each{|x| 
                imglocal="http://61.152.188.156:8088/"+x[0]
                
                individeImgTablehtml=individeImgTablehtml+ " <tr>\n <td> <img src=\""+imglocal+"\" alt=\""+softname+"\"></td></tr>"
                #   individeImgTablehtml=individeImgTablehtml+"<tr><td><p> &NBPS</p></td></tr>" #NBPS DISPLAIED AS CHARACTER FOR CERTERN THEME.
                individeImgTablehtml=individeImgTablehtml+"<tr><td><p> </p></td></tr>"
              }
              
              individeImgTablehtml=individeImgTablehtml+    "</table>"
              return individeImgTablehtml
            end #def Zencart.geteachImgLocalHtmlDesc(myid)
            
            
            def Zencart.getDownloadFileName(myid)
                sql="SELECT `path` FROM `dlpathmap` WHERE `myID`="+myid.to_s
                rst=Misc.dbshow(sql).split("/")[-1].to_s+".txt"
                rst=myid.to_s+".txt" if rst == ".txt"
                return rst
            end #Zencart.getDownloadFileName(myid)
            
            
            def Zencart.getdllink(myid)
              sql="SELECT * FROM `dlpathmap` WHERE `myID`="+myid.to_s
              rst=Misc.dbshowWholeArray(sql)[0]
              
              if rst.nil?
                  rtn="  Thanks for your order!"
                  rtn=rtn+"\n\n  This Product now is under manual processing, download link will be send in 24 hours by email."
                  rtn=rtn+"\n\n  For example, if you paid through paypal account \"name@abc.com\", "
                  rtn=rtn+"\n  then we will send email to email box  \"name@abc.com\"."
                  rtn=rtn+"\n\n  If you want using other email box, please drop a email to us,"
                  rtn=rtn+"\n  our email is listed in the foot of the website."
                  rtn=rtn+"\n\n\n\n  Thanks again!"
              else
                #"http://61.152.188.156", "8088", "gweb", "2005-3-8/id1_Ansys-81"
                rtn=rst[1]+"://"+rst[2]+":"+rst[3]+"/"+rst[4]+"/"+rst[5]
                rtn=rtn+"\n\n Download like presented above, we suggest using download tools like \"FlashGet\" for windows or \"iGetter\" for Mac to download if download size is larger than 1G."
                rtn=rtn+"\n\n We also provide paid FTP download, contact us if you want FTP download"
                rtn=rtn+"\n\n Our email is listed in the foot of the website, email us if you have any questions"
                rtn=rtn+"\n\n    Thanks for your order, enjoy!"
              end
              return rtn
            end #def Zencart.getdllink(myid)
            
            
            
            
def Zencart.scanALLProcutsAndInsertFeatures(odbc)

sql="SELECT `products_id` FROM  `products`  WHERE 1"
productIDArray=Misc.dbshowArrayCommon(odbc,sql)

productIDArray.each{|productid|   
productname=self.getProductNamebyProductID(odbc,productid)
if Misc.isFeaturedProduct(productname)
  self.insertProductID2featured(odbc,productid)
  puts "insert #{productid} to Zenc featured"
end #if Misc.isFeaturedProduct(odbc,productname)
}
end #def Zencart.scanALLProcutsAndInsertFeatures()

def Zencart.getProductNamebyProductID(odbc,productID)
sql="SELECT `products_name` FROM `products_description` WHERE `products_id` =#{productID}"
softnameArray=Misc.dbshowArrayCommon(odbc,sql)
return softnameArray[0]
end #def Zencart.getProductNamebyProductID(productID)


def  Zencart.insertProductID2featured(odbc,productid)
sql="INSERT INTO  `zencart`.`featured` (`featured_id`, `products_id`, `featured_date_added`, `featured_last_modified`, `expires_date`, `date_status_change`, `status`, `featured_date_available`) VALUES "
sql=sql+"(NULL, '"
sql=sql+productid.to_s
sql=sql+"', NULL, NULL, '0001-01-01', NULL, '1', '0001-01-01');"
Misc.dbprocessCommon(odbc,sql)
end #def  Zencart.insertProductID2featured(productid)


            
def Zencart.hasTitleImage(odbc,myID)
  sql="SELECT `products_image` FROM `products` WHERE `myID`=#{myID}"
  productimage=Misc.dbshowArrayCommon(odbc,sql)
 #puts productimage
  return productimage[0]
end #def Zencart.hasTitleImage(odbc,myID)


def Zencart.updateTitleImage(odbc,myid)
  if self.hasmyID(odbc,myid).to_s == "0"
    puts "myid #{myid} not existed in #{odbc}, skip"
    return
  end
  
  
  
  if self.hasTitleImage(odbc,myid).nil? or self.hasTitleImage(odbc,myid)=="" 
  imageLocPath = Misc.getTitleImage(myid)
  
  if imageLocPath=="" or imageLocPath.nil?
    puts "no title image in unidb, skip"
    return
  end
  imageLocPath=imageLocPath.sub(/image\//,"")
  sql="UPDATE `products` SET `products_image` = \"#{imageLocPath}\" WHERE `myID` =#{myid};"
  Misc.dbprocessCommon(odbc,sql)
  puts "updated title image for myid #{myid} to #{imageLocPath}"
  elsif 
   puts "myid #{myid} in #{odbc} already has title image, skip update title image."
  end #if Zencart.hasTitleImage(odbc,myid).nil?
end #def Zencart.updateTitleImage(odbc,myID)

 
def  Zencart.updateOrAddDlpathmap(myid,protocol,server,port,ppath,path)
  if myid.nil? or myid==""
    puts "Zencart.updateOrAddDlpathmap, myid is nil or empty, return"
    return
  end
  
  if self.haszencartdlpathmap(myid)
    Misc.delete_id_from_tbl("dlpathmap",myid)
  end #if self.haszencartdlpathmap(myid)   
  Misc.insertDlPathmap(myid,protocol,server,port,ppath,path) 
end #def  Zencart.updateOrAddDlpathmap(myid,protocol,server,port,ppath,path)
            

            
end #end of the module Zenc