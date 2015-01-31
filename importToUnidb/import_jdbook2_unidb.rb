$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'iv'
require 'misc'
require 'DBI'
require "watir"
#require "watir-classic"


def parse_a_book(url,id)

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

  title=b.div(:id, "name").text
  puts "Bookname:"+title

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

end

num=(19163003..19165000)

num.each do |i|
  url= "http://spu.jd.com/"+i.to_s+".html"

  parse_a_book(url,i)

end

