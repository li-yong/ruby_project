

 SELECT * FROM `dlpathmap` ORDER BY `myID` DESC LIMIT 0 , 30;

delete  from description where myID=47700 ;
delete  from  dlpathmap where myID=47700 ;
 delete  from files where myID=47700 ;
delete  from  images where myID=47700 ;
 delete  from main where myID=47700 ;
 delete  from url where myID=47700 ;
 
 
 
 
SELECT * FROM `dlpathmap` ORDER BY `myID` DESC LIMIT 0 , 1;
SELECT * FROM `products` ORDER BY `products_id` DESC LIMIT 0 ,1;
 
 delete  from  dlpathmap where myID=47700 ; 
 
 delete from  `products_description` WHERE `products_id` = 41832  ;
delete FROM `products_attributes` WHERE `products_id` = 41832  ;
delete FROM `products_to_categories` WHERE `products_id` = 41832;
delete FROM `products` WHERE `products_id` = 41832;


