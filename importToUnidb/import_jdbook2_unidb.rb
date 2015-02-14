# encoding: utf-8
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'iv'
require 'misc'
require 'DBI'
require "watir"

#require "watir-webdriver"

 $HIDE_IE = true
  def hasJdId(id)
 
    sql="SELECT count( * ) \
FROM `main` \
WHERE `softuid` ='"
    sql=sql+id.to_s
    sql=sql+"';"
    #puts sql
    s=Misc.dbshow(sql)
    puts s
 return s 
  end  #def hasJdId(id)


def parse_a_book(id,pageid)

 if (hasJdId(id).to_i >0)
   s="the ID "+ id.to_s + " has been processed"
   puts s
   return
 end


  b=Watir::Browser.new 
  #b=Watir::Browser.new :firefox
 url= "http://spu.jd.com/"+id.to_s+".html"
  b.goto(url)

  puts "\n====in url "+url
  puts "in page "+pageid.to_s
  
  if not b.div(:class,"breadcrumb").exist?
    puts "not a valid product"
    return
  end
  
  if not b.div(:class,"breadcrumb").html.include?("channel.jd.com/1713-4855")
    puts "not a english book"
    `taskkill /F  /IM   iexplore.exe /T`
    return
   end
  
  if not b.div(:class,"breadcrumb").html.include?("1713-4855-4876") # Professional & Technical
    puts "not a  Professional & Technical book"
    `taskkill /F  /IM   iexplore.exe /T`
    return
  end
  
    
  
  
  
 #  if not b.div(:class,"breadcrumb").html.include?("1713-4855-4877") #reference
 #  puts "not a english book"
 #  `taskkill /F  /IM   iexplore.exe /T`
 #  return
 #  end

  if not b.body(:id,"book").exist?
    puts "body not exist"
    `taskkill /F  /IM   iexplore.exe /T`
    return
  end

  if not b.div(:id,"introduction").exist?
    puts "introduction not exist"
    `taskkill /F  /IM   iexplore.exe /T`
    return
  end

  if not b.div(:id,"name").exist?
    puts "name not exist"
    `taskkill /F  /IM   iexplore.exe /T`
    return
  end

  softname=b.div(:id, "name").text
  softname=Iv.removeDBCS_2(softname)
  puts "Bookname:"+softname

  s=b.ul(:id,"summary")
  
  author=""
  published_date=""
  publisher=""
isbn=""
description=""
img_src=""

if s.li(:class, "fore1").div(:class,"dd bfc").exist?
  author=s.li(:class, "fore1").div(:class,"dd bfc").text
  author=Iv.removeDBCS_2(author)
  puts "author:"+author
  else
  puts "no author"; `taskkill /F  /IM   iexplore.exe /T`; return
end

if s.li(:class, "fore2").div(:class,"dd bfc").exist?
  published_date=s.li(:class, "fore2").div(:class,"dd bfc").text
  puts "published_date:"+published_date
   else
   puts "no published_date";  `taskkill /F  /IM   iexplore.exe /T`;;
   return
  
end 

if s.li(:class, "fore3").div(:class,"dd bfc").exist?
  publisher= s.li(:class, "fore3").div(:class,"dd bfc").text
  publisher=Iv.removeDBCS_2(publisher)
  puts "publisher:"+publisher
   else
   puts "no publisher";
    `taskkill /F  /IM   iexplore.exe /T`;
   return  
end

if s.li(:class, "fore4").div(:class,"dd bfc").exist?
  isbn= s.li(:class, "fore4").div(:class,"dd bfc").text
  puts "isbn:"+isbn
     else
   puts "no isbn";
    `taskkill /F  /IM   iexplore.exe /T`;
   return
end

if  s.li(:class, "fore5").div(:class,"dd bfc").exist?
  book_price= s.li(:class, "fore5").div(:class,"dd bfc").text
  book_price=~/(\d+)/
  book_price= ($1.to_i/4.5).to_i.to_s  #HUILV 1USD=4.5CNY
  puts "Book_price:"+book_price
     else
   puts "no price";
    `taskkill /F  /IM   iexplore.exe /T`;
   return
end

  if book_price == ''
    puts "empty book_price, means no seller selling the book"
    `taskkill /F  /IM   iexplore.exe /T`
    return
  end

  description=b.div(:class,"last").text
  description=Iv.removeDBCS_2(description)
  s=description
  puts  "description:"+description

  img_src=b.div(:id,"spec-n1").img.src
  puts "img_src"+img_src

  #  require 'open-uri'
  #  open('image'+id.to_s+'.png', 'wb') do |file|
  #    file << open(img_src).read
  #  end
  `taskkill /F  /IM   iexplore.exe /T`

  h=Hash[
  "isbn"=>isbn,
  "book_price"=>book_price,
  "description"=>description,
  "img_src"=>img_src,
  "author"=>author,
  "published_date"=>published_date,
  "publisher"=>publisher,
  "Bookname"=>softname,
  "softid"=>id.to_s
  ]
  
  SaveId(h)

