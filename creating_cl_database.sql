--Create a database
create database cc

-- Create the table where environmental data will be stored
create table ec_log
(
    record_date datetime not null
    ,initial nvarchar(50) not null
    ,clone_temp float
    ,clone_humidity float
    ,clone_temp_2 float
    ,clone_hum_2 float
    ,mom_temp float
    ,mom_humidity float
    ,veg_temp float
    ,veg_humidity float
    ,bloom_e_temp float
    ,bloom_e_hum float
    ,bloom_w_temp float
    ,bloom_w_humidity float
)

-- Create a Stored Procedure for updating Environmental Control Data often and viewing updates
CREATE PROCEDURE update_ec_log
    @record_date datetime
    ,@initial nvarchar(50)
    ,@clone_temp float
    ,@clone_humidity float
    ,@clone_temp_2 float
    ,@clone_hum_2 float
    ,@mom_temp float
    ,@mom_humidity float
    ,@veg_temp float
    ,@veg_humidity float
    ,@bloom_e_temp float
    ,@bloom_e_hum float
    ,@bloom_w_temp float
    ,@bloom_w_humidity float
as

BEGIN 

insert into ec_log
(
	record_date
    ,initial
    ,clone_temp
    ,clone_humidity
    ,clone_temp_2
    ,clone_hum_2
    ,mom_temp
    ,mom_humidity
    ,veg_temp
    ,veg_humidity
    ,bloom_e_temp
    ,bloom_e_hum
    ,bloom_w_temp
    ,bloom_w_humidity
)
values
(
	@record_date
    ,@initial
    ,@clone_temp
    ,@clone_humidity
    ,@clone_temp_2
    ,@clone_hum_2
    ,@mom_temp
    ,@mom_humidity
    ,@veg_temp
    ,@veg_humidity
    ,@bloom_e_temp
    ,@bloom_e_hum
    ,@bloom_w_temp
    ,@bloom_w_humidity
)

select
	*
from
	ec_log

END

-- One way to use the stored procedure
EXEC update_ec_log '2022-03-05 07:00:00','SL',84,28.5,85.9,27.7,78.5,40.9,79.8,38.2,80.1,51.7,78.1,53.2

-- Create table for Clone Development Tracking
create table clone_development
(
    transplant_date datetime not null
    ,strain_id nvarchar(50) not null
    ,record_date datetime not null
    ,initial nvarchar(50) not null
    ,moisture nvarchar(10)
    ,feed_ec float
    ,feed_ph float
    ,avg_height float
)

-- Create Stored Procedure for updating Clone Development Tracking often and viewing updates
CREATE PROCEDURE update_clone_development
    @transplant_date datetime
    ,@strain_id nvarchar(50)
    ,@record_date datetime
    ,@initial nvarchar(50)
    ,@moisture nvarchar(10)
    ,@feed_ec float
    ,@feed_ph float
    ,@avg_height float
as

BEGIN 

insert into clone_development
(
    transplant_date
    ,strain_id
    ,record_date
    ,initial
    ,moisture
    ,feed_ec
    ,feed_ph
    ,avg_height
)
values
(
    @transplant_date
    ,@strain_id
    ,@record_date
    ,@initial
    ,@moisture
    ,@feed_ec
    ,@feed_ph
    ,@avg_height
)

select
	*
from
	clone_development

END

-- One way to use the stored procedure
EXEC update_clone_development '2022-03-07','SRK 6289','2022-03-07','SL','Dry',1.8,5.8,3.16
