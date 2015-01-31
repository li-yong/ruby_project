require "fileutils"
# -*- coding: utf-8 -*-
module TaobaoGeneral
  require "misc"
  require "iv"
  require "cmm"
  #require 'FileUtils'
  require 'ftools'
  
  
  def TaobaoGeneral.getTitleImageURL(ie)
    if  ie.image(:id,"J_ImgBooth").exist?
      return  ie.image(:id,"J_ImgBooth").src
    else
      return nil
    end
  end  #def TaobaoGeneral.getTitleImageURL(ie)
  
  
  
  def TaobaoGeneral.getProductName(ie)
    productName="null"
    if (ie.div(:class, "tb-detail-hd").exist?)
      productName=ie.div(:class, "tb-detail-hd").h3(:index,1).text
      productName=Misc.googletranslatetoen(productName)
      productName=productName.gsub(/\?/,"")
    elsif  (ie.div(:class, "detail-hd").exist?)
      productName=ie.div(:class, "detail-hd").h3(:index,1).text
      productName=Misc.googletranslatetoen(productName)
      productName=productName.gsub(/\?/,"")       
    end
  end  #def TaobaoGeneral.getProductName(ie)
  
  
  
  def TaobaoGeneral.getProductCat(ie)
    
  end  #def TaobaoGeneral.getTitleImage(ie)
  
  
  
  def TaobaoGeneral.getSellerID(ie)
    rtn="ParseFail"
    #obj judgement sequence is important, sensitive.
    obj=ie.div(:class,"shop-regular-hd") if ie.div(:class,"shop-regular-hd").exist?
    obj=ie.div(:class,"shop-info-simple") if ie.div(:class,"shop-info-simple").exist?
    
    rtn = obj.link(:index,1).text if !obj.nil?
    return rtn
  end  #def TaobaoGeneral.getSellerID(ie)
  
  
  #taobao seller overall rank rate, full is 100%
  def TaobaoGeneral.getSellerReputationRate(ie)
    rtn="99%"
    if ie.div(:class,"shop-info-simple").exist?
      txt=  ie.div(:class,"shop-info-simple").text
      rtn=txt.split[-1].split('%')[0].split(':')[-1]
    end
    return rtn
  end  #def TaobaoGeneral.getSellerReputationRate(ie)
  
  
  #taobao seller overall rank image, diamond, heart ...
  def TaobaoGeneral.getSellerRankImg(ie)
    rtn="http://pics.taobaocdn.com/newrank/s_blue_4.gif"  
    if ie.link(:id,"shop-rank").exist?
      rtn=ie.link(:id,"shop-rank").image(:index,1).src
    end
    return rtn 
  end  #def TaobaoGeneral.getSellerRank(ie)
  
  
  
  #this product's score, full is 5  
  def TaobaoGeneral.getThisItemsScore(ie)
    rtn="5"
    obj=ie.strong(:class,"score")
    rtn=obj.text if obj.exist? and obj.text.strip!=""
    
    return rtn
    
  end  #def TaobaoGeneral.getSellerRank(ie)
  
  
  #this product's scroe rated time by purchased customer
  def TaobaoGeneral.getThisItemsScoredRatedbyCustomer(ie)
  
   begin  
     #Watir::Wait.until(30){ie.span(:class,"rated").exist?}
	  Watir::Wait.until(30){ie.span(:class,"rated").exist?}
     rtn=ie.span(:class,"rated").html.split(">")[2].split("<")[0]
   rescue
     puts "parse seller rate timeout"
     rtn="90"
   end
 
   return rtn
   
   
  end  #def TaobaoGeneral.getSellerRank(ie)
  
  
  def TaobaoGeneral.getPrice(ie)
    
   
    if ie.li(:id,"J_StrPriceModBox").exist?
      obj=ie.li(:id,"J_StrPriceModBox")
      if obj.strong(:id,"J_StrPrice").exist?        
        price=obj.strong(:id,"J_StrPrice").text
      else
        price=obj.html.split('J_StrPrice')[-1].split(">")[1].split("<")[0]
      end
    else
      puts "parse price not found obj ie.li(:id,\"J_StrPriceModBox\"),set price to 0"
      price="0"
    end
    
    return price.split('-')[0]
    
    
  end  #def TaobaoGeneral.getPrice(ie)
  
  
  
  def TaobaoGeneral.getDomsticExpressPost2SH(ie)
    # Return 0 if seller assumes shipping  
    # Return 12 if not success parsed
    
    defaultpostage="12"
    sellerAssumesShipping="0"
    
    if  ie.em(:id,"J_PostageList").exist?  # seller has set postage areas
      txt=ie.em(:id,"J_PostageList").text
    elsif ie.li(:id,"ShippingCost").exist?  # Seller does not category postage areas
      txt= ie.li(:id,"ShippingCost").em(:index,1).text
    else
      return defaultpostage
    end
    
    b=Misc.googletranslatetoen(txt)
    if b == "Seller assumes shipping"
      return  sellerAssumesShipping
    end
    
    postarr=b.split
    
    
    if postarr.index("Express:") == nil
      return defaultpostage
    end
    
    postage=postarr[postarr.index("Express:")+1]
    return postage
  end  #def TaobaoGeneral.getDomsticExpressPost2SH(ie)
  
  
  
  
  
  def TaobaoGeneral.getItemEsitmatedWeight(domsticExpressPost2SH)
    postage=domsticExpressPost2SH.to_i
    if postage <= 0
      estimatedWeight="0.6"
    elsif postage > 0 and postage <= 8
      estimatedWeight="0.8"
    elsif postage > 8 and postage <= 12
      estimatedWeight="1"
    elsif postage > 12 and postage <= 16
      estimatedWeight="1.2"      
    elsif postage > 16 and postage <= 20
      estimatedWeight="1.5"
    elsif postage > 20 and postage <= 25
      estimatedWeight="2"
    elsif postage > 25 
      estimatedWeight="2.2" 
    else
      estimatedWeight="1"
    end
    
    return estimatedWeight
  end  #def TaobaoGeneral.getItemEsitmatedWeight(ie)
  
  
  
  
  
  def TaobaoGeneral.getDesc(ie)
    desc=ie.div(:id, "J_DivItemDesc").html

    desc=Misc.googletranslatetoenWeb(desc)
    
    #</ td  > ==> </td>
    desc=desc.gsub(/<\/[\s\t\r\n\f]*/i,"</")  #remove end white space "</  "==> "</"
    desc=desc.gsub(/[\s\t\r\n\f]*>/i,">")   #remove begin white space "  >"==>  >"
    
    
    
