create database project



-- user table (for CRUD) activities
CREATE TABLE IF NOT EXISTS users (
	user_id INT auto_increment PRIMARY KEY, -- serial PRIMARY KEY,
	username VARCHAR(100),
	email VARCHAR(500),
	password VARCHAR(40) ,
	phone VARCHAR(30) 
);

-- import data into listings using file: project_listings_data.sql

CREATE TABLE IF NOT EXISTS `listing_raw` (
  `id` int(11) PRIMARY KEY,
  `listing_url` text,
  `scrape_id` double DEFAULT NULL,
  `last_scraped` text,
  `picture_url` text,
  `host_id` int(11) DEFAULT NULL,
  `host_url` text,
  `host_name` text,
  `host_since` text,
  `host_location` text,
  `host_response_time` text,
  `host_response_rate` text,
  `host_acceptance_rate` text,
  `host_is_superhost` text,
  `host_thumbnail_url` text,
  `host_picture_url` text,
  `host_neighbourhood` text,
  `host_listings_count` int(11) DEFAULT NULL,
  `host_total_listings_count` int(11) DEFAULT NULL,
  `host_verifications` text,
  `host_has_profile_pic` text,
  `host_identity_verified` text,
  `neighbourhood` text,
  `neighbourhood_cleansed` text,
  `neighbourhood_group_cleansed` text,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `property_type` text,
  `room_type` text,
  `accommodates` int(11) DEFAULT NULL,
  `bathrooms` text,
  `bathrooms_text` text,
  `bedrooms` text,
  `beds` int(11) DEFAULT NULL,
  `price` text,
  `minimum_nights` int(11) DEFAULT NULL,
  `maximum_nights` int(11) DEFAULT NULL,
  `minimum_minimum_nights` int(11) DEFAULT NULL,
  `maximum_minimum_nights` int(11) DEFAULT NULL,
  `minimum_maximum_nights` int(11) DEFAULT NULL,
  `maximum_maximum_nights` int(11) DEFAULT NULL,
  `minimum_nights_avg_ntm` int(11) DEFAULT NULL,
  `maximum_nights_avg_ntm` int(11) DEFAULT NULL,
  `calendar_updated` text,
  `has_availability` text,
  `availability_30` int(11) DEFAULT NULL,
  `availability_60` int(11) DEFAULT NULL,
  `availability_90` int(11) DEFAULT NULL,
  `availability_365` int(11) DEFAULT NULL,
  `calendar_last_scraped` text,
  `number_of_reviews` int(11) DEFAULT NULL,
  `number_of_reviews_ltm` int(11) DEFAULT NULL,
  `number_of_reviews_l30d` int(11) DEFAULT NULL,
  `first_review` text,
  `last_review` text,
  `review_scores_rating` double DEFAULT NULL,
  `review_scores_accuracy` double DEFAULT NULL,
  `review_scores_cleanliness` double DEFAULT NULL,
  `review_scores_checkin` double DEFAULT NULL,
  `review_scores_communication` double DEFAULT NULL,
  `review_scores_location` double DEFAULT NULL,
  `review_scores_value` double DEFAULT NULL,
  `license` text,
  `instant_bookable` text,
  `calculated_host_listings_count` int(11) DEFAULT NULL,
  `calculated_host_listings_count_entire_homes` int(11) DEFAULT NULL,
  `calculated_host_listings_count_private_rooms` int(11) DEFAULT NULL,
  `calculated_host_listings_count_shared_rooms` int(11) DEFAULT NULL,
  `reviews_per_month` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- import data into review_date using file:  project_reviews_data.sql

CREATE TABLE `review_date` (
  `listing_id` int(11) DEFAULT NULL,
  `date` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE HOST;

CREATE  TABLE host (
  `host_id` int(11) PRIMARY KEY,
  `host_url` text,
  `host_name` text,
  `host_since` text,
  `host_location` text,
  `host_response_time` text,
  `host_response_rate` text,
  `host_acceptance_rate` text,
  `host_is_superhost` text,
  `host_thumbnail_url` text,
  `host_picture_url` text,
  `host_neighbourhood` text,
  `host_listings_count` int(11) DEFAULT NULL,
  `host_verifications` text,
  `host_has_profile_pic` text,
  `host_identity_verified` text
 );
 
 drop table location;
 create table  `location` (
   location_id int auto_increment primary key, 
  `neighbourhood_cleansed` text,
  `neighbourhood_group_cleansed` text,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL
  );


create table specification (
 specification_id int primary key,
 listing_id int,
 `room_type` text,
  `accommodates` int(11) DEFAULT NULL,
  `bathrooms` text,
  `bathrooms_text` text,
  `bedrooms` text,
  `beds` int(11) DEFAULT NULL
 );

create table review (
  review_id int primary key,
  listing_id int ,
  `review_scores_rating` double DEFAULT NULL,
  `review_scores_accuracy` double DEFAULT NULL,
  `review_scores_cleanliness` double DEFAULT NULL,
  `review_scores_checkin` double DEFAULT NULL,
  `review_scores_communication` double DEFAULT NULL,
  `review_scores_location` double DEFAULT NULL,
  `review_scores_value` double DEFAULT NULL 
);

delete from host;
select * from host;
DESCRIBE HOST
describe listing

insert into host (
select distinct host_id, 
 host_url, 
 host_name, 
 host_since, 
 host_location,  
 host_response_time,
 host_response_rate, host_acceptance_rate, host_is_superhost, host_thumbnail_url,
 host_picture_url, host_neighbourhood, host_listings_count, host_total_listings_count, host_verifications, 
 host_has_profile_pic, host_identity_verified
from listing );
commit;

select count(*) from host where host_id ='2206506'
 drop table listing;
 
Create table listing (
Listing_id int primary key,
Location_id int,
Host_id int,
listing_Url text,
listing_name text,
Description text,
Price text,
Minimum_nights int,
Maximum_nights int,
Availability_30 int,
Availability_60 int,
Availability_90 int,
Availability_365 int,
Number_of_review int,
First_review text,
Last_review text
);

 
delete from location;
insert into location ( neighbourhood_group_cleansed, neighbourhood_cleansed, latitude, longitude)
select distinct neighbourhood_group_cleansed, neighbourhood_cleansed, latitude, longitude from listing_raw;
commit;

select * from location order by 2;
 

insert into listing (  listing_id, listing_url, price, minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_review, first_review, last_review)
select   id, listing_url,  price, minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_reviews, first_review, last_review
from listing_raw;
commit;

update listing a set location_id = (select location_id from location b where a.latitude = b.latitude and a.longitude = b.longitude);


alter table review add constraint fk_listing   foreign key (listing_id) references listing (listing_id);

alter table specification add constraint fk_listing   foreign key (listing_id) references listing (listing_id);

alter table review_date add constraint fk_listing   foreign key (listing_id) references listing (listing_id);

alter table listing add constraint fk_location   foreign key (location_id) references location (location_id);

alter table listing add constraint fk_host   foreign key (host_id) references host (host_id);

