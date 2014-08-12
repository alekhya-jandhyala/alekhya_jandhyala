#1.Find the titles of all movies directed by Steven Spielberg.

select m.title, m.director
from movie m
where m.director='Steven Spielberg';

#2.Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select m.title, m.year,r.stars
from movie m, rating r
where M.mid=r.mid and r.stars>=4;

#3.Find the titles of all movies that have no ratings.

select DISTINCT m.title, m.mID
from movie m, rating r
where m.mid not in(select r.mid from rating r);

##4.Some reviewers didn't provide a date with their rating.
#Find the names of all reviewers who have ratings with a NULL value for the date. 

select re.name
from  Reviewer re,rating r
where re.rid=r.rid and r.ratingdate is null;


#5.Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
#Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select re.name, m.title,r.stars,r.ratingdate
from reviewer re, movie m, rating r 
where r.rid=re.rid and m.mid=r.mid
order by re.name, m.title,r.stars;


#6.For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
# return the reviewer's name and the title of the movie. 

select re.name, m.title
from reviewer re, movie m, rating r1, rating r2
where r1.rid=re.rid and m.mid=r1.mid and r1.rID in
(select r1.rid from rating r1, rating r2 where r1.stars<r2.stars and r1.ratingDate<r2.ratingDate) ;




#7.For each movie that has at least one rating, find the highest number of stars that movie received. 
#Return the movie title and number of stars. Sort by movie title. 

select distinct m.mid, r.stars,m.title
from movie m, rating r
where r.stars in (select max(r.stars) from rating r where r.mid=m.mid)
order by m.title;

#8.List movie titles and average ratings, from highest-rated to lowest-rated. 
#If two or more movies have the same average rating, list them in alphabetical order.
 
select m.title, avg(r.stars)
from movie m,rating r
where r.mid=m.mid
group by m.mid 
order by avg(stars) DESC, title;

#9.Find the names of all reviewers who have contributed three or more ratings. 
#(As an extra challenge, try writing the query without HAVING or without COUNT.) 

select re.name,r1.stars
from reviewer re, rating r1, rating r2
where re.rid=r1.rid and count(r1.rid)>1;


#Exercise: Level 2 Questions

#1.For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie.
# Sort by rating spread from highest to lowest, then by movie title. 

select m.title, max(r.stars)-min(r.stars)
from movie m,rating r
where r.mid=m.mid and m.mid 
group by m.title
order by max(r.stars)-min(r.stars) DESC, m.title;

#2.Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
#(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
#Don't just calculate the overall average rating before and after 1980.) 

select avg(r1.stars)-avg(r2.stars),m.year
from movie m,rating r1, rating r2, rating r
where r.mid=m.mid and r1.stars in(select avg(r.stars)from rating r, movie m where r.mid=r.mid and m.year>1980) and 
r2.stars in(select avg(r.stars)from rating r, movie m where r.mid=r.mid and m.year<1980);


#3.Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, 
#along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both 
#with and without COUNT.) 

select m.title,m.director 
from movies m 
where m.director in (select director 
					from (select director ,count(title) from movies group by director) as sit where sit.count(title)>1);


#4Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
#(Hint: This query is more difficult to write in SQLite than other systems; 
#you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

select m.title, avg(r.stars) as stars1 
from rating r join movie m on m.mid = r.mid 
group by r.mid having stars1 = (select max(s.stars) as stars from (select mid, avg(stars) as stars from rating group by mid) as st);

#5.Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
#(Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding 
#the lowest average rating and then choosing the movie(s) with that average rating.) 

select m.title, avg(r.stars) as stars1 
from rating r join movie m on m.mid = r.mid 
group by r.mid having stars1 = (select min(s.stars) as stars from (select mid, avg(stars) as stars from rating group by mid) as s);


#6.For each director, return the director's name together with the title(s) of the movie(s) they directed that received the
# highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
 
select director, title, stars 
from movie m, rating r 
where m.mid = r.mid and director is not null group by director order by stars desc;