#    desc=Sanitize.clean(desc,  :output => :html,  :elements => ['p', 'b', 'i', 'strong', 'br', 'img'])
#    desc=Sanitize.clean(desc, Sanitize::Config::RELAXED)   
    desc=  Sanitize.clean(desc, 
                 :elements => ['p', 'br', 'img','table','td','tr'],
                 :attributes => {'img'=> ['src']} )
#    desc=Sanitize.clean(desc)

    return desc
  end  #def TaobaoGeneral.getDesc(ie)
  
  
  
  
  
  
  def TaobaoGeneral.getInventory(ie)
    ie.span(:id,"J_SpanStock").text
  end  #def TaobaoGeneral.getInventory(ie)
  
  
  
  def TaobaoGeneral.get30daySold(ie)
    rtn="88" 
    
    obj=ie.li(:class,"tb-sold-out") if ie.li(:class,"tb-sold-out").exist? 
    obj=ie.li(:class,"tb-sold-out tb-clear") if ie.li(:class,"tb-sold-out tb-clear").exist? 
    
    rtn=obj.em(:index,1).text if !obj.nil?
    
    return rtn
  end  #def TaobaoGeneral.get30daySold(ie)
  
  
  def TaobaoGeneral.getReviewCounts(ie)
    obj=ie.link(:id,"J_ReviewTabTrigger") if  ie.link(:id,"J_ReviewTabTrigger").exist?
    obj=ie.link(:id,"J_MallReviewTabTrigger") if  ie.link(:id,"J_MallReviewTabTrigger").exist?
    return "0" if obj.nil?
    rtn=obj.html.split("<")[2].split(">")[-1].to_s
    return rtn
  end  #def TaobaoGeneral.getReviewCounts(ie)
  
  

  
  
  def TaobaoGeneral.getThisPageReviewsSQL(odbc,productid,reviewtable,reviews_id)
    rtnSqlArr=[]
    rtnPageArr=[]
    
   reviews_id=reviews_id.to_s 
  endNumber=reviewtable.rows.length-1
 


(2..endNumber).each{|rowNumber|
 #puts rowNumber
 reviewContent= reviewtable[rowNumber][1].p(:index,1).text
 reviewContent=Misc.googletranslatetoen(reviewContent)
 reviewDate=reviewtable[rowNumber][1].span(:index,1).text.sub("[","").sub("]","")
 
 
 if reviewtable[rowNumber][2].links.length==2
     reviewUserName=reviewtable[rowNumber][2].link(:index,1).text
 elsif    reviewtable[rowNumber][2].links.length==0 
    reviewUserName=reviewtable[rowNumber][2].text.gsub("买家：","")
 else
    reviewUserName="null"
 end  
 
 puts "parsed, reviews_id is  #{reviews_id}"
 rtnSqlArr=rtnSqlArr+self.getInsertReviewToDbSQL(odbc,productid,reviewUserName,reviewContent,reviewDate,reviews_id) #[sql4,sql5,sql4,sql5,sql4,sql5....]
 reviews_id=(reviews_id.to_i+1).to_s
 rtnPageArr << ["#{reviewContent}. [#{reviewDate}] ",reviewUserName] #[[rCnt,Rviewer],[rCnt,Rviewer],[rCnt,Rviewer],[rCnt,Rviewer]]
}



 return [rtnPageArr,rtnSqlArr,reviews_id]
  end #  def TaobaoGeneral.insertThisPageReviewsToDB(reviewtable)


  
  
  def TaobaoGeneral.ParseDescription(ie)
    ie.ul(:id,"J_TabBar").link(:index,1).click
   
    
    
    hDesc={}
    hDesc["the30dayssold"]=self.get30daySold(ie)
    hDesc["desc"]= self.getDesc(ie)
    hDesc["postage"]=postage=self.getDomsticExpressPost2SH(ie)
    hDesc["inventory"]=self.getInventory(ie).to_i.to_s
    hDesc["weight"]=self.getItemEsitmatedWeight(postage)
    hDesc["price"]=self.getPrice(ie)
    hDesc["productName"]=self.getProductName(ie)
    hDesc["sellid"]=self.getSellerID(ie)
    hDesc["sellerRankImg"]=self.getSellerRankImg(ie)
    hDesc["sellerReputationRate"]=self.getSellerReputationRate(ie)
    hDesc["TitleImageURL"]=self.getTitleImageURL(ie)

    
    
    return hDesc
  end #  def TaobaoGeneral.ParseDescription(ie)

  
  
  
  def TaobaoGeneral.dlimage(imageURL,myid, imageIndexNumber)
    #save image to c:/ruby_project/image2 
    #      and Cdlimage:/wamp/www/zencSubsites/tbgeneral/images/image2/
    #return something like  image2/001/id1_1_T1r6RKXddBXXXPoHk__075428.jpg_310x310.jpg
   
    ## copy image file to zencart image folder
   # Cmm.saveHttpImg_branding(myid,imglink,folder,indexnumberofarray,i_timeout,i_imgSizeNoLessThan)
   # puts "========input TaobaoGeneral.dlimage is:"+imageURL
    
    filesrc=Cmm.saveHttpImg_branding(myid, imageURL,"image2",imageIndexNumber.to_s,30,0 )
    
     return imageURL if imageURL.index(/[^[:alnum:][:punct:] ]/) != nil  #return if imageURL has DBCS
     
    if !filesrc.include?("dlerr")
    filedst="C:/wamp/www/zencSubsites/tbgeneral/images/"
    filedst=filedst+filesrc    
    arr=filedst.split("/")
    arr.pop
    dstpath=""
    arr.each{|x| dstpath=dstpath+x+"/" }
  #  puts dstpath
    FileUtils.mkdir_p(dstpath)
    File.copy("c:/ruby_project/"+filesrc,filedst)
    rtn="images/"+filesrc
  else
    rtn=""
  end
