# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
 
require "netfirms"


def usage()
  puts "$0 <|wp_files24x7|myvpsoft|>"
end


target=ARGV[0].to_s

if target == "wp_files24x7"
  Netfirms.update_wp_files24x7()  
elsif target == "netfirms"
  Netfirms.update_myvpsoft()
else
  usage()
end

    