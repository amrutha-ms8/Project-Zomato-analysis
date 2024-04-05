SELECT * FROM zomato.main;
Select count(*) from zomato.main;
select * from zomato.country;
select * from zomato.currency;
use zomato;
select * from main;

-------- Calender Table ---
create view Calendar_table as
select DATE,day(DATE) as Day, 
dayname(DATE) as Weekday_Name,
dayofweek(DATE)-1 as Weekday,
month(DATE) as Month,
monthname(DATE) as Month_Name,
quarter(DATE)as Quarter,
year(DATE) as Year,
DATE_FORMAT(DATE,"%m-%Y") as Month_Year,
case when month(DATE) <=3 then month(DATE)+9
else month(DATE)-3
end as Financial_Month,
case when quarter(DATE)>1 then quarter(DATE)-1
else quarter(DATE)+3
end as Financial_QTR
from MAIN;

select * from Calendar_table;

-- --Percentage of Resturants based on "Has_Table_booking"------------

select concat((((select count(RESTAURANTID) from main
where has_table_booking='yes')/count(RESTAURANTID))*100),'%') as Has_table_booking
from MAIN;

select concat((((select count(RESTAURANTID) from main
where has_table_booking='No')/count(RESTAURANTID))*100),'%') as Has_table_booking
from MAIN;

-- --Percentage of Resturants based on "Has_Online_delivery"

select concat((((select count(RESTAURANTID) from main
where has_Online_delivery='yes')/count(RESTAURANTID))*100),'%') as Has_Online_delivery
from MAIN;

select concat((((select count(RESTAURANTID) from main
where has_Online_delivery='No')/count(RESTAURANTID))*100),'%') as Has_Online_delivery
from MAIN;

------ Find the Numbers of Resturants based Country. ------------------

select countryname,count(RestaurantId)
from main m
left join Country c 
on m.countryCode = c.CountryId
group by CountryName;

------- Find the Numbers of Resturants based on City ----------------

select city,count(RestaurantId) from Main
group by city;


----------- Numbers of Resturants opening based on Year -----------

select distinct year(date) as Year,
count(*) as Count_Restaurant from main
group by year(date);

----------- Numbers of Resturants opening based on Month -----------

select distinct monthname(date) as Month_Name,
count(*) as Count_Restaurant from main
group by monthname(date);

----------- Numbers of Resturants opening based on Quarter -----------

select distinct quarter(date) as Quarter,
count(*) as Count_Restaurant from Main
group by quarter(date);


------------ Count of Resturants based on Average Ratings---------------

SELECT  
case when rating between 0 and 1 then "0-1"
when rating between 1 and 2 then "1-2"
when rating between 02 and 3 then "2-3"
else "3-4"
end as Rating_Bucket,
COUNT(RESTAURANTID)as No_of_Resturant from main
group by Rating_Bucket
order by Rating_Bucket;

----- Stored Procedure ----------
call restuarantCount();


-------- Convert the Average cost for 2 column into USD dollars --------------


select A.currency,A.average_cost_for_two,B.usdrate,(A.average_cost_for_two*B.usdrate) as USDCurrency
from main a
join currency b
on a.currency=b.currency;


------------- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets------


select A.city,A.RestaurantName,(A.Average_Cost_for_two * B.USDRate)as STD_USD,
case
when A.Average_Cost_for_two * B.USDRate between 0 and 10 then '0-10'
when A.Average_Cost_for_two * B.USDRate between 10 and 20 then '10-20'
when A.Average_Cost_for_two * B.USDRate between 20 and 30 then '20-30'
when A.Average_Cost_for_two * B.USDRate between 30 and 40 then '30-40'
ELSE "ABOVE 50"
END AS COST_BUCKET
from main A join currency B on A.Currency = B.Currency;






