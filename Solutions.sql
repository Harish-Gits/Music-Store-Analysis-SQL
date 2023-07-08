EASY -->

-- Q1: Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1;


-- Q2: Which Country has the most invoices?
select count(*) as num_of_invoices, billing_country
from invoice
group by billing_country
order by num_of_invoices desc
limit 1;


-- Q3: What are top 3 values of total invoice?
select * 
from invoice
order by total desc
limit 3;


-- Q4:  Which city has the best customers? 
-- We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals
select billing_city, sum(total) as total_rev
from invoice
group by billing_city
order by total_rev desc
limit 1;


-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.
select * from invoice;
select * from customer;

select c.customer_id, c.first_name, c.last_name, sum(total) as total_spend
from invoice i
join customer c
on c.customer_id = i.customer_id
group by c.customer_id
order by total_spend desc
limit 1;



MODERATE -->

-- Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.
select distinct c.email,c.first_name,c.last_name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on il.track_id = t.track_id
join genre g on g.genre_id = t.genre_id
where g.name = 'Rock'
order by email;


-- Q2: Lets invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
select a.name, count(*) as tot_count
from artist a
join album ab on ab.artist_id = a.artist_id
join track t on t.album_id = ab.album_id
join genre g on g.genre_id = t.genre_id
where g.name = 'Rock'
group by a.name
order by tot_count desc
limit 10;


-- Q3: Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
select name, milliseconds
from track
where milliseconds > (select avg(milliseconds) from track) 
order by milliseconds desc;



ADVANCE -->

-- Q1: Find how much amount spent by each customer on artists? 
-- Write a query to return customer name, artist name and total spent
select c.first_name, c.last_name, arts.name, sum(il.unit_price * il.quantity) as total_spent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album abm on abm.album_id = t.album_id
join artist arts on arts.artist_id = abm.artist_id
where c.first_name = 'Wyatt'
group by c.first_name, c.last_name, arts.name;


-- Q2. We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre 
-- with the highest quantity of purchases. 
-- Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.
with cte as (
	select c.country, g.name, count(il.quantity) as qty_of_purchases,
	row_number() over(partition by c.country order by count(il.quantity) desc) as rn
	from customer c
	join invoice i on c.customer_id = i.customer_id
	join invoice_line il on il.invoice_id = i.invoice_id
	join track t on t.track_id = il.track_id
	join genre g on g.genre_id = t.genre_id
	group by c.country, g.name)
	
select country, name, qty_of_purchases from cte where rn <=1;


-- Q3: Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.
with cte as(
	select c.first_name, c.last_name, i.billing_country, sum(i.total) as tot_spent,
	rank() over(partition by i.billing_country order by sum(i.total) desc) as rnk
	from customer c
	join invoice i 
	on c.customer_id = i.customer_id
	group by c.first_name, c.last_name, i.billing_country)
	
select first_name, last_name, billing_country, tot_spent
from cte
where rnk = 1;













