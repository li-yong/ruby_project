 mysqldump -uroot  --opt  --add-drop-table  wp  myid_postid   wp_posts wp_term_relationships  wp_postmeta >  C:\tmp\wp.sql

 
===
 
 ubuntu@ip-172-31-42-169:/var/www/io24x7.com/public_html/wp-content/uploads$ mv ~/image ./
ubuntu@ip-172-31-42-169:/var/www/io24x7.com/public_html/wp-content/uploads$ chmod -R 777 image/
ubuntu@ip-172-31-42-169:~$ unzip wp.zip
Archive:  wp.zip
  inflating: wp.sql
ubuntu@ip-172-31-42-169:~$ mysql -uroot -pnewpwd io24x7 < wp.sql
