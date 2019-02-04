-- 4.1
SELECT distinct p.maker FROM labor_sql.product as p where p.maker not in  
(SELECT pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop') and p.type like 'PC';
-- 4.2
	SELECT distinct p.maker FROM labor_sql.product as p where p.maker != all   
	(SELECT pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop') and p.type like 'PC';
-- 4.3
SELECT distinct p.maker FROM labor_sql.product as p where p.maker NOT IN (
SELECT distinct p.maker FROM labor_sql.product as p where p.maker = any   
(SELECT distinct pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop'))  and p.type like 'PC';
-- 4.4
SELECT distinct p.maker FROM labor_sql.product as p where p.maker in  
(SELECT pp.maker FROM labor_sql.product as pp where pp.type like 'Laptop' and p.type like 'PC');
-- 4.5
  SELECT * FROM product pr WHERE 
  NOT pr.model != ALL(SELECT pc.model FROM pc)
  AND
  NOT pr.maker !=ALL(SELECT pr2.maker FROM laptop JOIN product as pr2 ON laptop.model = pr2.model WHERE pr2.maker = pr.maker);
-- 4.6
  SELECT * FROM product pr WHERE 
  pr.model = ANY(SELECT pc.model FROM pc )
  AND
  pr.maker = ANY(SELECT pr2.maker FROM laptop JOIN product as pr2 ON laptop.model = pr2.model WHERE pr2.maker = pr.maker);
-- 5.1 
SELECT maker,type,model from labor_sql.product WHERE EXISTS (SELECT maker from labor_sql.pc where product.model = pc.model);
-- 5.2
SELECT distinct p.maker FROM labor_sql.pc as pc join labor_sql.product as p on pc.model = p.model where pc.speed >= 750;
-- 5.3
SELECT DISTINCT P.maker FROM Product P WHERE EXISTS (SELECT *  FROM PC WHERE PC.model = P.model and PC.speed >=750
AND EXISTS (SELECT *  FROM Laptop  l WHERE l.speed >= 750 and EXISTS(SELECT * FROM Product P2 WHERE P2.model = l.model )));
-- 5.4 
SELECT  DISTINCT maker FROM PC JOIN Product p3 ON p3.model=PC.model WHERE EXISTS(SELECT * FROM Product  p 
WHERE p.model=PC.model and EXISTS(SELECT * FROM Product p2 WHERE p2.maker = p.maker AND p2.type = 'Printer')) 
AND speed = (SELECT MAX(speed) FROM PC );
-- 5.5
SELECT * FROM labor_sql.classes as c join labor_sql.ships as s on c.class = s.class where s.launched > 1932 and exists 
(SELECT * FROM labor_sql.ships as ss where c.class = ss.class and c.displacement > 35000)group by s.class;
-- 6.1
 SELECT CONCAT("Average price ", FORMAT(AVG(price),'E')) AS Average_price FROM laptop;
-- 6.2
 SELECT CONCAT("model:",model) AS model, CONCAT("price: ",price) AS price FROM PC;
-- 6.3
  SELECT DATE_FORMAT(date, '%Y.%m.%d') AS date FROM income;
-- 6.4
  SELECT ship, battle, replace(replace(replace(result,'sunk','potonuv'),'damaged','poshkodjenuy'),'OK','Dobre ye') AS Translate FROM outcomes;
-- 6.5
 SELECT CONCAT('Row:', SUBSTRING(place, 1, 1)) AS roww, CONCAT('Place:', SUBSTRING(place, 2, 1)) AS place  FROM pass_in_trip;
-- 6.6
 SELECT CONCAT("From ",town_from, " to ",town_to) AS direction  FROM trip;
-- 7.1
	SELECT * FROM labor_sql.printer where price = (SELECT max(price) FROM labor_sql.printer e);
-- 7.2
	SELECT * FROM labor_sql.laptop where speed <= all(SELECT price FROM labor_sql.pc);
-- 7.3
	SELECT * FROM labor_sql.printer group by color having price <= (SELECT min(price) FROM labor_sql.printer p where p.color like 'y');
-- 7.4
   SELECT *,count(model) FROM labor_sql.product where type ='PC' group by maker ;
   -- 8.1
   SELECT maker,
            (SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = product.maker) as pc,
         (SELECT COUNT(*) FROM  laptop JOIN product pr ON laptop.model = pr.model WHERE pr.maker = product.maker) as laptop,
         (SELECT COUNT(*) FROM  printer JOIN product pr ON printer.model = pr.model WHERE pr.maker = product.maker) as printer
  FROM product  GROUP  BY  maker;
  -- 8.2
SELECT p.maker,avg(screen) FROM labor_sql.product as p join labor_sql.laptop as l on p.model=l.model group by p.maker;
-- 8.3 
SELECT p.maker,max(l.price) FROM labor_sql.product as p  left join labor_sql.pc as l on p.model=l.model group by p.maker;
-- 8.4
SELECT p.maker,min(l.price) FROM labor_sql.product as p  left join labor_sql.pc as l on p.model=l.model group by p.maker;
-- 8.5
SELECT speed, (SELECT AVG(price) FROM PC p2 WHERE p2.speed = p1.speed) as average_price FROM PC p1 WHERE p1.speed> 600;
-- 9.1
SELECT p.maker, case When (SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = p.maker) > 0 
THEN CONCAT('YES(',FORMAT((SELECT COUNT(*) FROM  pc JOIN product pr ON pc.model = pr.model WHERE pr.maker = p.maker),'E'),')') 
ELSE 'NO' END  as pc FROM product p group by maker;
-- 9.2

-- 10.1
SELECT t.maker,t.model,t.type,pc.price FROM labor_sql.product t join labor_sql.pc pc on t.model = pc.model where t.maker = 'B'
union all 
(SELECT t.maker,t.model,t.type,pc.price FROM labor_sql.product t join labor_sql.laptop pc on t.model = pc.model where t.maker = 'B')
union all
(SELECT t.maker,t.model,t.type,pc.price FROM labor_sql.product t join labor_sql.printer pc on t.model = pc.model where t.maker = 'B')
;
-- 9.2
SELECT point, date, 
        CASE  
        WHEN  subquery.inc IS NULL THEN 0
                ELSE subquery.inc
                END as 'inc', 
                CASE  
        WHEN  subquery.out IS NULL THEN 0
                ELSE subquery.out
                END as 'out' 
                
FROM (SELECT i.point, i.date, inc, o.out FROM income_o i left join outcome_o   o on i.date = o.date 
  UNION
SELECT o.point, o.date, inc, o.out FROM income_o i right join outcome_o  o on i.date = o.date) as subquery;
-- 9.3
  SELECT * FROM ships s JOIN classes c ON s.class= c.class 
    WHERE    case WHEN numGuns = 8 OR bore = 15 OR displacement= 32000 OR type= 'bb'THEN true
    ELSE false 
    end;
-- 10.2
SELECT p.type,p.model,max(pc.price) FROM labor_sql.pc pc left join labor_sql.product p on pc.model = p.model group by pc.model 
union 
SELECT p.type,p.model,max(pc.price) FROM labor_sql.laptop pc left join labor_sql.product p on pc.model = p.model group by pc.model
union
SELECT p.type,p.model,max(pc.price) FROM labor_sql.printer pc left join labor_sql.product p on pc.model = p.model group by pc.model;
-- 10.3
SELECT o.maker,avg(avgPrice) FROM (
SELECT p.maker,avg(pc.price) avgPrice FROM labor_sql.pc pc left join labor_sql.product p 
on pc.model = p.model where p.maker ='A' group by p.maker 
union 
SELECT p.maker,avg(pc.price) avgPrice FROM labor_sql.laptop pc left join labor_sql.product p 
on pc.model = p.model where p.maker ='A' group by p.maker) as o;
-- 10.4
SELECT s.name,s.class FROM labor_sql.ships as s where s.name=s.class
union
SELECT o.ship,o.ship FROM labor_sql.outcomes as o group by o.ship;
-- 10.5
select * from (SELECT s.name,count(*) cou FROM labor_sql.ships as s left join labor_sql.classes as c on s.class=c.class group by s.class
union
SELECT s.ship,count(*) cou FROM labor_sql.outcomes as s group by s.ship
union
SELECT s.name,count(*) cou FROM labor_sql.battles as s group by s.name) tab where tab.cou < 2;











