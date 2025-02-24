/*
1.	¿Cuáles son los datos de almacenes que tiene la compañía? Se necesita:

a.	Identificador del almacén.
b.	Nombre del almacén.
c.	Nombre de la ciudad, país y región donde está ubicado. */

//Consulta SQL 

SELECT w.warehouse_id, w.warehouse_name, l.city, c.country_name, r.region_name
FROM warehouses w
INNER JOIN locations l on l.location_id = w.location_id
INNER JOIN countries c on c.country_id = l.country_id
INNER JOIN regions r ON c.region_id = r.region_id


//2.	¿Cuál es el producto que tiene más stock en Asia?

//Consulta SQL 

select p.product_id, p.product_name, sum(i.quantity) as total
from inventories i
inner join products p on p.product_id = i.product_id
inner join warehouses w on w.warehouse_id = i.warehouse_id
inner join locations l on l.location_id = w.location_id
inner join countries c on c.country_id = l.country_id
inner join regions r on r.region_id = c.region_id
where r.region_name = 'Asia'
group by p.product_id, p.product_name
order by total desc
  
//3.	¿Cuál es el producto que ha vendido más unidades durante 2016?

//Consulta SQL 


SELECT P.PRODUCT_ID, P.PRODUCT_NAME, SUM(OI.QUANTITY) AS cantidad
  FROM PRODUCTS P
 INNER JOIN ORDER_ITEMS OI ON OI.PRODUCT_ID=P.PRODUCT_ID
 INNER JOIN ORDERS O ON O.ORDER_ID=OI.ORDER_ID
 WHERE O.ORDER_DATE>=TO_DATE('20160101','YYYYMMDD') AND O.ORDER_DATE<TO_DATE( '20170101','YYYYMMDD')
   AND O.STATUS = 'Shipped'
GROUP BY P.PRODUCT_ID, P.PRODUCT_NAME
ORDER BY cantidad DESC
  

//4.	¿Cuál es la categoría de productos que ha vendido más unidades durante 2017?

Consulta SQL 

SELECT pc.category_name, sum(oi.quantity) as quantity
FROM product_categories pc
INNER JOIN products p on pc.category_id = p.category_id
INNER JOIN order_items oi on p.product_id = oi.product_id
INNER JOIN orders o on oi.order_id = o.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2017
AND o.status = 'Shipped'
GROUP by pc.category_name
ORDER BY quantity DESC;


5.	¿Cuál es el nombre del cliente cuyo gasto ha sido más alto en 2015?

//Consulta SQL 

SELECT c.name, SUM(oi.unit_price * oi.quantity) as customerSpending
FROM customers c
INNER JOIN orders o on c.customer_id = o.customer_id
INNER JOIN order_items oi on  o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2015
AND o.status = 'Shipped'
GROUP BY c.name
ORDER BY customerSpending DESC;


//6.	¿Cuánto ha facturado la compañía en cada uno de los años de los que tiene datos?

Consulta SQL 

SELECT EXTRACT(YEAR FROM o.order_date) AS year, SUM(oi.unit_price * oi.quantity) AS totalInvoiced
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Shipped'
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY totalInvoiced;


//7.	¿Cuáles son los nombres de los productos cuyo precio es superior a la media?

Consulta SQL 

SELECT product_name, list_price
FROM products
WHERE list_price > (SELECT AVG(list_price) FROM products)
ORDER BY list_price DESC;


//8.	¿Cuáles son los empleados (nombre y apellido) que han facturado mas de 50.000 $ durante 2017?

//Consulta SQL 

SELECT e.first_name, e.last_name, SUM(oi.quantity * oi.unit_price) AS sales
FROM employees e
INNER JOIN orders o ON e.employee_id = o.salesman_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2017
AND o.status = 'Shipped'
GROUP BY e.first_name, e.last_name
HAVING SUM(oi.quantity * oi.unit_price) > 50000
ORDER BY sales DESC;



//9.	¿Cuántos clientes no tienen persona de contacto?

Consulta SQL

SELECT COUNT(*) as noContact
FROM customers c
LEFT JOIN contacts co ON c.customer_id = co.customer_id
WHERE co.contact_id IS NULL;


//10.	¿Cuál es el manager (nombre y apellido identificado por el campo manager_id) que menos ha facturado durante 2017?


//Consulta SQL

SELECT e.manager_id, ma.first_name, ma.last_name AS, SUM(oi.unit_price * oi.quantity) AS totalInvoiced
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN employees e ON o.salesman_id = e.employee_id
INNER JOIN employees ma ON e.manager_id = ma.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2017 
AND o.status = 'Shipped'
GROUP BY e.manager_id, ma.first_name, ma.last_name
ORDER BY totalInvoiced ASC;

