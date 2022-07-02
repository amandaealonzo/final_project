-- Amanda

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

drop table specification;
create table specification (
 specification_id int auto_increment primary key,
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
from listing_raw  where host_id <> 2206506 or host_since not like '%/1914%'); -- data cleansing for one host with duplicate rows
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
 
create unique index location_ix on location(latitude, longitude);
create   index location_ix on listing_raw(latitude, longitude);

describe listing;

insert into listing (  listing_id, location_id, host_id, listing_url, price, minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_review, first_review, last_review)
select distinct   id,  b.location_id, host_id,  listing_url,  replace(price,'%','') , minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_reviews, first_review, last_review
from 
listing_raw a
left outer join location b on a.latitude = b.latitude and a.longitude = b.longitude;

commit;
 
 describe specification
 
insert into specification (  listing_id,
room_type,
bathrooms,
bathrooms_text,
bedrooms,
beds)
select distinct   id,  
room_type,  bathrooms, bathrooms_text, bedrooms, beds
from 
listing_raw;

commit;

describe listing
 
delete  from review_date where listing_id not in (select listing_id from listing);
commit;

delete  from review_date where listing_id is null;
commit;

alter table review add constraint fk_listing   foreign key (listing_id) references listing (listing_id);

alter table specification add constraint fk_listing2   foreign key (listing_id) references listing (listing_id);

alter table review_date add constraint fk_listing3   foreign key (listing_id) references listing (listing_id);

alter table listing add constraint fk_location   foreign key (location_id) references location (location_id);

alter table listing add constraint fk_host   foreign key (host_id) references host (host_id);

-- SAMPLE QUERIES FOR APPLICATION

-- neighborhood monthly summary

describe review_date
describe location

create index rev_listing_ix on review_date (listing_id);
create index listing_loc_ix on listing (location_id);

-- check monthly volume over time by  neighborhood

select year(date) || '-' || month(date) month_cd, neighbourhood_group_cleansed, count(date) review_count
from
listing a
left outer join review_date b on a.listing_id = b.listing_id
left outer join location c on a.location_id = c.location_id
group by  year(date) || '-' || month(date) , neighbourhood_group_cleansed
order by 2,1;


-- check long term rentals vs short term rentals  by  neighborhood

select 
sum(case when minimum_nights > 30 then 1 else  0 end) long_term_count, count(*) total_count,  
sum(case when minimum_nights > 30 then 1 else  0 end)/count(*) * 100 long_term_percent,
neighbourhood_group_cleansed ,
neighbourhood_cleansed
from
listing a
left outer join location c on a.location_id = c.location_id
 group by neighbourhood_group_cleansed, neighbourhood_cleansed
order by 1 desc;

/*
Top  5 by percent:

long total  percent
1	2	50.0000	Staten Island	Rossville
1	3	33.3333	Bronx	Spuyten Duyvil
2	13	15.3846	Staten Island	Grant City
5	37	13.5135	Manhattan	Roosevelt Island
2	21	9.5238	Queens	Howard Beach

Top 5 by volume:
long total  percent
41	787	    5.2097	Manhattan	East Village
41	2078	1.9731	Brooklyn	Bedford-Stuyvesant
38	1386	2.7417	Manhattan	Harlem
37	1839	2.0120	Brooklyn	Williamsburg
36	1123	3.2057	Brooklyn	Bushwick
34	984	    3.4553	Manhattan	Midtown
29	616	    4.7078	Manhattan	Chelsea

*/



describe listing


