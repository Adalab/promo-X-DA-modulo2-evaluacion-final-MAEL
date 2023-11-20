USE sakila;

-- Selecciona todos los nombres de las películas sin que aparezcan duplicados

SELECT DISTINCT title
FROM film;

-- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"

SELECT DISTINCT title
FROM film
WHERE rating = "PG-13";

-- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title, description
FROM FILM 
WHERE description LIKE '%amazing%';

-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos

SELECT title
FROM film  
WHERE length > 120;

-- Recupera los nombres de todos los actores.

SELECT first_name, last_name
FROM actor;

-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name = "Gibson";

-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name, last_name
FROM actor
WHERE actor_id >= 10 AND actor_id <= 20;

-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS cantidad_total
FROM film
GROUP BY rating;

-- Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
-- su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

-- Encuentra la cantidad total de películas alquiladas por categoría y 
-- muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name AS nombre_categoria, COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY cantidad_peliculas_alquiladas DESC;

-- Encuentra el promedio de duración de las películas para cada clasificación de la tabla film 
-- y muestra la clasificación junto con el promedio de duración.

SELECT rating, AVG(length) AS promedio_duracion
FROM film
GROUP BY rating;

-- Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT film.film_id, film.title AS 'Nombre peli', actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
WHERE film.title = 'Indian Love';

-- Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
FROM FILM 
WHERE description LIKE '%dog%' OR description LIKE '%cat%';

-- Hay algún actor que no aparecen en ninguna película en la tabla film_actor.

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor);

-- Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT title
FROM film
WHERE release_year >= 2005 AND release_year <= 2010;

-- Encuentra el título de todas las películas que son de la misma categoría que "Family"

SELECT DISTINCT f.title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN film_category fc_family ON fc.category_id = fc_family.category_id
INNER JOIN film f_family ON fc_family.film_id = f_family.film_id
INNER JOIN category c ON fc_family.category_id = c.category_id
WHERE c.category_id = 8
AND f.film_id <> f_family.film_id;

-- Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS cantidad_peliculas
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(film_actor.film_id) > 10;

-- Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;

-- Encuentra las categorías de películas que tienen un promedio de duración superior a 
-- 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS nombre_categoria, AVG(f.length) AS promedio_duracion
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

-- Encuentra los actores que han actuado en al menos 5 películas y 
-- muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS cantidad_peliculas
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(film_actor.film_id) >= 5;

-- Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar 
-- los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT title
FROM film
WHERE film_id IN (
    SELECT inventory.film_id
    FROM rental
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    WHERE DATEDIFF(return_date, rental_date) > 5
);

-- Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta 
-- para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.


SELECT actor.first_name, actor.last_name, c.name AS category_name
FROM actor
CROSS JOIN category c
WHERE c.name = 'Horror'
AND actor.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc ON fa.film_id = fc.film_id
    INNER JOIN category c2 ON fc.category_id = c2.category_id
    WHERE c2.name = 'Horror'
);