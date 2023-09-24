-- Who is the senior most employee based on job title?
SELECT
FIRST_NAME, LAST_NAME,HIRE_DATE, LEVELS
FROM 
EMPLOYEE
ORDER BY LEVELS desc
LIMIT 1

-- Which countries have the most Invoices?
select count(*),billing_country  from invoice
group by billing_country
order by billing_country desc

--What are top 3 values of total invoice?
SELECT TOTAL
FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3

/*Which city has the best customers? Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
total */

SELECT billing_city, sum(total) as sum_of_invoices
FROM INVOICE
group by billing_city
order by sum(total) desc

/*Who is the best customer(who spent most of the money)?*/
SELECT 
first_name,last_name,sum(total) as total_spending
FROM
customer
join invoice
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total_spending desc limit 1

/* info of all rock music listeners*/
SELECT 
DISTINCT EMAIL,FIRST_NAME,LAST_NAME,genre.name
FROM 
CUSTOMER
JOIN INVOICE ON CUSTOMER.CUSToMER_id =invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN TRACK ON track.track_id = invoice_line.track_id
JOIN GENRE ON genre.genre_id = track.genre_id
WHERE
genre.name = 'Rock'
order by email

--alternate way

SELECT 
DISTINCT EMAIL,FIRST_NAME,LAST_NAME
FROM 
CUSTOMER
JOIN INVOICE ON CUSTOMER.CUSToMER_id =invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
WHERE
track_id in(
	select track_id
	from track
	JOIN GENRE ON genre.genre_id = track.genre_id
	where genre.name = 'Rock'
)
order by email


