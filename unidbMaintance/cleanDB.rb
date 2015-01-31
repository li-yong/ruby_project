#this script clean unidb. remove entries from all other talbes that does not existed in main table.


# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
 
require 'misc'
 
 
#Misc. delete_from_db_by_vendor("9iv")
Misc.orphanDelete()