end # parse_a_book(url,id,overwrite)

def SaveId(bookHash=nil)
#bookHash=Hash[
#  "isbn"=>"isbn",
#  "Book_price"=>"123",
#  "description"=>"description",
#  "img_src"=>"https://www.google.com/images/srpr/logo11w.png",
#  "author"=>"author",
#  "published_date"=>"published_date",
#  "publisher"=>"publisher",
#  "Bookname"=>"softname",
#  "softid"=>"12345"
#  ]

isbn=bookHash["isbn"].to_s
author=bookHash["author"].to_s
published_date=bookHash["published_date"].to_s
publisher=bookHash["publisher"].to_s

softname=bookHash["Bookname"].to_s
description=bookHash["description"].to_s
img_src=bookHash["img_src"].to_s
   sid=bookHash["softid"].to_s
   book_price=bookHash["book_price"].to_s
   
   
  softid=sid.to_s
  overwrite=false if (overwrite.nil? or overwrite != true)
  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s

  #SQL START
  if ((Misc.hasSoftName(softname.to_s).to_s != "0") and (overwrite == true))
    tmpId=Misc.getMyID(softname.to_s)
    Misc.deleteBySID(tmpId)
  end

  if Misc.hasSoftName(softname.to_s).to_s=="0"  #9iv does not apply Misc.hasID(softid.to_s).to_s=="0"



    descText=""

descText=  "ISBN: "+isbn+"\r\n"
descText=descText +  author+"\r\n"
descText=descText  +  publisher+"    "
descText=descText  +  published_date +"\r\n" 
descText=descText +  description+"\r\n"
 
  descHtml=descText

    sql1="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
    sql1=sql1+"VALUES ("
    sql1=sql1 + \
    newMyID +",'"  \
    + Misc.txt2Sql(descHtml)+"','"  \
    + Misc.txt2Sql(descText)+"'"  \
    +"); "

    #??
    imgarr=[]

    imgarr << img_src

    fileCount="0"

    sql0="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime`,`price` ) "
    sql0=sql0+"VALUES ("
    sql0=sql0 + \
    newMyID +",'"  \
    + "jd"+"','"  \
    + Misc.txt2Sql("books")+"','"  \
    + Misc.txt2Sql(softid.to_s)+"','"  \
    + Misc.txt2Sql(softname)+"','"  \
    + Misc.txt2Sql("0000-00-00")+"','"  \
    + Misc.txt2Sql("0")+"','"   \
    + Misc.txt2Sql("Byte")+"','"  \
    + Misc.txt2Sql("0")+"','"   \
    + Misc.datenow()+"','"   \
    + Misc.txt2Sql(book_price)+"'" \
    +"); "

    Misc.dbprocess(sql0)
    puts "inserted " +softname.to_s+"to Main table"

    Misc.insert2image(newMyID,imgarr)
    #Misc.googleSearchTitleImg(newMyID)
    #Misc.insert2featured(newMyID)

    #if !Misc.hasmyIDDescription(newMyID)==
    if Misc.hasmyIDDescription(newMyID).to_s == "0".to_s

      Misc.dbprocess(sql1)
      puts "inserted to description table"

    else
      puts newMyID+"have existed in description table"
    end #if !Misc.hasmyIDDescription(newMyID)

  else # if Misc.hasSoftName(softname.to_s).to_s=="0"
    puts "have exists softname: "+softname.to_s
  end # if  Misc.hasSoftName(softname.to_s).to_s=="0"

end


#SaveId();







def parse_a_page(url,pageid)
  b=Watir::Browser.new 
  #b=Watir::Browser.new :firefox

  b.goto(url)
  
   if not b.div(:id,"plist").exist?
    puts "no products in page"
    return
  end
  
  pl=b.div(:id,"plist")
  
  d=pl.divs(:class, "item")

  skus=Array.new()
  
 
  d.each do |x|
   x.html=~/sku="([0-9]+)"/;
  sku=$1;
  skus.push(sku)  
  end
  
# `taskkill /F  /IM   iexplore.exe /T`
 `taskkill /F  /IM   iexplore.exe /T`

  skus.each do |sku|
    parse_a_book(sku,pageid)
  end
  


end

#professional  only

page=(1950..2000)
page.each do |i|
  uri="http://list.jd.com/1713-4855-4876.html?s=15&t=1&p="+i.to_s+"&JL=6_0_0";
  puts "in page id "+i.to_s
  parse_a_page(uri,i)
end
exit






 
