-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


select*from Books
select*from Customers
select*from Order_id

alter table Customers
alter column country type varchar(100);

copy Customers(customer_id,name,email,phone,city,country)
from 'C:\Users\luv\Desktop\sql\Customers.csv'
csv header

copy Order_id(order_id,customer_id,book_id,order_date,quantity,total_amount)
from 'C:\Users\luv\Desktop\sql\Orders.csv'
csv header

--> retrieve all books in the fiction genre 

select * from Books 
where genre='Fiction';

-->find books published after the year 1950

select * from Books 
where published_year>1950
order by published_year asc;

-->list all the coustomers from the canada 

select*from Customers 
where country='Canada';

-->show order placed in november 2023

select*from Order_id
where order_date between '2023-11-01' and '2023-11-30'
order by order_date asc;

-->retrieve the total stock of books available 
select sum (stock) as total_stock
from Books ;

--> find the details of the most expensive book

select * from Books 
order by price DESC
limit 1;

--> show all the coustomers who order more than 1 quantity of a book

select * from Order_id 
where quantity>1
order by quantity asc;

-->retrueve all the orders where the total amount exceeds 20

select * from order_id 
where total_amount>20
order by total_amount asc;

-->list all the genres available in the books table 

select distinct genre from Books;

-->find the book with the lowest stock 

select * from Books 
order by stock asc
limit 1;

--> calculate the total revenue generated from all orders 

select sum(total_amount) as revenue from Order_id;

--> retrieve the total number of books sold for each genre 

select b.genre,sum(o.quantity) as total_quantity_by_genre
from Books b
join Order_id o on b.book_id=o.book_id
group by genre

select c.country,avg(o.total_amount) as sale_by_country
from Customers c
join Order_id o on o.customer_id = c.customer_id
group by country 

-->find the average price of books in the fantasy genre 

select avg(price) 
from Books 
where genre = 'Fantasy'

-->list customer who have placed at least 2 orders:

select customer_id,count(order_id)
from Order_id 
group by customer_id
having count(order_id) >=2

select o.customer_id,c.name,count(o.order_id)
from order_id o
join Customers c on c.customer_id=o.customer_id
group by c.name, o.customer_id
having count(order_id) >=2
order by customer_id asc

--> find the most frequently ordered book

select book_id,count(order_id) as no_of_books_ordered
from order_id
group by book_id
order by no_of_books_ordered desc

select o.book_id,b.title,b.published_year,count(o.order_id)
from Order_id o
join Books b on b.book_id=o.book_id
group by o.book_id,b.title,b.published_year

--> show the top 3 most expensive books of fantasy genre 

select genre,price
from Books
where genre='Fantasy' 
order by price desc limit 3

select * from Books 
where genre='Fantasy'
order by price desc limit 3

-->retreive the total quantity of books sold by each author 

select b.author,sum(o.quantity)
from Books b
join Order_id o on o.book_id=b.book_id
group by b.author


-->list the cities where coustomer who spend over 30$ are located 

select distinct c.city,o.total_amount as citeis_over_30
from Customers c
join Order_id o on o.customer_id=c.customer_id
group by c.city,o.total_amount 
having o.total_amount > 30

-->find the coustomers who spend morst on the orders 

select c.customer_id,c.name,sum(o.total_amount) as most_spend
from Order_id o
join Customers c on c.customer_id=o.customer_id
group by c.name,c.customer_id
order by most_spend desc limit 1

-->caluclate the stock remaining after fullfiling all the orders

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
b.stock- coalesce(sum(o.quantity),0) as remaning_quantity
from Books b
left join Order_id o on o.book_id=b.book_id
group by b.book_id 
order by b.book_id asc