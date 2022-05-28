use TinyTheaters;

SELECT * FROM Temp;

--CUSTOMER!
select distinct customer_first, customer_last, customer_email, customer_phone, customer_address
from Temp;

insert into Customer (FirstName, LastName, Email, Phone, [Address])
    select distinct customer_first, customer_last, customer_email, customer_phone, customer_address
    from Temp;

select * from Customer;

--THEATER:
SELECT * FROM Temp;

select distinct theater, theater_address, theater_phone, theater_email
from Temp;

insert into Theater ([Name], [Address], Phone, Email)
    select distinct theater, theater_address, theater_phone, theater_email
    from Temp;

select * from Theater;

--SHOW:
SELECT * FROM Temp;

select distinct t.show, th.TheaterId
from Temp t
inner join Theater th  on t.theater = th.Name;

insert into Show ([Name], TheaterId)
    select distinct t.show, th.TheaterId
    from Temp t
    inner join Theater th  on t.theater = th.Name;

select * from Show;

--TICKET:
SELECT * FROM Temp;

select distinct t.seat, s.ShowId, c.CustomerId, t.date, t.ticket_price
from Temp t
inner join Show s on t.show = s.Name
inner join Customer c on t.customer_email = c.Email;


insert into Ticket (SeatNumber, ShowId, CustomerId, [Date], TicketPrice)
   select distinct t.seat, s.ShowId, c.CustomerId, t.date, t.ticket_price
    from Temp t
    inner join Show s on t.show = s.Name
    inner join Customer c on t.customer_email = c.Email;

select * from Ticket;


--UPDATES
--The Little Fitz's 2021-03-01 performance of The Sky Lit Up is listed with a $20 ticket price. 
--The actual price is $22.25 because of a visiting celebrity actor. 
select 
    t.[Name] Theater,
    tk.[Date],
    s.Name Show,
    s.ShowId ShowId,
    tk.TicketPrice Price
from Theater t
inner join Show s on t.TheaterId = s.TheaterId
inner join Ticket tk on s.ShowId = tk.ShowId
where t.[Name] = 'Little Fitz'
and tk.[Date] = '2021-03-01';

update Ticket set
    TicketPrice = 22.25
where ShowId = 9
and [Date] = '2021-03-01'; 

--In the Little Fitz's 2021-03-01 performance of The Sky Lit Up, Pooh Bedburrow and Cullen Guirau seat reservations aren't in the same row. 
--Adjust seating so all groups are seated together in a row. 
select 
    t.[Name] Theater,
    tk.[Date],
    s.Name Show,
    c.FirstName,
    c.LastName,
    tk.SeatNumber,
    tk.TicketId
from Theater t
inner join Show s on t.TheaterId = s.TheaterId
inner join Ticket tk on s.ShowId = tk.ShowId
inner join Customer c on tk.CustomerId = c.CustomerId
where t.[Name] = 'Little Fitz'
and tk.[Date] = '2021-03-01'
order by c.FirstName asc, tk.SeatNumber asc;

--Change Pooh 'A4' to 'B4
--Change Cullent 'B4' to 'C2'
--Change Vail 'C2' to 'A4
--Confirm not dups
update Ticket set
    SeatNumber = 'B4'
where TicketId = 37;

update Ticket set
    SeatNumber = 'C2'
where TicketId = 104;

update Ticket set
    SeatNumber = 'A4'
where TicketId = 137;


--Update Jammie Swindles's phone number from "801-514-8648" to "1-801-EAT-CAKE".
select * from Customer
where FirstName = 'Jammie';

update Customer set
    Phone = '1-801-EAT-CAKE'
where CustomerId = 34;


--DELETE
--Assuming this means if the show only has 1 reservation
--Delete all single-ticket reservations at the 10 Pin. (You don't have to do it with one query.) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--was there a better way to do this?
select 
    t.[Name] Theater,
    s.Name Show,
    tk.[Date], 
    c.FirstName,
    c.LastName,
    tk.SeatNumber,
    tk.TicketId
from Theater t
left outer join Show s on t.TheaterId = s.TheaterId
left outer join Ticket tk on s.ShowId = tk.ShowId
left outer join Customer c on tk.CustomerId = c.CustomerId
where t.Name = '10 Pin'
order by s.ShowId asc, tk.[Date] asc, c.FirstName asc, c.LastName asc;

--2021-03-01 Hertha Glendining
delete from Ticket
where TicketId = 191;

--2021-09-24 Brian Bake, Flinn Crowcher, Lucien Playdon
delete from Ticket
where TicketId = 166
or TicketId = 9
or TicketId = 59;

--2021-12-21 Caye Trecher, Emily Duffree, Giraud Bachmann
delete from Ticket
where TicketId = 1
or TicketId = 61
or TicketId = 161;

--2021-01-04 Loralie Rois, Melamie Feighry
delete from Ticket
where TicketId = 30
or TicketId = 193;

--Delete the customer Liv Egle of Germany. It appears their reservations were an elaborate joke.
select 
    tk.[Date], 
    c.FirstName,
    c.LastName,
    tk.TicketId
from Customer c
left outer join Ticket tk on c.CustomerId = tk.CustomerId
where c.FirstName = 'Liv';

delete Ticket
where TicketId = 44
or TicketId = 48;

delete from Customer
where CustomerId = 45;