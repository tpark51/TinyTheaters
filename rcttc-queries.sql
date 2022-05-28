use TinyTheaters;

--Find all performances in the last quarter of 2021 (Oct. 1, 2021 - Dec. 31 2021).
select 
    t.[Date],
    s.[Name] Show
from Ticket t
inner join Show s on t.ShowId = s.ShowId
where t.[Date] >= '2021-10-01' 
and t.[Date] <= '2021-12-31';

--List customers without duplication.
select 
    FirstName,
    LastName
from Customer;

--Find all customers without a .com email address. 
select 
    FirstName,
    LastName,
    Email
from Customer
where Email not like '%.com';

--Find the three cheapest shows.
select top (3)
    tk.TicketPrice,
    s.[Name] as Show
from Ticket tk
inner join Show s on tk.ShowId = s.ShowId
group by s.Name, tk.TicketPrice
order by tk.TicketPrice asc;

--List customers and the show they're attending with no duplication.
select 
    c.FirstName + ' ' + c.LastName as 'Customer Name',
    s.[Name] as Show
from Customer c
inner join Ticket t on c.CustomerId = t.CustomerId
inner join Show s on t.ShowId = s.ShowId
group by c.FirstName, c.LastName, s.Name
order by c.FirstName asc, c.LastName asc;

--List customer, show, theater, and seat number in one query.
select 
    c.FirstName + ' ' + c.LastName as 'Customer Name',
    tk.SeatNumber,
    s.[Name] as Show,
    t.[Name] as Theater
from Customer c
inner join Ticket tk on c.CustomerId = tk.CustomerId
inner join Show s on tk.ShowId = s.ShowId
inner join Theater t on s.TheaterId = t.TheaterId;

--Find customers without an address.
select 
    *
from Customer
where [Address] is null;

--Recreate the spreadsheet data with a single query.
select
    c.FirstName,
    c.LastName,
    c.Email,
    c.Phone,
    c.Address,
    tk.SeatNumber,
    s.Name,
    tk.TicketPrice,
    tk.[Date],
    t.Name,
    t.Address,
    t.Phone,
    t.Email
from Customer c
left outer join Ticket tk on c.CustomerId = tk.CustomerId
inner join Show s on tk.ShowId = s.ShowId
inner join Theater t on s.TheaterId = t.TheaterId
order by t.Name asc, s.Name asc, tk.[Date] asc, tk.SeatNumber asc;

--Count total tickets purchased per customer.
select 
    c.FirstName + ' ' + c.LastName as 'Customer Name',
    count(tk.TicketId) as 'Total Ticket Purchases'
from Customer c
inner join Ticket tk on c.CustomerId = tk.CustomerId
group by c.FirstName, c.LastName;

--Calculate the total revenue per show based on tickets sold.
select 
    s.[Name] as 'Show',
    count(tk.TicketId) as 'Tickets Sold',
    tk.TicketPrice as 'Ticket Price',
    (tk.TicketPrice * count(tk.TicketId)) as 'Total Revenue'
from Show s
inner join Ticket tk on s.ShowId = tk.ShowId
group by s.Name, tk.TicketPrice;

--Calculate the total revenue per theater based on tickets sold.
select 
    TheaterName,
    sum(ShowTicketTotal) as 'Total Revenue'
from 
    (select 
    t.Name as TheaterName, 
    s.Name as ShowName, 
    count(tk.TicketId)* tk.TicketPrice as ShowTicketTotal 
    from Show s
    inner join Ticket tk on s.ShowId = tk.ShowId
    inner join Theater t on s.TheaterId = t.TheaterId
    group by t.Name, s.Name, tk.TicketPrice
    ) sub
group by TheaterName;

--Who is the biggest supporter of RCTTC? Who spent the most in 2021?
select top(1)
    FirstName + ' ' + LastName as 'Customer Name',
    sum(ShowTicketTotal) as 'Total Spent'
from 
    (select 
    c.FirstName as FirstName, c.LastName as LastName, s.Name as ShowName, count(tk.TicketId)* tk.TicketPrice as ShowTicketTotal from Show s
    inner join Ticket tk on s.ShowId = tk.ShowId
    inner join Customer c on tk.CustomerId = c.CustomerId
    group by c.FirstName, c.LastName, s.Name, tk.TicketPrice
    ) sub
group by FirstName, LastName
order by sum(ShowTicketTotal) desc;