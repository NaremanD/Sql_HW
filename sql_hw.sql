SHOW DATABASES;
use sakila;
SHOW tables;
select * from actor 
limit 10;
-- 1a. Display the first and last names of all actors from the table `actor`.
select first_name ,last_name
from actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper (concat (a.first_name , ' ' , a.last_name)) as "Actor Name"
from actor a ;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select a.actor_id ,a.first_name ,a.last_name 
from actor a 
where first_name like  "joe";
-- 2b. Find all actors whose last name contain the letters `GEN`:
select * from actor 
where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor 
where last_name like '%LI%'
ORDER BY TRIM(Last_name) ASC
       , TRIM(First_name) ASC;
-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:       
select country_id,country from country 
where country IN ('Afghanistan','Bangladesh','China');
alter table actor 
-- 3a.  create a column in the table `actor` named `description` and use the data type `BLOB`.
add description blob;
select * from actor ;
-- 3b. Delete the `description` column.
alter table actor 
drop column description;
select * from actor ;
-- 4a.List the last names of actors, as well as how many actors have that last name.
select 	last_name as'last name ', count(last_name) as 'last name count'
from actor 
group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name,
--  but only for names that are shared by at least two actors
select 	last_name as'last name ', count(last_name) as 'last name count'
from actor 
group by last_name
having count(last_name)>=2;
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`.
--  Write a query to fix the record.
select first_name ,last_name from actor
where last_name like 'williams';
select first_name ,last_name from actor
where first_name like 'GROUCHO'
and last_name like 'WILLIAMS';
update actor 
set first_name = 'HARPO'
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';
select first_name ,last_name from actor
where last_name like 'WILLIAMS';
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
update actor 
set first_name = 'GROUCHO'
where first_name = 'HARPO'
and last_name = 'WILLIAMS';
select first_name ,last_name from actor
where last_name like 'WILLIAMS';
-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
show create table address ;
-- 6a. Use `JOIN` to display the first and last names, as well as the address, 
-- of each staff member. Use the tables `staff` and `address`:
select s.first_name ,s.last_name ,a.address
from staff as s 
join address as a
on s.address_id = a.address_id;
-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005.
--  Use tables `staff` and `payment`.
select concat(s.first_name ,' ' ,s.last_name) as 'staff member' , sum(p.amount) as 'total amount'
from staff as s
join payment as p 
on s.staff_id = p.staff_id 
where p.payment_date like '2005-08%'
group by p.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` 
-- and `film`. Use inner join.
select f.title ,count(fa.actor_id) as 'number of actors' 
from film as f
inner join film_actor as fa 
on f.film_id =fa.film_id 
group by f.title ;
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select f.title as 'film' ,count(i.inventory_id) as 'number of copies '
from inventory as i 
join  film as f 
on f.film_id = i.film_id 
where f.title ='Hunchback Impossible' 
group by f.title ;
-- 6e. Using the tables payment and customer and the JOIN command,list the total paid by each customer.
-- List the customers alphabetically by last name:
select c.first_name ,c.last_name ,sum(p.amount) as 'Total Amount Paid'
from customer as c 
join payment as p 
on c.customer_id = p.customer_id 
group by c.customer_id
ORDER BY Trim(Last_name) ASC ;
-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q
-- whose language is English.
select * from language ;
select f.title 
from film as f
where f.language_id = (select language_id from language where name = 'English')
and f.title like 'K%' or 'Q%' ;
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
    select concat(a.first_name ,' ',a.last_name)as 'Actors in Alone trip'
    from actor as a 
    where a.actor_id in 
    (select actor_id from film_actor where film_id = (select film_id from film where title = 'Alone Trip'));
-- 7c. You need the names and email addresses of all Canadian customers. 
select concat (c.first_name ,' ',c.last_name )as 'customer names',c.email
from customer as c 
join address as a on c.address_id = a.address_id 
join city as ci on a.city_id = ci.city_id 
join country as co on ci.country_id = co.country_id 
where co.country = 'Canada';
-- 7d.Identify all movies categorized as family films.
select * from category;
select f.title as 'family movies'
from film as f 
join film_category as fc
on f.film_id = fc.film_id 
join category as c 
on c.category_id = fc.category_id 
where c.name = 'Family';
-- 7e. Display the most frequently rented movies in descending order.
select f.title as 'Movie',count(r.rental_id) as 'Times Rented '
from film as f 
join inventory as i 
on f.film_id = i.film_id 
join rental as r 
on r.inventory_id = i.inventory_id
group by f.title 
order by count(r.rental_id)desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select * from sales_by_store ;
select * from staff;
select st.store_id as 'store_id',concat(c.city,',', cy.country)as 'Store' , 
sum(p.amount) as 'total_sales' from payment as p 
join staff as sf on p.staff_id = sf.staff_id 
join store as st on st.store_id = sf.store_id 
join address  as a on a.address_id = st.address_id 
join city as c on c.city_id = a.city_id 
join country as cy on cy.country_id = c.country_id 
group by st.store_id ;
-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id as 'Store_id',c.city as 'City' ,cy.country as 'Country'
from store as s 
join address as a on a.address_id = s.address_id 
join city as c on c.city_id = a.city_id 
join country as cy on cy.country_id = c.country_id 
group by s.store_id ;
-- 7h. List the top five genres in gross revenue in descending order. 
select c.name as 'Genres',sum(p.amount) as 'Revenue'
from category as c 
join film_category as fc on fc.category_id = c.category_id 
join inventory as i on i.film_id = fc.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id 
group by c.name 
order by sum(p.amount) desc 
limit 5;
-- 8a. In your new role as an executive, you would like to have an easy way of
--  viewing the Top five genres by gross revenue. Use the solution from the problem above 
--  to create a view. 
create view Top_five_genres_revenue as 
select c.name as 'Genres',sum(p.amount) as 'Revenue'
from category as c 
join film_category as fc on fc.category_id = c.category_id 
join inventory as i on i.film_id = fc.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id 
group by c.name 
order by sum(p.amount) desc 
limit 5;
-- 8b. How would you display the view that you created in 8a?
select * from Top_five_genres_revenue;
-- 8c. You find that you no longer need the view top_five_genres.
--  Write a query to delete it.
drop view Top_five_genres_revenue;