#    puts "========output TaobaoGeneral.dlimage is:"+rtn
    return rtn
    
  end #  def TaobaoGeneral.dlimage(imageURL,myid, imageIndexNumber)




#parse images in description, return hash imgHash[remoteImgURL]=>imglocalHttpPath


  def TaobaoGeneral.downloadImageInDescription(ie,myid)
    
    desc=ie.div(:id, "J_DivItemDesc")
    imgarr=[]
    desc.images.each{|x| imgarr<<x.src }
    imgarr=imgarr.uniq
    
 #  return imgarr
    
    
    
    number=1  #description image index start from 1.  0 is assgined to title image
    imgHash=Hash.new
    
    imgarr.each{|x| 
      remoteImgURL=x
      imglocalHttpPath=self.dlimage(remoteImgURL,myid,number )
      imgHash[remoteImgURL]=imglocalHttpPath
      #imgHash[remoteImgURL]="/this/path/.jpg"
      number=number+1
    }     
    
    #puts  "imgHash is: #{imgHash}, hashlength="+imgHash.length.to_s
    return imgHash

  end #  def TaobaoGeneral.downloadImageInDescription(ie,myid)

  
  
  def TaobaoGeneral.replaceRemoteimgToLocalImg(descHTML,imgHash)
     imgHash.each {|key, value| 
      # p "replace descHTML:"
      # puts key+"==>"+value
       descHTML=descHTML.gsub(key, value) 
       }
      # Misc.saveTxt2File(descHTML,"c:/tmp/a.txt") 
       
       return descHTML
       
       
    
  end
   
  
  def TaobaoGeneral.ParseReview(ie)
    
    5.times {|x|
     if ie.link(:id,"J_ReviewTabTrigger").exist?
          ie.link(:id,"J_ReviewTabTrigger").click!
          break
     elsif ie.ul(:id,"J_TabBar").link(:index,2).exist?
          ie.ul(:id,"J_TabBar").link(:index,2).click!
          break 
      else
        puts "review trigger not appear, try #{x} of 5 "
        sleep 1
     end
    } 

    
  
    Watir::Wait.until(30){ie.table(:class,"show-rate-table").exist?} 
    
    hReview=Hash.new
    

   puts hReview["thisItemRevCnt"]=self.getReviewCounts(ie).to_s
  puts  hReview["thisItemScore"]=self.getThisItemsScore(ie).to_s
  puts  hReview["thisItemScoredTime"]=self.getThisItemsScoredRatedbyCustomer(ie)
    
    
    hReview["reviewArray"]=   self.getReviewWithENContentArr(ie)
    
    
    hReview["reviewHtmlArray"]=self.getReviewHtmlArray(hReview["reviewArray"])

    # hReview["reviewArray"] structure: ["reviewerid",["reviewcontentEN","reviewdate"]]
    

    
    return hReview
  end
  
  
  ############ FUNCTIONS END ###############
  
  
  ############ FUNCTION INSERT ZENCART START ###########################
  
  
  def TaobaoGeneral.getMaxPID(odbc)
    sql="SELECT MAX(products_id) FROM products WHERE 1"
    a=Misc.dbshowCommon(odbc,sql)  
    a="0" if a.nil?
    a="0" if a==""
    return a
  end #def TaobaoGeneral.getMaxPID(odbc)
  
  
  
  
    def TaobaoGeneral.getMaxReviewID(odbc)
    sql="SELECT MAX(reviews_id) FROM reviews WHERE 1"
    a=Misc.dbshowCommon(odbc,sql)  
    a="0" if a.nil?
    a="0" if a==""
    return a
  end #def TaobaoGeneral.getMaxReviewID(odbc)
  
  
  
  
  def TaobaoGeneral.assembleReviewHtmlDesc(reviewArray)
    if !reviewArray.nil?
    indiviReviewTablehtml ="<table width=\"100%\" border=\"1\" bgcolor=\"#FFFFEC\">\n      <tr bgcolor=\"#FFFFAC\">\n        <td width=\"80%\"> <div align=\"left\">Reviews</div></td><td width=\"20%\"><div align=\"left\">Reviewer</div></td>\n      </tr>\n  "  
    
    reviewArray.each{|x| 
      reviewContent=x[0]
      reviewer=x[1]
      
      indiviReviewTablehtml=indiviReviewTablehtml+ " <tr>\n        <td>"+reviewContent
      indiviReviewTablehtml=indiviReviewTablehtml+"</td>\n        <td>"+reviewer
      indiviReviewTablehtml=indiviReviewTablehtml+ " </td>\n      </tr>\n " 
    }
    
    indiviReviewTablehtml=indiviReviewTablehtml+    "</table>"
  else
    indiviReviewTablehtml="<table width=\"100%\" border=\"0\"> no review yet </table>"
   end #if !reviewArray.nil?
  end #def TaobaoGeneral.assembleReviewHtmlDesc(myid)
  
  
  
  def TaobaoGeneral.assembleFullHDescHtml(descHtml,reviewArray,sellerid,sellerRankImg, \
                                          sellerReputationRate, the30dayssold, thisItemScore,thisItemScoredTime)
    
    reviewtablecode=self.assembleReviewHtmlDesc(reviewArray)
    
    fullhtml= "<table width=\"100%\" height=\"100%\" border=\"0\" bgcolor=\"#EAEEFD\">  <tr>    <td width=\"163\" height=\"37\" valign=\"bottom\"><p><strong>Seller's</strong><strong> Rate</strong></p></td>    <td width=\"272\" valign=\"bottom\">  "
    
    
    
    #puts "regday:"+regday.to_s+"end"
    #if !(regday.to_s=="0000-00-00".to_s or regday.to_s=="")
   # fullhtml= fullhtml + "#{sellerid} ( #{sellerReputationRate}% positive feedback)</td>"
    fullhtml= fullhtml + "<img src=\"#{sellerRankImg}\" border=\"0\"> with #{sellerReputationRate} positive feedback</td>"
    fullhtml= fullhtml + " <td></td> </tr> " 
    fullhtml= fullhtml +  " <tr valign=\"bottom\">    <td width=\"163\" height=\"34\"><strong>Store's Rate</strong></td>"
    fullhtml= fullhtml + "  <td> #{thisItemScore} by #{thisItemScoredTime} Reviews (full mark is 5)</td> "
    fullhtml= fullhtml + "<td>30 Days Sold: #{the30dayssold}</td>"
    
    #else
    #  puts "regday: is 0000, will not show in description html code"
    #end #if !(regday.to_s=="0000-00-00".to_s)              
    
        
 #   if !(reviewtablecode=="")
 #     fullhtml= fullhtml+"   </td>    </tr>  <tr>    <td width=\"163\" valign=\"top\"><p><strong>Reviews</strong></p><p>*last 20 records</p></td>\n    <td>"
  #    fullhtml= fullhtml + reviewtablecode+ "</td>\n  </tr>\n"
  #  end  #if !filestablecode==""
    
      #fullhtml= fullhtml+"  <tr>    <td colspan=\"3\" valign=\"top\"><p><strong>Reviews:</strong></p>#{reviewtablecode}"
    fullhtml= fullhtml+"  <tr><td colspan=\"3\" valign=\"top\"><p><strong>Reviews:</strong></p>#{reviewtablecode}</td></tr>"

    
    
    fullhtml= fullhtml+"  <tr><td colspan=\"3\" valign=\"top\"><p><strong>Discription:</strong></p>#{descHtml}</td></tr>"
    
    
  
    

    
    fullhtml= fullhtml + "</table>\n\n"
    
   #  file="c:/tmp/file.txt"
    # Misc.saveTxt2File(fullhtml,file)
     
     return fullhtml
    
    #puts fullhtml
    
  end #def TaobaoGeneral.assembleFullHDescHtml(myid)
  
  
  
  
  def TaobaoGeneral.insertProduct(odbc,myID,products_id,products_quantity, \
    products_image,products_price,products_weight,categories_id)             
    
    products_id=products_id
    products_type="1"
    products_quantity=products_quantity
    products_model="NULL"
    products_image=products_image
    products_price=products_price
    
    products_virtual="0"
    products_date_added=Misc.datenow()
    products_last_modified=""
    products_date_available="NULL"
    products_weight=products_weight
    products_status="1"
    products_tax_class_id="0"
    manufacturers_id=self.getManIDbyCatID(odbc,categories_id)
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
    
    
    
    Misc.dbprocessCommon(odbc, sql1) 
    return true
    
  end #def TaobaoGeneral.insertProduct()
  
  
  def TaobaoGeneral.insertProducts_description(odbc,myid, products_id,products_name,products_description,products_url)
    #products_id="3"
    #products_description="pro's desc"
    #products_name="prod's name"
    
    language_id="1"
    #product url
    products_url=products_url
    products_viewed="0"
    # products_seo_url=""
    
    
    
    products_name=Misc.txt2Sql(products_name)
    products_description=Misc.txt2SqlNotRemoveDBCS(products_description)
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
    
    
    
 #    Misc.saveTxt2File(sql2,"file.txt")
  #  if self.hasSoftname(odbc,products_name).to_s == "0".to_s and self.hasId_products_description(odbc,products_id).to_s=="0" and self.hassoftname_description(odbc,products_name).to_s=="0"
      
      #Misc.dbprocessCommonUTF8FromFile(odbc,sqldb,user,pwd,sql)
    Misc.dbprocessCommonUTF8FromFile(odbc,odbc,"root","fav8ht39",sql2)

 #   else
  #    puts products_name.to_s + " have already in table products_description "
 #   end #if Zencart.hasSoftname(products_name).to_s == "0".to_s
         return true

  end #def TaobaoGeneral.insertProducts_description()
  
  def TaobaoGeneral.insertProducts_to_categories(odbc,insertOscPID,categories_id)
    
    if categories_id.nil?
      categories_id="23" #23 is others 
    end #  if categories_id.nil?
    
    sql3="INSERT INTO `products_to_categories` (`products_id`, `categories_id`) VALUES ("
    sql3=sql3+ "'" + insertOscPID+ "'" +", "
    sql3=sql3+ "'" + categories_id+ "'" 
    sql3=sql3+");"
    
    
   # if self.hasId_products_to_categories(odbc,insertOscPID).to_s == "0".to_s
      Misc.dbprocessCommon(odbc,sql3)
   # else
   #   puts "id"+insertOscPID +" already existed in table products_to_categories"
   # end #if self.hasId_products_to_categories
        return true

  end #def TaobaoGeneral.insertProducts_to_categories(insertOscPID,categories_id)
  
  
  
  
  ########### FUNCTION INSERT ZENCART END ##############################
  
  
    
  # used when parse a store, the page list all the items in the store.
  def TaobaoGeneral.getthisPageItemsArray(ie,pageurl)
    ie.goto(pageurl)
    
    itemlis=[]
    rtnURLArray=[]
    itemlis=ie.ul(:class,"shop-list").lis
    itemlis.each{|li|
      rtnURLArray << li.link(:class,"permalink").href
    }
    #ie.close
    puts rtnURLArray
    return rtnURLArray
  end #def TaobaoGeneral.getthisPageItemsArray(pageurl)
  
  
  
  
  def TaobaoGeneral.handleOnePage(thisPageItemsURLArray,pageNumber)
    
    thisPageItemsURLArray.each { |taobaoItemURL| 
    noHTTPtaobaoItemURL=self.noHTTPURL(taobaoItemURL)
    
      if (self.hasTaobaoURL(taobaoItemURL).to_s=="0") 
        puts ""
        print "+++++ START, " 
        puts (thisPageItemsURLArray.index(taobaoItemURL)+1).to_s + "/" + thisPageItemsURLArray.length.to_s + " items of this page is processing, page #{pageNumber}"
        self.parseOneProduct(noHTTPtaobaoItemURL)
      else
        puts "URL "+taobaoItemURL+" already existed in zencart.tbgeneral"
      end     
    } #thisPageItemsURLArray.each { |taobaopid| 
  end #def TaobaoGeneral.handleOnePage(thisPageItemsURLArray)
  
  
  
 
