require "fileutils"
# -*- coding: utf-8 -*-
module GNC
  require "misc"
  require "iv"
  require "cmm"
  #require 'FileUtils'
  require 'ftools'
  require 'taobaoGeneral'
  

  
    def GNC.getProductCat(ie)
    
  end  #def GNC.getProductCat(ie)
  
  
  def GNC.getProductName(ie)
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
  end  #def GNC.getProductName(ie)
  
    
    
  def GNC.getTitleImageURL(ie)
    if  ie.image(:id,"J_ImgBooth").exist?
      return  ie.image(:id,"J_ImgBooth").src
    else
      return nil
    end
  end  #def GNC.getTitleImageURL(ie)
  
  
  
  def GNC.getPrice(ie)    
   
   #gold card price
   obj=ie.div(:id,"mainContent").p(:class,"margintop10 cardText")
   if obj.exist?
     price=obj.text
     price=price.split("$")[-1].split[0]     
     return price
   end
   
   #buy price
   obj= ie.div(:id,"mainContent").p(:class,"priceBlock").span(:class,"priceNow")
   if  obj.exist?
       price=obj.text
       price=price.split("$")[-1]
       return price
    end
    
   obj= ie.div(:id,"mainContent").p(:class,"priceBlock").span(:class,"priceWas")
   if  obj.exist?
       price=obj.text
       price=price.split("$")[-1]
       return price
       
    end    
     
 
      puts "parse price not found any obj,set price to 0"
      price="0"
  end  #def GNC.getPrice(ie)

      
      
  
  def GNC.getDesc(ie)
    desc=ie.dd(:id,"tab01Contents").div(:class,"prodTabContentBlockInside").text

        #desc=Sanitize.clean(desc,Sanitize::Config::RESTRICTED)
        
 
    
        #desc=Misc.googletranslatetoenWeb(desc,'http://translate.google.com/#en|zh-CN|')

    #</ td  > ==> </td>
    desc=desc.gsub(/<\/[\s\t\r\n\f]*/i,"</")  #remove end white space "</  "==> "</"
    desc=desc.gsub(/[\s\t\r\n\f]*>/i,">")   #remove begin white space "  >"==>  >"
    

    
    desc=Sanitize.clean(desc,  :output => :html,  :elements => ['p', 'b', 'i', 'strong', 'br','li', 'img'])
    desc=Sanitize.clean(desc, Sanitize::Config::RELAXED)   
    desc=  Sanitize.clean(desc, 
                 :elements => ['p', 'br', 'img','table','td','tr'],
                 :attributes => {'img'=> ['src']} )
#    desc=Sanitize.clean(desc)

    return desc
  end  #def GNC.getDesc(ie)
  
  def GNC.getsuppFacts(ie)
        rtn=ie.dd(:id,"tab04Contents").div(:class,"prodTabContentBlockInside").text    
  end #  def GNC.getsuppFacts(ie)


  def GNC.getLabImg(ie)
        rtn=ie.dd(:id,"tab052Contents").div(:class,"prodTabContentBlockInside").image(:index,1).src    
  end #  def GNC.getLabImg(ie)

  def GNC.ParseDescription(ie) 
    
    hDesc={}
    hDesc["desc"]= self.getDesc(ie)
        hDesc["suppFacts"]= self.getsuppFacts(ie)
        hDesc["LableImg"]= self.getLabImg(ie)

    hDesc["price"]=self.getPrice(ie)
    hDesc["productName"]=ie.div(:class,"productDescriptionBlock").h2(:index,1).text
    hDesc["productNameVice"]=ie.div(:class,"productDescriptionBlock").html[0..200].split("</H2>")[1].split("<SMALL>")[1].split("</SMALL>")[0]
    hDesc["productCode"]=ie.div(:class,"productDescriptionBlock").p(:class,"textitemCode").text
    
    
    hDesc["titleImageURL"]=ie.div(:class,"productImageBlock").image(:id,"mainProductImage").src
    hDesc["cat"]=ie.div(:id,"breadcrumbs").text
    
    return hDesc
  end #  def GNC.ParseDescription(ie)        
  
  
  
  
  def GNC.handleOnePage(thisPageItemsURLArray,pageNumber)
    
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
  end #def GNC.handleOnePage(thisPageItemsURLArray)
  
    
 
def GNC.getTopPageList(tbTopCat1stPage)
#return all pages link in a certain Top category  
ie=Watir::Browser.new
ie.goto(tbTopCat1stPage)
 buttom=ie.div(:class,"page-bottom")
