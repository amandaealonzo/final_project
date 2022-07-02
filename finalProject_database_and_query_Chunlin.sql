-- import the raw data listings.csv into table listings using sql code file from Amanda: project_listings_data.sql

-- change safe update option
SET SQL_SAFE_UPDATES = 0;

-- Step 1: Create table users
DROP TABLE IF EXISTS  users;
CREATE TABLE IF NOT EXISTS users (
	user_id INT auto_increment PRIMARY KEY, -- serial PRIMARY KEY,
	username VARCHAR(100),
	email VARCHAR(500),
	password VARCHAR(40) ,
	phone VARCHAR(30) 
);

-- Step 2: Creat table host, primary key is host_id
DROP TABLE IF EXISTS host;
CREATE TABLE IF NOT EXISTS host (
  host_id int(11) PRIMARY KEY,
  host_url text,
  host_name text,
  host_since text,
  host_location text,
  host_response_time text,
  host_response_rate text,
  host_acceptance_rate text,
  host_is_superhost text,
  host_thumbnail_url text,
  host_picture_url text,
  host_neighbourhood text,
  host_listings_count int(11) DEFAULT NULL,
  host_verifications text,
  host_has_profile_pic text,
  host_identity_verified text
 );
-- Step 2.1: Insert data into host
-- host_id '2206506' has a duplication, so need to delete one. 
SELECT * FROM listings WHERE host_id ='2206506';
-- delete the row with id = '500886' AND host_id ='2206506'
DELETE FROM listings Where id = '500886' AND host_id ='2206506';
-- confirm if the row is deleted.
SELECT * FROM listings WHERE host_id ='2206506';

INSERT INTO host(host_id, 
 host_url, 
 host_name, 
 host_since, 
 host_location,  
 host_response_time,
 host_response_rate, host_acceptance_rate, host_is_superhost, host_thumbnail_url,
 host_picture_url, host_neighbourhood, host_listings_count, host_verifications, 
 host_has_profile_pic, host_identity_verified)
SELECT DISTINCT host_id, 
 host_url, 
 host_name, 
 host_since, 
 host_location,  
 host_response_time,
 host_response_rate, host_acceptance_rate, host_is_superhost, host_thumbnail_url,
 host_picture_url, host_neighbourhood, host_listings_count, host_verifications, 
 host_has_profile_pic, host_identity_verified
FROM listings;

-- Step 3: Create table location
DROP TABLE IF EXISTS location;
CREATE TABLE IF NOT EXISTS  location (
  location_id int auto_increment primary key, 
  neighbourhood_cleansed text,
  neighbourhood_group_cleansed text,
  latitude double DEFAULT NULL,
  longitude double DEFAULT NULL
  );

-- Step 3.1: Insert data into table location
INSERT INTO location ( neighbourhood_group_cleansed, neighbourhood_cleansed, latitude, longitude)
SELECT DISTINCT neighbourhood_group_cleansed, neighbourhood_cleansed, latitude, longitude from listings;

-- Step 4: Creat table listing
DROP TABLE IF EXISTS listing;
CREATE TABLE IF NOT EXISTS  listing (
Listing_id int primary key,
Location_id int auto_increment,
Host_id int,
listing_Url text,
Price text,
Minimum_nights int,
Maximum_nights int,
Availability_30 int,
Availability_60 int,
Availability_90 int,
Availability_365 int,
Number_of_review int,
First_review text,
Last_review text,
CONSTRAINT fk_location_id FOREIGN KEY (Location_id)
REFERENCES location(location_id),
CONSTRAINT fk_host_id FOREIGN KEY (Host_id)
REFERENCES host(host_id)
);

-- Step 4.1: Insert data into table listing
INSERT INTO listing (Listing_id, Host_id, listing_url, price, minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_review, first_review, last_review)
SELECT  id, host_id, listing_url, price, minimum_nights, maximum_nights, availability_30, availability_60, availability_90, availability_365, number_of_reviews, first_review, last_review
FROM listings;

-- Step 5: Creat table specification
DROP TABLE IF EXISTS specification;
CREATE TABLE IF NOT EXISTS specification (
 specification_id int primary key auto_increment,
 listing_id int,
 room_type text,
  accommodates int(11) DEFAULT NULL,
  bathrooms text,
  bathrooms_text text,
  bedrooms text,
  beds int(11) DEFAULT NULL,
  CONSTRAINT fk_listing_id_1 FOREIGN KEY (listing_id)
  REFERENCES listing(Listing_id)
 );
 
 -- Step 5.1: Insert data into table specification
INSERT INTO specification (listing_id, room_type, accommodates, bathrooms, bedrooms, beds)
SELECT  id, room_type, accommodates, bathrooms, bedrooms, beds
FROM listings; 

-- Step 6: Create table review
DROP TABLE IF EXISTS review;
CREATE TABLE IF NOT EXISTS review (
  review_id int primary key auto_increment,
  listing_id int ,
  review_scores_rating double DEFAULT NULL,
  review_scores_accuracy double DEFAULT NULL,
  review_scores_cleanliness double DEFAULT NULL,
  review_scores_checkin double DEFAULT NULL,
  review_scores_communication double DEFAULT NULL,
  review_scores_location double DEFAULT NULL,
  review_scores_value double DEFAULT NULL,
  CONSTRAINT fk_listing_id_2 FOREIGN KEY (listing_id)
  REFERENCES listing(Listing_id)
);

-- Step 6.1: Insert data into table review
INSERT INTO review (listing_id, review_scores_rating, review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, review_scores_communication, review_scores_location, review_scores_value)
SELECT  id, review_scores_rating, review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, review_scores_communication, review_scores_location, review_scores_value
FROM listings; 


-- Step 7: import data into review_date using file:  project_reviews_data.sql
-- Step 7.1: add foreign key constraint for table review_date
alter table review_date add constraint fk_listing   foreign key (listing_id) references listing (listing_id);

----------------------

-- Queries
-- I like Times Squares in the New York city, and would want to see if I can find any room to rent via Airbnb. Checked online, I found the latitude and longitude of Times Square is 40.7580 and -73.9875. 
-- So I narrowed down the location to latitude in the range of 40.7540 to 40.7620 and longitude in the range of -73.9925 to -73.9825
-- I would want to just stay one night, so I sorted results by the minimum_nights; And also I care about the rating from people, so I sorted the results by desended review_scores_rating also.
SELECT listing.Listing_id, listing.Host_id, listing.listing_Url, Minimum_nights, latitude, longitude, Price, review_scores_rating FROM listing
LEFT JOIN location
ON listing.location_id = location.location_id
LEFT JOIN review
ON listing.listing_id = review.listing_id
WHERE neighbourhood_group_cleansed = 'Manhattan' AND latitude > 40.7540 AND latitude < 40.7620 AND longitude > -73.9925 AND longitude < -73.9825
ORDER BY review_scores_rating DESC, Minimum_nights;

