use walmartdb;
-- 1: Compare and give results of those supercentres with NHMs and having more footfalls than average footfall of sc and more revenue than avg revenue of sc

-- main query
select count(ï»¿Store_ID)
from n_market n left join  s_center s 
on s.Area_code=n.Area_code
where (s.Num_Footfalls+n.Num_Footfalls)/2 > (select avg(Num_Footfalls) from s_center)
and (s.Tot_Rev+n.Goods_Rev_gen) > (select avg(Tot_Rev) from s_center)

-- proof query
select s.Store_ID, (s.Num_Footfalls+n.Num_Footfalls)/2, (s.Tot_Rev+n.Tot_Rev)
from n_market n left join  s_center s 
on s.Area_code=n.Area_code
where (s.Num_Footfalls+n.Num_Footfalls)/2 > (select avg(Num_Footfalls) from s_center)
and (s.Tot_Rev+n.Tot_Rev) > (select avg(Tot_Rev) from s_center)


-- cALCULATE AVERAGE OF SC footfalls
select Store_ID, avg(Num_Footfalls), avg(Tot_Rev) from s_center 

-- 2 Pinpointing the SC
select s.Store_ID, n.ï»¿Store_ID, n.area_code, (s.Num_Footfalls+n.Num_Footfalls)/2, s.Tot_Rev+n.Goods_Rev_gen
from n_market n left join  s_center s 
on s.Area_code=n.Area_code
where (s.Num_Footfalls+n.Num_Footfalls)/2 < (select avg(Num_Footfalls) from s_center)
or (s.Tot_Rev+n.Goods_Rev_gen) < (select avg(Tot_Rev) from s_center)

-- 3 SC Customers average income analysis 
select avg(c.Ann_Incm),max(c.Ann_Incm),min(c.Ann_Incm) 
from customer c join sc_cust sc on sc.Cust_ID = c.Cust_ID

-- 4
create view SC_RA as select avg(Tot_Rev*1000)/avg(Area_size) as SC_Rev_to_Area from s_center
create view SC_RA1 as select avg(Tot_Rev*1000)/avg(Area_size) as NM_Rev_to_Area from n_market
create view SC_RA2 as select avg(Rev_gen*1000)/avg(Area_size)  as DStore_Rev_to_Area from d_store
DROP VIEW SC_RA, SC_RA1, SC_RA2
select * from SC_RA, SC_RA1 ,SC_RA2 

-- 5
create view SC_A as select avg(Tot_Rev*1000)/avg(Staff_size)/1000 as SC_sf_to_Area from s_center
create view SC_A1 as select avg(Tot_Rev*1000)/avg(Staff_size)/1000 as NM_sf_to_Area from n_market
create view SC_A2 as select avg(Rev_Gen*1000)/avg(Staff_size)/1000 as DS_sf_to_Area from d_store
DROP VIEW SC_A, SC_A1, SC_A2
select * from SC_A,SC_A1,SC_A2 

-- 6 Let's target on SCs which are earning less than average revenue
select count(Store_ID) 
from s_center 
where Tot_Rev < 
				(select avg(Tot_Rev) 
                from s_center) 

-- 7 
SELECT count(d.Num_Footfalls)
FROM d_store as d
WHERE d.Num_Footfalls < (
					SELECT avg(Num_footfalls)
                   FROM s_center)
Order By d.Num_Footfalls;

-- 8: Find area code where people do not choose home delivery so that we can give them benefit. Saving Freight charges and also giving benefit to customers
SELECT c.Cust_ID, c.Name, c.Contact_num
FROM customer as c
WHERE NOT EXISTS (SELECT we.Delivery_Type
                                      FROM w_ecommerce we
                                      WHERE we.Account_Num = c.Account_Num
                                      AND we.Delivery_Type = "HOME" )
                                      
-- 9  Open N_markets in those areas where avg revenue is less than average
SELECT s1.Store_ID, s1.Tot_Rev, s1.Area_Code, s1.Area_size From s_center as s1 Where s1.Tot_Rev < (SELECT avg(s.Tot_Rev) FROM s_center as s WHERE NOT EXISTS (SELECT n.Area_Code FROM n_market n WHERE s.Area_Code = n.Area_Code)) Order by s1.Tot_Rev

-- 10
select Product_Type, avg(Sale_Amt)
from merchants
Group by Product_Type

 select * from merchants