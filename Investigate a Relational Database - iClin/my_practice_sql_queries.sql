SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 10;

1.
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;
2.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;
3.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

1.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;
2.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

1.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;
2.
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

1.
SELECT *
FROM accounts
WHERE name LIKE 'C%';
2.
SELECT *
FROM accounts
WHERE name LIKE '%one%';
3.
SELECT *
FROM accounts
WHERE name LIKE '%s';

1.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');
2.
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');


1.
SELECT SUM(poster_qty)
FROM orders

NOTE: How to calculate median.
Example:
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

Project Lesson

2.
SELECT a.first_name, a.last_name, a.first_name || ' ' || a.last_name AS full_name,
      f.title, f.length
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
WHERE f.length > 60

3.
SELECT actorid, full_name,
       COUNT(filmtitle) film_count_peractor
FROM
      (SELECT a.actor_id actorid, a.first_name, a.last_name, a.first_name || ' ' || a.last_name AS full_name,
            f.title filmtitle, f.length
      FROM actor a
      JOIN film_actor fa
      ON a.actor_id = fa.actor_id
      JOIN film f
      ON fa.film_id = f.film_id) t1
GROUP BY 1, 2
ORDER BY 3 DESC


1.
SELECT full_name,
       filmtitle,
       filmlen,
       CASE WHEN filmlen <= 60 THEN '1 hour or less'
       WHEN filmlen > 60 AND filmlen <= 120 THEN 'Between 1-2 hours'
       WHEN filmlen > 120 AND filmlen <= 180 THEN 'Between 2-3 hours'
       ELSE 'More than 3 hours' END AS filmlen_groups
FROM
    (SELECT a.first_name,
               a.last_name,
               a.first_name || ' ' || a.last_name AS full_name,
               f.title filmtitle,
               f.length filmlen
        FROM film_actor fa
        JOIN actor a
        ON fa.actor_id = a.actor_id
        JOIN film f
        ON f.film_id = fa.film_id) t1
2.
SELECT    DISTINCT(filmlen_groups),
          COUNT(title) OVER (PARTITION BY filmlen_groups) AS filmcount_bylencat
FROM
         (SELECT title,length,
          CASE WHEN length <= 60 THEN '1 hour or less'
          WHEN length > 60 AND length <= 120 THEN 'Between 1-2 hours'
          WHEN length > 120 AND length <= 180 THEN 'Between 2-3 hours'
          ELSE 'More than 3 hours' END AS filmlen_groups
          FROM film ) t1
ORDER BY  filmlen_groups


PROJECT QUESRIES

QUESTION 1.
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
Answer 1:
SELECT film_title, category_name,
      COUNT(rentalid) rental_count
FROM
    (SELECT f.title film_title, c.name category_name, r.rental_id rentalid, COUNT(*)
    FROM film f
    JOIN film_category fc
    ON f.film_id = fc.film_id
    JOIN category c
    ON c.category_id = fc.category_id
    JOIN inventory i
    ON i.film_id = f.film_id
    JOIN rental r
    ON r.inventory_id = i.inventory_id
	 WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    GROUP BY 1, 2, 3) t1
GROUP BY 1,2
ORDER BY 2,1

Final Query 1:
SELECT f.title film_title, c.name category_name, COUNT(r.rental_id) rental_count
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1, 2
ORDER BY 2, 1

QUESTION 2.
Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

SOL 1:
SELECT f.title, c.name, f.rental_duration,
       NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM film_category fc
JOIN category c
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 3

SOL 2:
SELECT f.title film_title, c.name category_name, f.rental_duration ,
       NTILE(4) OVER (ORDER BY f.rental_duration) standard_quartile
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
ORDER BY 3;

QUESTION 3.
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:
- Category
- Rental length category
- Count

SOL 1.
SELECT category_name, standard_quartile, COUNT(standard_quartile)
FROM
    (SELECT f.title film_title, c.name category_name, f.rental_duration ,
           NTILE(4) OVER (ORDER BY f.rental_duration) standard_quartile
    FROM film f
    JOIN film_category fc
    ON f.film_id = fc.film_id
    JOIN category c
    ON c.category_id = fc.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    ORDER BY 3) sub1
GROUP BY 1, 2
ORDER BY 1, 2;

Question 4.
We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

SOL1.








Question 5.
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

SOL 1:
SELECT DATE_TRUNC('month', p.payment_date) pay_month, CONCAT(c.first_name, ' ', c.lastname ) full_name, COUNT(p.amount) pay_countpermon, SUM(p.amount) pay_amount
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
WHERE c.first_name || ' ' || c.last_name IN
(SELECT t1.full_name
FROM
(SELECT c.first_name || ' ' || c.last_name AS full_name, SUM(p.amount) as amount_total
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) t1) AND (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
GROUP BY 2, 1
ORDER BY 2, 1, 3

SOL 2.
SELECT DATE_TRUNC('month', p.payment_date) pay_month, CONCAT(c.first_name, ' ', c.last_name) full_name, COUNT(p.amount) pay_countpermonth, SUM(p.amount) pay_amount
FROM payment p
JOIN customer c
ON c.customer_id = p.customer_id
WHERE (p.payment_date BETWEEN '2007-01-01' AND '2008-01-01')
AND CONCAT(c.first_name, ' ', c.last_name) IN
	(SELECT full_name
	FROM
		(SELECT CONCAT(c.first_name, ' ', c.last_name) full_name, SUM(p.amount) amount_total
		FROM payment p
		JOIN customer c
		ON p.customer_id = c.customer_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10) sub1)
GROUP BY 2, 1
ORDER BY 2, 1, 3
