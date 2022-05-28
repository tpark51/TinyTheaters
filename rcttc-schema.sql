use master;
GO
drop database if exists TinyTheaters;
GO
create database TinyTheaters;
GO
use TinyTheaters;
GO

--SCHEMA
create table Theater(
    TheaterId int primary key identity(1, 1),
    [Name] varchar(100) not null, 
    [Address] varchar(150) not null,
    Phone varchar(15) not null,
    Email varchar(50) not null
);

create table Customer(
    CustomerId int primary key identity(1, 1),
    FirstName varchar(100) not null, 
    LastName varchar(100) not null, 
    [Address] varchar(150) null,
    Phone varchar(15) null,
    Email varchar(50) not null
);

create table Show(
    ShowId int primary key identity(1, 1),
    [Name] varchar(100) not null, 
    TheaterId int not null,
    constraint fk_Show_TheaterId
        foreign key (TheaterId)
        references Theater(TheaterId)
);

create table Ticket(
    TicketId int primary key identity(1, 1),
    CustomerId int not null,
    ShowId int not null, 
    [Date] date not null,
    SeatNumber varchar(5) not null,
    TicketPrice decimal(7, 2) not null,
    constraint fk_Ticket_CustomerId
        foreign key (CustomerId)
        references Customer(CustomerId),
    constraint fk_Ticket_ShowId
        foreign key (ShowId)
        references Show(ShowId) 
);
