# -*- coding: utf-8 -*-
$:.unshift File.expand_path(File.dirname(__FILE__) + "/./lib")

$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"







=begin


#require "watir"
#require "verycd"
require "Misc"
require "osc"

imglink="http://image-4.verycd.com/f623da0f4f1fa7b3a1685dc87b3d0f0089137(600x)/thumb.jpg"
downfilename=""


b=imglink.split("/")
site=b[2]
imgpath="/"+b[3..b.length].join("/")


require 'net/http'

Net::HTTP.start(site) { |http|
  resp = http.get(imgpath)
  open("fun.jpg", "wb") { |file|
    file.write(resp.body)
   }
}
puts "Yay!!"
=end


def traverse_dir(file_path)
    if File.directory? file_path
      puts "Dir:"+file_path
      Dir.foreach(file_path) do |file|
        if file!="." and file!=".."
        traverse_dir(file_path+"/"+file)
        end
      end
    end
  end
 
traverse_dir "c:/temp"