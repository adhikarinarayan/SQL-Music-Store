/* top 10 artists who has written most number of rock music tracks*/
SELECT
artist.name, count(artist.artist_id) as number_of_songs,artist.artist_id

FROM ARTIST
JOIN ALBUM ON ARTIST.ARTIST_ID = album.ARTIST_ID
JOIN TRACK ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
JOIN GENRE ON GENRE.GENRE_ID = TRACK.GENRE_ID
WHERE GENRE.NAME = 'Rock'

group by artist.artist_id
order by number_of_songs desc
limit 10


/* Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/

select name,milliseconds
from track
where milliseconds > (
select avg(milliseconds) from track
)
order by milliseconds desc


/*Find how much amount spent by each customer on topmost artist? Write a query to return
customer name, artist name and total spent*/

with top_art as(
	SELECT artist.name as artist_name,
	artist.artist_id, sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	FROM invoice_line
	JOIN TRACK ON invoice_line.track_id= track.track_id
	JOIN album on track.album_id = album.album_id
	JOIN artist on artist.artist_id=album.artist_id
	group by 2
	order by 3 DESC
	LIMIT 1	
)

SELECT customer.customer_id,
customer.first_name, customer.last_name, artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_spending

FROM invoice
    JOIN customer ON invoice.customer_id=customer.customer_id
	JOIN invoice_line ON invoice_line.invoice_id=invoice.invoice_id
	JOIN TRACK ON invoice_line.track_id= track.track_id
	JOIN album on track.album_id = album.album_id
	JOIN artist on artist.artist_id=album.artist_id
	JOIN top_art on top_art.artist_id=artist.artist_id
   group by 1,2,3,4
   order by 5 DESC

/*We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres*/
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1


/*Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent.*/

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

