linkArr=buttom.links
catTopPageURLArr=[tbTopCat1stPage]
(1..(linkArr.length-1)).each{|oneLink2TopPageInThisCat| catTopPageURLArr << linkArr[oneLink2TopPageInThisCat].href}
ie.close
return catTopPageURLArr

end #def GNC.getTopPageList(1stTopPageURL)

 
  def GNC.dlimage(imageURL,myid, imageIndexNumber)
    #save image to c:/ruby_project/image2 
    #      and Cdlimage:/wamp/www/zencSubsites/tbgeneral/images/image2/
    #return something like  image2/001/id1_1_T1r6RKXddBXXXPoHk__075428.jpg_310x310.jpg
   
    ## copy image file to zencart image folder
   # Cmm.saveHttpImg_branding(myid,imglink,folder,indexnumberofarray,i_timeout,i_imgSizeNoLessThan)
   # puts "========input GNC.dlimage is:"+imageURL
    
    filesrc=Cmm.saveHttpImg_branding(myid, imageURL,"image2",imageIndexNumber.to_s,30,0 )
    
     return imageURL if imageURL.index(/[^[:alnum:][:punct:] ]/) != nil  #return if imageURL has DBCS
     
    if !filesrc.include?("dlerr")
    filedst="C:/image/gnc/"
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
#    puts "========output GNC.dlimage is:"+rtn
    return rtn
    
  end #  def GNC.dlimage(imageURL,myid, imageIndexNumber)  

  
 def GNC.parseOneProduct(link, categories_id = "106")
begin #begin of rescue
   Misc.close_all_windows
   
   puts "\n\n\nprocessing  #{link}"
  gncItemURLWithoutHTTP=TaobaoGeneral.noHTTPURL(link)
   
#     if (TaobaoGeneral.hasTaobaoURL(taobaoItemURLWithoutHTTP).to_s!="0") 
#       puts "URL "+taobaoItemURLWithoutHTTP[0..5]+" already existed in zencart.tbgeneral"
#       return link
#     end
   

ie= Watir::Browser.new
#wait 30 seconds for page load.
Cmm.launchIEwithTimeout(ie,link,30)  



odbc="realdb"
myid= (Realdb.getMaxMyID(odbc).to_i+1).to_s



 

puts "parse description"
hDesc=self.ParseDescription(ie)



=begin

sqlDelProDescription="DELETE FROM  `products_description` WHERE  `products_id` = #{insertOscPID}"
sqlDelPro2cat="DELETE FROM  `products_to_categories` WHERE  `products_id` = #{insertOscPID}"

sqlDelReview="DELETE FROM  `reviews` WHERE  `products_id` = #{insertOscPID}"
#sqlDelReviewD="DELETE FROM  `reviews_description` WHERE  `products_id` = #{insertOscPID}"

Misc.dbprocessCommon(odbc,sqlDelProDescription)
Misc.dbprocessCommon(odbc,sqlDelPro2cat)
Misc.dbprocessCommon(odbc,sqlDelReview)
#Misc.dbprocessCommon(odbc,sqlDelReviewD)


exchangeRate=4.0
=end

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


  
  
  
#  descHTML_localimg = self.replaceRemoteimgToLocalImg(descHtml, self.downloadImageInDescription(ie,myid))
  


#  reviewArray=     hReview["reviewHtmlArray"]
  
  
#  sellerid=     hDesc["sellid"]
#  sellerRankImg=    hDesc["sellerRankImg"]
#  sellerReputationRate=  hDesc["sellerReputationRate"]
#  the30dayssold=   hDesc["the30dayssold"]
#  thisItemScore=hReview["thisItemScore"]
#  thisItemScoredTime=    hReview["thisItemScoredTime"]
  
 # reviewSqlArr=hReview["thisItemReviewSqls"]
products_name= hDesc["productName"]
products_url=gncItemURLWithoutHTTP
products_description= self.assembleFullHDescHtml(descHTML_localimg,reviewArray,sellerid,sellerRankImg, \
                                          sellerReputationRate, the30dayssold, thisItemScore,thisItemScoredTime)








#products_quantity= hDesc["inventory"]
products_image= self.dlimage(hDesc["TitleImageURL"],myid,"0").gsub(/^images\//,"")  #this is title image, image index number is '0'  

products_price=  hDesc["price"].to_s 
products_weight=  hDesc["weight"]
category=  hDesc["cat"]



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

end #def GNC.parseOneProduct(link)  
  
  
end #module GNC  