#return 1 if give taobaoItemURL existed.
#return 0 if give taobaoItemURL not existed. 
#the url give should with out "http://"
  def TaobaoGeneral.hasTaobaoURL(taobaoItemURLWithoutHTTP)
   # sql= "SELECT count(*) FROM `products_description` WHERE `products_url` = \'http://item.taobao.com/item.htm?id=3172088135\' "
    sql= "SELECT count(*) FROM `products_description` WHERE `products_url` = \'#{taobaoItemURLWithoutHTTP}\' "
    rtn=Misc.dbshowCommon("zencart.tbgeneral",sql)
    
    rtn="1" if rtn.to_s != "0"
    
    return rtn

  end  #TaobaoGeneral.hasTaobaoURL(taobaoItemURL)
  
  
  
### return url with out http://
def TaobaoGeneral.noHTTPURL(httpurl)  
 rtn =httpurl.downcase.gsub(/^http:\/\//,"")
 return rtn
end


### 
def TaobaoGeneral.getCatNamebyCatID(odbc,catID)
  catID=catID.to_s
  sql="SELECT `categories_name` FROM `categories_description` WHERE `categories_id` = #{catID}"
  rtn=Misc.dbshowCommon(odbc,sql)
  #puts rtn
  if !rtn.nil?
    return rtn
  else
    return ""
  end #  if !products_url.nil?
end #def TaobaoGeneral.getCatNamebyCatID(catID)


###


def TaobaoGeneral.getManuIDByName(odbc,manName)
  manName=manName.to_s
  sql="SELECT `manufacturers_id`  FROM `manufacturers`  WHERE `manufacturers_name` LIKE '#{manName}'" 
 
 rtn=Misc.dbshowCommon(odbc,sql)
  if !rtn.nil?
    return rtn
  else
    return ""
  end #  if !products_url.nil?
end  #def TaobaoGeneral.getManuIDByName(manName)

###
def TaobaoGeneral.getManIDbyCatID(odbc,catID)
  catID=catID.to_s
  catName=self.getCatNamebyCatID(odbc,catID)
  catKeyword=catName.split[0]  #cat Must in format "Keyword other words", such as "Gucci bag"
  
  manufacturers_name=catKeyword
  manufacturers_id = self.getManuIDByName(odbc,manufacturers_name) 
 
 return manufacturers_id
end #def TaobaoGeneral.getManIDbyCatID(catID)




  
 ##### START OF PARSE ONE PRODUCT  
 
 def TaobaoGeneral.parseOneProduct(link, categories_id = "106")
begin #begin of rescue
   Misc.close_all_windows
   
   puts "\n\n\nprocessing  #{link}"
   taobaoItemURLWithoutHTTP=self.noHTTPURL(link)
   
     if (self.hasTaobaoURL(taobaoItemURLWithoutHTTP).to_s!="0") 
       puts "URL "+taobaoItemURLWithoutHTTP[0..5]+" already existed in zencart.tbgeneral"
       return link
     end
   

ie= Watir::Browser.new
#wait 30 seconds for page load.
Cmm.launchIEwithTimeout(ie,link,30)  



odbc="zencart.tbgeneral"
insertOscPID=products_id=myid= (self.getMaxPID(odbc).to_i+1).to_s



puts "parse review"
hReview=self.ParseReview(ie)

puts "parse description"
hDesc=self.ParseDescription(ie)





sqlDelProDescription="DELETE FROM  `products_description` WHERE  `products_id` = #{insertOscPID}"
sqlDelPro2cat="DELETE FROM  `products_to_categories` WHERE  `products_id` = #{insertOscPID}"

sqlDelReview="DELETE FROM  `reviews` WHERE  `products_id` = #{insertOscPID}"
#sqlDelReviewD="DELETE FROM  `reviews_description` WHERE  `products_id` = #{insertOscPID}"

Misc.dbprocessCommon(odbc,sqlDelProDescription)
Misc.dbprocessCommon(odbc,sqlDelPro2cat)
Misc.dbprocessCommon(odbc,sqlDelReview)
#Misc.dbprocessCommon(odbc,sqlDelReviewD)


exchangeRate=4.0

  descHtml=    hDesc["desc"]


 #### start format desc
  #desc= "      <p>     </p>     <p>      </p> <br> <br>  <br>    </br></br></br>   </br>  </br>  </br> "
 
 
 a=descHtml
 a=Cmm.mergeDupChrContinuesTag(a, "<br>")
 a=Cmm.mergeDupChrContinuesTag(a, "</br>")
 a=a.gsub(/<p>\s*<\/p>/,"<p></p>")
 a= a.gsub("<p><\/p>","")
 a=a.gsub(/\s+/," ")
  
 while a.include?('</br></br>')  
  a=a.gsub('</br></br>','</br>')
 end
### end format desc 
  
  descHtml=a


  
  
  
  descHTML_localimg = self.replaceRemoteimgToLocalImg(descHtml, self.downloadImageInDescription(ie,myid))
  


  reviewArray=     hReview["reviewHtmlArray"]
  
  
  sellerid=     hDesc["sellid"]
  sellerRankImg=    hDesc["sellerRankImg"]
  sellerReputationRate=  hDesc["sellerReputationRate"]
  the30dayssold=   hDesc["the30dayssold"]
  thisItemScore=hReview["thisItemScore"]
  thisItemScoredTime=    hReview["thisItemScoredTime"]
  
  reviewSqlArr=hReview["thisItemReviewSqls"]
products_name= hDesc["productName"]
products_url=taobaoItemURLWithoutHTTP
products_description= self.assembleFullHDescHtml(descHTML_localimg,reviewArray,sellerid,sellerRankImg, \
                                          sellerReputationRate, the30dayssold, thisItemScore,thisItemScoredTime)








products_quantity= hDesc["inventory"]
products_image= self.dlimage(hDesc["TitleImageURL"],myid,"0").gsub(/^images\//,"")  #this is title image, image index number is '0'  

products_price=  (((hDesc["price"].to_i+hDesc["postage"].to_i)/exchangeRate).round).to_s 
products_weight=  hDesc["weight"]
categories_id=categories_id.to_s




if  self.insertProduct(odbc,myid,products_id,products_quantity, \
    products_image,products_price,products_weight,categories_id)             

then 
  if self.insertProducts_description(odbc,myid, products_id,products_name,products_description,products_url)
  then 
      hReview["reviewArray"].each{|thisReview|
      thisReviewerID=thisReview[0]
      thisReviewCont=thisReview[1][0]
      thisReviewDate=thisReview[1][1]
       reviews_id  =(self.getMaxReviewID(odbc).to_i+1).to_s 
     self.insertReviewToDB(odbc,products_id,thisReviewerID,thisReviewCont,thisReviewDate,reviews_id)
    }

  self.insertProducts_to_categories(odbc,insertOscPID,categories_id)
  self.insertTaobaoInfo(odbc,sellerid,sellerRankImg,sellerReputationRate,thisItemScore,thisItemScoredTime,products_id,the30dayssold,Misc.datenow)
  else
  puts "insertProducts_description failed"  
  end # if self.insertProducts_description
else
  puts "insertProduct failed"
end #if  self.insertProduct
ie.close

  rescue
  puts "processing encounter exception. skip this link"
end #rescure

return link

end #def TaobaoGeneral.parseOneProduct(link)
 
 
 ##### END OF PARSE ONE PRODUCT   
  
 
#===for taobao trends (top.taobao.com) certenn page
def TaobaoGeneral.handleTopOnePage(tbTopLink,tmpfile)
ie= Watir::Browser.new


ie.goto(tbTopLink)

   begin  
Watir::Wait.until(30){ie.div(:class,"items").exist?}

prdList=ie.div(:class,"items").lis
productsNumberInThisPage=prdList.length
arr=[]
(2..productsNumberInThisPage).each { |x|;
searchURL= prdList[x].links[1].href
arr << searchURL
#puts searchURL
}
ie.close
arr.each {|taobaoSearchURL|;  self.handleSearchResultPage(taobaoSearchURL,1,tmpfile) }
rescue
 puts "parse ie.div(:class,items) timeout 30sec" 
end



end

#===for the s.taobao search result page
#===oneOrMulti could be "all" ,"1", "10" etc, no more than the page listed items.
def TaobaoGeneral.handleSearchResultPage(taobaoSearchURL,oneOrMulti,tmpfile)
ie=Watir::Browser.new



ie.goto(taobaoSearchURL)

puts "wait list-content div appear"

Watir::Wait.until(30){ ie.div(:id,"list:content").exist? }


#puts taobaoSearchURL;
div=ie.div(:id,"list:content")
if !div.exist?
  puts "the search page does not contain any products"
  ie.close
  return
end


puts "wait list-view-enlarge div appear"
   Watir::Wait.until(30){div.ul(:class,"list-view-enlarge lazy-list-view").exist?}

lists=div.ul(:class,"list-view-enlarge lazy-list-view").lis


pstart=1
 if oneOrMulti.to_s.downcase=="all"
   pend=lists.length
    puts "has "+lists.length.to_s+" items, choose #{pend}items in the search result"
 end


if oneOrMulti.to_s.downcase!="all"
pend=oneOrMulti.to_i 
puts "has "+lists.length.to_s+" items, choose first #{pend} itmes in the search result"
end

linkarr=[]
(pstart..pend).each{|x| linkarr << lists[x].div(:class,"photo").links[1].href}

#puts linkarr;
#exit
ie.close



linkarr.each{|link| Misc.saveTxt2File(link,tmpfile);  puts "push #{link} to file #{tmpfile}"}
#linkarr.each{|link| puts link; self.parseOneProduct(link)}

end # def TaobaoGeneral.handleSearchResultPage(taobaoSearchURL,oneOrMulti)

  

def TaobaoGeneral.getTopPageList(tbTopCat1stPage)
#return all pages link in a certain Top category  
ie=Watir::Browser.new
ie.goto(tbTopCat1stPage)
 buttom=ie.div(:class,"page-bottom")
linkArr=buttom.links
catTopPageURLArr=[tbTopCat1stPage]
(1..(linkArr.length-1)).each{|oneLink2TopPageInThisCat| catTopPageURLArr << linkArr[oneLink2TopPageInThisCat].href}
ie.close
return catTopPageURLArr

end #def TaobaoGeneral.getTopPageList(1stTopPageURL)


  
  
def TaobaoGeneral.insertReviewToDB(odbc,products_id,reviewUserName,reviewContent,reviewDate,reviews_id)



 
   reviews_id=Misc.txt2SqlNotRemoveDBCS(reviews_id.to_s)
  
  customers_id="NULL"
  reviews_rating="5"
  last_modified="NULL"
  reviews_read="NULL"
  status="1"
  
  
  languages_id="1"
  reviews_text=Misc.txt2SqlNotRemoveDBCS(reviewContent)
  
  sql4="INSERT INTO `reviews` "
  sql4=sql4+"(`reviews_id`, `products_id`, `customers_id`, `customers_name`, `reviews_rating`, "
  sql4=sql4+"`date_added`, `last_modified`, `reviews_read`, `status`) VALUES (" 
  sql4=sql4+"'" + reviews_id+ "'" +", "
  sql4=sql4+"'" + products_id+ "'" +", "
  sql4=sql4+"'" + customers_id+ "'" +", "
  sql4=sql4+"'" + reviewUserName +"'" +", "
  sql4=sql4+"'" + reviews_rating+ "'" +", "
  sql4=sql4+"'" + reviewDate+ "'" +", "
  sql4=sql4+"'" + last_modified+ "'" +", "
  sql4=sql4+"'" + reviews_read+ "'" +", "
  sql4=sql4+ "'" + status+ "'" 
    sql4=sql4+");"
  
  sql5="INSERT INTO `reviews_description` (`reviews_id`, `languages_id`, `reviews_text`) VALUES ("
  sql5=sql5+"'" + reviews_id+ "'" +", "
  sql5=sql5+"'" + languages_id+ "'" +", "
    sql5=sql5+ "'" + reviews_text+ "'" 
    sql5=sql5+");"
  
 # p sql4
 
 # p sql5
   Misc.dbprocessCommonUTF8FromFile(odbc,odbc,"root","fav8ht39","#{sql4}#{sql5}")

  
  
  

end # TaobaoGeneral.insertReviewToDB(products_id,reviewUserName，reviewContent，reviewDate)

    

  
  
  
  

  
  
  
  
  
  def TaobaoGeneral.getAllReviewToHash(ie,reviewHash)
     #sometimes the review not load even "show-rate-table" exist
     
     
      puts "sleep 5 seconds"
      sleep 5
      
      Watir::Wait.until(30){ie.table(:class,"show-rate-table").exist?}

    reviewTable=ie.table(:class,"show-rate-table")
    

    
    #====start parse 
    thisPageReviewRecordsEndNumber=reviewTable.rows.length-1
    
     (2..thisPageReviewRecordsEndNumber).each{|rowNumber|
      #puts rowNumber
      Watir::Wait.until(30){ reviewTable[rowNumber][1].exist?}
      Watir::Wait.until(30){ reviewTable[rowNumber][2].exist?}

          

      reviewContent= reviewTable[rowNumber][1].p(:index,1).text
      reviewDate=reviewTable[rowNumber][1].span(:index,1).text.sub("[","").sub("]","")
      
      
      if reviewTable[rowNumber][2].links.length==2
        reviewUserName=reviewTable[rowNumber][2].link(:index,1).text
      elsif    reviewTable[rowNumber][2].links.length==0  #buyer anonymous purchase
        reviewUserName=reviewTable[rowNumber][2].text.gsub("买家：","")
      else
        
        print "set ReviewUserName to NULL, link length: "
        print reviewTable[rowNumber][2].links.length.to_s
        print  reviewTable[rowNumber][2].links.length.to_s
       

        reviewUserName="NULL"
      end  
       print reviewUserName
      reviewHash[reviewUserName]=[reviewContent,reviewDate]
    }
    #====end parse 
    
    
    
    
    link=reviewTable.link(:text,"下一页 >>")
    if link.exist?
      puts "go to next review page"       
      link.click!
      self.getAllReviewToHash(ie,reviewHash)
    else      
      return reviewHash
    end
    
    
    
    
  end #  def TaobaoGeneral.getAllReviewToHash(ie,reviewHash)
 
  
  

 def TaobaoGeneral.getReviewWithENContentArr(ie)
     reviewArrayCN=self.getAllReviewToHash(ie,Hash.new).to_a
     
     
      arrayEleSpliter="MySpLiTeRNoCoNfUsE"
      
      allCNString=""
      reviewArrayCN.each{|oneRecordCN|  allCNString=allCNString+oneRecordCN[1][0]+arrayEleSpliter }
      
      Misc.saveTxt2File(allCNString,"c:/tmp/cnreview")
      allENString=Misc.googletranslatetoenWeb(allCNString) 
      allENString=allENString.gsub(" ^ + ^ ","^+^"  )   
      
      eNReviewContArr=allENString.split(arrayEleSpliter)
      
      
      
      if reviewArrayCN.length==eNReviewContArr.length
      (0..reviewArrayCN.length-1).each{|x| reviewArrayCN[x][1][0]=eNReviewContArr[x]}
      end
       
       return reviewArrayCN
      
end #  def TaobaoGeneral.getReviewWithENContentArr(ie)


def TaobaoGeneral.getReviewHtmlArray(reviewArray)
    
    rtnPageReviewArr=[]
   
    reviewArray.each{|thisReview|
       thisReviewerID=thisReview[0]
     thisReviewCont=thisReview[1][0]
     thisReviewDate=thisReview[1][1]
    
       rtnPageReviewArr << ["#{thisReviewCont}. [#{thisReviewDate}] ",thisReviewerID]
    }

return rtnPageReviewArr
end  #def TaobaoGeneral.getReviewHtmlArray(reviewArray)


 def TaobaoGeneral.insertTaobaoInfo(odbc,sellerid,sellerRankImg,sellerReputationRate,thisItemScore,thisItemScoredTime,products_id,the30dayssold,datenow)
    
     sellerReputationRate=sellerReputationRate.gsub("%","")
    sql6="INSERT INTO `zencart.tbgeneral`.`taobao_info` (`seller_id`, `seller_rankimage`, `seller_positivefeedbackrate`, `store_ratescore`, `store_ratedtime`, `products_id`, `sold_in30day`, `lastupdate`) VALUES ("
  
    sql6=sql6+ "'" + sellerid+ "'" +", "
    sql6=sql6+ "'" + sellerRankImg+ "'" +", "
    sql6=sql6+ "'" + sellerReputationRate+ "'" +", "
    sql6=sql6+ "'" + thisItemScore+ "'" +", "
    sql6=sql6+ "'" + thisItemScoredTime+ "'" +", "
    sql6=sql6+ "'" + products_id+ "'" +", "
    sql6=sql6+ "'" + the30dayssold+ "'" +", "
    sql6=sql6+ "'" + datenow+ "'" 
    sql6=sql6+");"
    
    #puts sql6
    Misc.dbprocessCommonUTF8FromFile(odbc,odbc,"root","fav8ht39",sql6)

         return true

  end #def TaobaoGeneral.insertTaobaoInfo
    
    
  def TaobaoGeneral.saveLinkArrOfOneSearchPageToFile(oneSearchPageURL,filename)
    ie=Watir::Browser.new
    
    url=oneSearchPageURL.gsub("style=grid","style=list")
    url=url+"&style=list"
    ie.goto(url)
    
   # if !ie.div(:id,"list:content").ul(:class,"list-view").exist?
   #   puts "Err:div list:content not exist, please check "
   #   return
   # end
    
     objCombineProduct=ie.div(:id,"list:content").link(:id,"J_CombineProduct")
    if objCombineProduct.exist?
      objCombineProduct.click
    end
    
    
  
   # b=ie.div(:id,"list:content").ul(:class,"list-view").lis 
    b=ie.div(:id,"list:content").lis
   i=0
   rtnarr=[]
   b.each{|pdiv|
  
    if pdiv.div(:class,"photo").exist?
      i=i+1
      print i
       puts link=pdiv.div(:class,"photo").link(:index,1).href
       Misc.saveTxt2File(link,filename)
       rtnarr << link
    end
  } #b.each{|pdiv|
  


  ie.close
  return rtnarr


    
  end  #  def TaobaoGeneral.getLinkArrOfOneSearchPage(oneSearchPageURL)

   
  def TaobaoGeneral.getLinkArrOfFirstXSearchPage(urlBase,firstNpage)
    #urlbase is the entry page of search keywork (first back page of search)
    # retunr first give page url of next search pages
     ie=Watir::Browser.new
    firstNpage=firstNpage.to_i
    url=urlBase.gsub("style=grid","style=list")
    url=url+"&style=list"
    ie.goto(url)
    rtnarr=[]
    
    allLinks=ie.div(:class,"page-bottom").links
    
     itemsPerPage= allLinks[1].href.split("&s=")[1].split("#")[0]
     
     firstNpage.times {|x|
     
     thisPageStartNumber= (x.to_i)*(itemsPerPage.to_i) 
     new="s="+thisPageStartNumber.to_s+"#"
     rtnarr << allLinks[1].href.gsub(/s=\d.*#/,new)
     
     print x
     puts allLinks[1].href.gsub(/s=\d.*#/,new)
     
     }
     
     ie.close
     return rtnarr
     
  end #def TaobaoGeneral.getLinkArrOfFirstXSearchPage(urlBase)

    
end #module Taobao