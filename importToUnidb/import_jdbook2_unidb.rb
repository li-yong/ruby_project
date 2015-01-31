$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'iv'
require 'misc'
require 'DBI'
require "watir"

#require "watir-classic"

def parse_a_book(url,id,overwrite)

  b=Watir::Browser.new

  b.goto(url)

  puts "\n====in url "+url

  if not b.body(:id,"book").exist?
    puts "body not exist"
    b.close
    return
  end

  if not b.div(:id,"introduction").exist?
    puts "introduction not exist"
    b.close
    return
  end

  if not b.div(:id,"name").exist?
    puts "name not exist"
    b.close
    return
  end

  softname=b.div(:id, "name").text
  puts "Bookname:"+softname

  s=b.ul(:id,"summary")

  author=s.li(:class, "fore1").div(:class,"dd bfc").text
  puts "Author:"+author

  puts published_date=s.li(:class, "fore2").div(:class,"dd bfc").text
  puts "Published_date:"+published_date

  publisher= s.li(:class, "fore3").div(:class,"dd bfc").text
  puts "Publisher:"+publisher

  isbn= s.li(:class, "fore4").div(:class,"dd bfc").text
  puts "Isbn:"+isbn

  book_price= s.li(:class, "fore5").div(:class,"dd bfc").text
  book_price=~/(\d+)/
  book_price= ($1.to_i/4.5).to_i.to_s  #HUILV 1USD=4.5CNY
  puts "Book_price:"+book_price

  if book_price == ''
    puts "empty book_price, means no seller selling the book"
    b.close
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
  b.close

  h=Hash[
  "Isbn"=>isbn,
  "Book_price"=>book_price,
  "description"=>description,
  "img_src"=>img_src,
  "Author"=>author,
  "Published_date"=>published_date,
  "Publisher"=>publisher,
  "Bookname"=>softname,
  "softid"=>id.to_s
  ]
  
  SaveId(h)

end # parse_a_book(url,id,overwrite)

def SaveId(bookHash=nil)
bookHash=Hash[
  "Isbn"=>"isbn",
  "Book_price"=>"123",
  "description"=>"description",
  "img_src"=>"https://www.google.com/images/srpr/logo11w.png",
  "Author"=>"author",
  "Published_date"=>"published_date",
  "Publisher"=>"publisher",
  "Bookname"=>"softname",
  "softid"=>"12345"
  ]

softname=bookHash["Bookname"].to_s
description=bookHash["description"].to_s
img_src=bookHash["img_src"].to_s
   sid=bookHash["softid"].to_s
   
   
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


    descHtml=description
    descText=description

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
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
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
    + Misc.datenow()+"'" \
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


SaveId();

num=(19163003..19165000)

num.each do |i|
  url= "http://spu.jd.com/"+i.to_s+".html"

  parse_a_book(url,i,nil)

end

