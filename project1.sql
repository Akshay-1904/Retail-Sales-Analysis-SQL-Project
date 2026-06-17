
create database sql_project_p1;
use sql_project_p1;
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(20),
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);
select * from retail_sales;
select count(*) from retail_sales;
SELECT COUNT(*)
FROM retail_sales
WHERE age IS NULL;
ALTER TABLE retail_sales
MODIFY age INT NULL;
#data cleaning
delete  from retail_sales
where transactions_id is null 
or
sale_date is null
or
customer_id is null
or
gender is null
or 
age is null
or 
category is null
or
quantity is null
or 
price_per_unit is null
or 
cogs is null 
or
total_sale is null ;
#unique customers
select count(distinct customer_id) as total_costumer from retail_sales;
#unique cat
select count(distinct category) as total_costumer from retail_sales;
#data analysis and business key problems

# sales made on 5-11-2022
select * from retail_sales 
where sale_date = "2022-11-05";

#Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where category = "clothing"
and quantity >= 4
and sale_date >='2022-11-01'
and sale_date <'2022-12-01'
  ;
  
 ## Write a SQL query to calculate the total sales (total_sale) for each category
  select category, sum(total_sale) , count(*) from retail_sales
  group by category ;

##Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
  select category, avg(age)from retail_sales
  where category = "Beauty";
  
  
##Write a SQL query to find all transactions where the total_sale is greater than 1000.
select transactions_id , total_sale from retail_sales
where total_sale > 1000;

##Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(transactions_id) as total_trans from retail_sales
group by gender,category 
order by gender asc;


##Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from (
select   YEAR (sale_date ) AS YEAR ,MONTH(sale_date ) AS MONTH ,AVG  (total_sale),
rank()over (partition by YEAR (sale_date ) order by AVG(total_sale) DESC ) AS rank_num 
From retail_sales
GROUP BY YEAR (sale_date ) ,MONTH (sale_date )
) as t1 
where rank_num = 1
;


##**Write a SQL query to find the top 5 customers based on the highest total sales **:
select * from (select customer_id , sum(total_sale) as sales ,
rank() over( order by sum(total_sale) desc) as rank_num
from retail_sales
group by customer_id) as t1
where rank_num <=5
;
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

##Write a SQL query to find the number of unique customers who purchased items from each category.:
select category, count(distinct(customer_id)) as unique_cus from retail_sales
group by category;

##Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with shift_data as (select *,
case
when HOUR(sale_time) < 12 then "MORNING"
when HOUR(sale_time) between 12 and 17 then "AFTERNOON"
else "EVENING"
end as shift from retail_sales
 )
 select shift, count(transactions_id) as number_of_orders from shift_data
 group by shift;