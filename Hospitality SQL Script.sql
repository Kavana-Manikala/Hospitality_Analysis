# Total Booking
Select distinct count(booking_id) as Total_Boooking 
from fact_bookings;

# Total Revenue Generated
select concat(round(sum(revenue_generated)/1000000000,0),' B') as Revenue_Generated 
from fact_bookings;

# Total Revenue Realized
select concat(round(sum(revenue_realized)/1000000000,2),' B') as Revenue_realized 
from fact_bookings;

# Occupancy
Select concat(round((sum(successful_bookings)/sum(capacity))*100,2),' %') as Occupancy_rate 
from fact_aggregated_bookings;

# Cancellation rate
select (count(case when booking_status="cancelled" then 1 end)/ count(booking_status)*100) as Cancellation_rate 
from fact_bookings;


alter table dim_date rename column date to check_in_date;
SET SQL_SAFE_UPDATES = 0;
UPDATE dim_date SET check_in_date = STR_TO_DATE(check_in_date, '%d-%b-%y');
alter table dim_date modify column check_in_date date;

# Trend Analysis
select monthname(dim_date.check_in_date) as month_name,concat(round(sum(revenue_realized)/1000000,2),' M') Revenue
from fact_bookings join dim_date 
on dim_date.check_in_date=fact_bookings.check_in_date 
group by month_name
order by Revenue desc;

# Weekday & Weekend Revenue 
select dim_date.day_type as DayType,concat(round(sum(revenue_realized)/1000000,2),' M') revenue
from fact_bookings join dim_date 
on dim_date.check_in_date=fact_bookings.check_in_date 
group by dim_date.day_type
order by revenue ;

# Weekday & Weekend Booking
select dim_date.day_type as DayType, count(fact_bookings.booking_id) Booking
from fact_bookings join dim_date 
on dim_date.check_in_date=fact_bookings.check_in_date 
group by dim_date.day_type
order by Booking desc;

# Revenue by City 
Select dim_hotels.city as CityName, concat(round(sum(fact_bookings.revenue_realized)/1000000,2),' M') Revenue
from fact_bookings join dim_hotels on fact_bookings.property_id=dim_hotels.property_id
group by CityName
order by Revenue desc;

# Revenue by Property name
Select dim_hotels.property_name as Hotel, concat(round(sum(fact_bookings.revenue_realized)/1000000,2),' M') Revenue
from fact_bookings join dim_hotels on fact_bookings.property_id=dim_hotels.property_id
group by Hotel
order by Revenue desc;

#  Class Wise Revenue
Select dim_rooms.room_class as RoomClass, concat(round(sum(fact_bookings.revenue_realized)/1000000,2),' M') Revenue
from fact_bookings join dim_rooms on fact_bookings.room_category=dim_rooms.room_id
group by RoomClass
order by Revenue desc;

# Checked out cancel No show
select booking_status, concat(round(sum(revenue_realized)/1000000,2),' M') Revenue
from fact_bookings
group by booking_status;