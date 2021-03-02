-- Labs Self-queries and cross-joins

-- Get all pairs of actors that worked together.

CREATE table tablea
SELECT actor_table.actor_id,first_name,last_name,film_id
FROM sakila.actor as actor_table 
JOIN sakila.film_actor as film_actor_table on actor_table.actor_id = film_actor_table.actor_id;

SELECT tablea_1.actor_id, tablea_2.actor_id, tablea_1.film_id
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id;

SELECT tablea_1.actor_id as act_1, tablea_2.actor_id as act_2, tablea_1.film_id, row_number() over (partition by tablea_1.actor_id, tablea_2.actor_id order by tablea_1.actor_id, tablea_2.actor_id) as ranking
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id;

SELECT act_1, act_2
FROM (SELECT tablea_1.actor_id as act_1, tablea_2.actor_id as act_2, tablea_1.film_id, row_number() over (partition by tablea_1.actor_id, tablea_2.actor_id order by tablea_1.actor_id, tablea_2.actor_id) as ranking
FROM sakila.tablea as tablea_1
JOIN sakila.tablea as tablea_2 on tablea_1.film_id = tablea_2.film_id and tablea_1.actor_id < tablea_2.actor_id) as sub
WHERE ranking = 1;

-- Get all pairs of customers that have rented the same film more than 3 times

CREATE TABLE tableq2
SELECT film_id, customer_id, rental_id
FROM sakila.inventory as inventoy_table 
JOIN sakila.rental as rental_table on inventoy_table.inventory_id = rental_table.inventory_id;

SELECT tableq2_1.customer_id, table2_2.customer_id, tableq2_1.film_id
FROM tableq2 as tableq2_1 
JOIN tableq2 as table2_2 on tableq2_1.film_id = table2_2.film_id and tableq2_1.customer_id < table2_2.customer_id
GROUP BY tableq2_1.customer_id, table2_2.customer_id, tableq2_1.film_id
HAVING count(tableq2_1.rental_id) > 3
ORDER BY film_id;

-- Get all possible pairs of actors and films

select * from (
	select distinct title from sakila.film
) sub1
cross join (
	select distinct actor_id from sakila.actor
) sub2;





