create database Pizzeria
use Pizzeria

drop table if exists PizzaIngrediente

drop table if exists Pizza

drop table if exists Ingrediente

create table Pizza(
CodicePizza int primary key identity(1,1),
Nome varchar(20) not null unique,
Prezzo decimal(4,2) not null check (Prezzo>0)
);

create table Ingrediente(
CodiceIngrediente int primary key identity(1,1),
Nome varchar(20) not null unique,
Costo decimal(4,2) not null check (Costo>0),
QuantitaInMagazino int not null check(QuantitaInMagazino>=0)
);
create table PizzaIngrediente(
CodicePizza int constraint FK_Pizza foreign key references Pizza(CodicePizza),
CodiceIngrediente int constraint FK_Ingrediente foreign key references Ingrediente(CodiceIngrediente),
constraint PK_PI_IN primary key (CodicePizza,CodiceIngrediente)
);


insert into Ingrediente values('pomodoro',0.5,1)
insert into Ingrediente values('mozzarella',1,2)
insert into Ingrediente values('mozzarella di bufala',2,3)
insert into Ingrediente values('spianata piccante',1.5,4)
insert into Ingrediente values('funghi',1,1)
insert into Ingrediente values('carciofi',1.5,2)
insert into Ingrediente values('cotto',1,3)
insert into Ingrediente values('olive',1,4)
insert into Ingrediente values('funghi porcini',2,1)
insert into Ingrediente values('stracchino',1,2)
insert into Ingrediente values('speck',1.5,3)
insert into Ingrediente values('rucola',1,4)
insert into Ingrediente values('grana',1,1)
insert into Ingrediente values('verdure di stagione',1.5,2)
insert into Ingrediente values('patate',1,3)
insert into Ingrediente values('salsiccia',1,4)
insert into Ingrediente values('pomodorini',1,1)
insert into Ingrediente values('ricotta',1,2)
insert into Ingrediente values('provola',1,3)
insert into Ingrediente values('gorgonzola',1,4)
insert into Ingrediente values('pomodoro fresco',1,1)
insert into Ingrediente values('basilico',0.5,2)
insert into Ingrediente values('bresaola',1,3)

insert into Pizza values('Margherita',5)
insert into Pizza values('Bufala',7)
insert into Pizza values('Diavola',6)
insert into Pizza values('Quattro Stagioni',6.5)
insert into Pizza values('Porcini',7)
insert into Pizza values('Dioniso',8)
insert into Pizza values('Ortolana',8)
insert into Pizza values('Patate e Salsiccia',6)
insert into Pizza values('Pomodorini',6)
insert into Pizza values('Quattro Formaggi',7.5)
insert into Pizza values('Caprese',7.5)
insert into Pizza values('Zeus',7.5)

select * from Ingrediente

select * from Pizza

--1. Estrarre tutte le pizze con prezzo superiore a 6 euro

select * from Pizza
where Prezzo>6

--2. Estrarre la pizza/le pizze più costosa/e

select * from Pizza
where Prezzo=(select Max(Prezzo) from Pizza)

--3. Estrarre le pizze «bianche»

select * from Pizza
where CodicePizza not in (select p.CodicePizza from  Pizza p 
						  join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza 
						  join Ingrediente i on pin.CodiceIngrediente=i.CodiceIngrediente
						  where i.Nome='Pomodoro')

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)

select p.* from  Pizza p 
		   join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza 
		   join Ingrediente i on pin.CodiceIngrediente=i.CodiceIngrediente
where i.Nome like 'Funghi%'

--1. Inserimento di una nuova pizza (parametri: nome, prezzo) 

create procedure InserimentoPizza
@nome varchar(20),
@prezzo decimal(4,2)
as
insert into Pizza values(@nome,@prezzo)
go

--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome ingrediente) 

create procedure InserimentoIngredientePizza
@nomePizza varchar(20),
@nomeIngrediente varchar(20)
as
declare @codicePizza int
select @codicePizza=CodicePizza from Pizza
where Nome=@nomePizza
declare @codiceIngrediente int
select @codiceIngrediente=CodiceIngrediente from Ingrediente
where Nome=@nomeIngrediente
insert into PizzaIngrediente values(@codicePizza,@codiceIngrediente)
go

execute InserimentoIngredientePizza 'Margherita','pomodoro';
execute InserimentoIngredientePizza 'Margherita','mozzarella';
execute InserimentoIngredientePizza 'Bufala','pomodoro';
execute InserimentoIngredientePizza 'Bufala','mozzarella di bufala';
execute InserimentoIngredientePizza 'Diavola','pomodoro';
execute InserimentoIngredientePizza 'Diavola','mozzarella';
execute InserimentoIngredientePizza 'Diavola','spianata piccante';
execute InserimentoIngredientePizza 'Quattro Stagioni','pomodoro';
execute InserimentoIngredientePizza 'Quattro Stagioni','mozzarella';
execute InserimentoIngredientePizza 'Quattro Stagioni','funghi';
execute InserimentoIngredientePizza 'Quattro Stagioni','carciofi';
execute InserimentoIngredientePizza 'Quattro Stagioni','cotto';
execute InserimentoIngredientePizza 'Quattro Stagioni','olive';
execute InserimentoIngredientePizza 'Porcini','pomodoro';
execute InserimentoIngredientePizza 'Porcini','mozzarella';
execute InserimentoIngredientePizza 'Porcini','funghi porcini';
execute InserimentoIngredientePizza 'Dioniso','pomodoro';
execute InserimentoIngredientePizza 'Dioniso','mozzarella';
execute InserimentoIngredientePizza 'Dioniso','stracchino';
execute InserimentoIngredientePizza 'Dioniso','speck';
execute InserimentoIngredientePizza 'Dioniso','rucola';
execute InserimentoIngredientePizza 'Dioniso','grana';
execute InserimentoIngredientePizza 'Ortolana','pomodoro';
execute InserimentoIngredientePizza 'Ortolana','mozzarella';
execute InserimentoIngredientePizza 'Ortolana','verdure di stagione';
execute InserimentoIngredientePizza 'Patate e Salsiccia','mozzarella';
execute InserimentoIngredientePizza 'Patate e Salsiccia','patate';
execute InserimentoIngredientePizza 'Patate e Salsiccia','salsiccia';
execute InserimentoIngredientePizza 'Pomodorini','mozzarella';
execute InserimentoIngredientePizza 'Pomodorini','pomodorini';
execute InserimentoIngredientePizza 'Pomodorini','ricotta';
execute InserimentoIngredientePizza 'Quattro Formaggi','mozzarella';
execute InserimentoIngredientePizza 'Quattro Formaggi','provola';
execute InserimentoIngredientePizza 'Quattro Formaggi','gorgonzola';
execute InserimentoIngredientePizza 'Quattro Formaggi','grana';
execute InserimentoIngredientePizza 'Caprese','mozzarella';
execute InserimentoIngredientePizza 'Caprese','pomodoro fresco';
execute InserimentoIngredientePizza 'Caprese','basilico';
execute InserimentoIngredientePizza 'Zeus','mozzarella';
execute InserimentoIngredientePizza 'Zeus','bresaola';
execute InserimentoIngredientePizza 'Zeus','rucola';



--3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)

create procedure AggiornamentoPrezzoPizza
@nome varchar(20),
@prezzo decimal(4,2)
as
update Pizza set prezzo=@prezzo where nome=@nome
go

--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome ingrediente) 

create procedure EliminazioneIngredientePizza
@nomePizza varchar(20),
@nomeIngrediente varchar(20)
as
declare @codicePizza int
select @codicePizza=CodicePizza from Pizza
where Nome=@nomePizza
declare @codiceIngrediente int
select @codiceIngrediente=CodiceIngrediente from Ingrediente
where Nome=@nomeIngrediente
delete from PizzaIngrediente where codicePizza=@codicePizza and codiceIngrediente=@codiceIngrediente
go

--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente (parametro: nome ingrediente)

create procedure tassaIngrediente

@nomeIngrediente varchar(20)
as
declare @codiceIngrediente int
select @codiceIngrediente=CodiceIngrediente from Ingrediente
where Nome=@nomeIngrediente
update Pizza set Prezzo*=1.1 where CodicePizza in (select CodicePizza from PizzaIngrediente where CodiceIngrediente=@codiceIngrediente)
go

--1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)

create function listinoPizze ()
returns table
as
return select nome, prezzo from Pizza

select * from dbo.listinoPizze()
--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome ingrediente)

create function listinoPizzeConIngrediente (@nomeIngrediente varchar(20))
returns table
as
return select p.nome, p.prezzo 
from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
			 join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
where i.Nome=@nomeIngrediente

select * from dbo.listinoPizzeConIngrediente('pomodoro')
--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente (parametri: nome ingrediente)

create function listinoPizzeSenzaIngrediente (@nomeIngrediente varchar(20))
returns table
as
return select nome, prezzo from Pizza
where CodicePizza not in (select p.CodicePizza
						  from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
									   join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
						  where i.Nome=@nomeIngrediente)

select * from dbo.listinoPizzeSenzaIngrediente('pomodoro')

--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)

create function numeroPizzeConIngrediente (@nomeIngrediente varchar(20))
returns int
as
begin
declare @numeroPizze int
select @numeroPizze=Count(p.CodicePizza)
from Pizza p 
	 join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
	 join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
where i.Nome=@nomeIngrediente
return @numeroPizze
end

select nome as [Ingrediente], dbo.numeroPizzeConIngrediente(nome) as [Numero pizze con ingrediente] from Ingrediente

--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice ingrediente)

create function numeroPizzeSenzaIngrediente (@nomeIngrediente varchar(20))
returns int
as
begin
declare @numeroPizze int
select @numeroPizze=Count(CodicePizza)
from Pizza
where CodicePizza not in (select p.CodicePizza
						  from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
									   join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
						  where i.Nome=@nomeIngrediente)
return @numeroPizze
end

select nome as [Ingrediente], dbo.numeroPizzeSenzaIngrediente(nome) as [Numero pizze senza ingrediente] from Ingrediente

--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)

create function numeroIngredienti (@nomePizza varchar(20))
returns int
as
begin
declare @numeroPizze int
select @numeroPizze=count(*) from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
where Nome=@nomePizza
return @numeroPizze
end

select nome,dbo.numeroIngredienti(nome) as [Numero Ingredienti] from Pizza

create function listaIngredienti(@nomePizza varchar(20))
returns varchar(400)
as
begin 
declare @codicePizza int
select @codicePizza = CodicePizza from Pizza
where Nome=@nomePizza
return (select i.nome + ',' 
		from Ingrediente i 
		join PizzaIngrediente pin on i.CodiceIngrediente=pin.CodiceIngrediente
		where pin.CodicePizza=@codicePizza
		for XML PATH(''))
end

select dbo.listaIngredienti('Margherita') as [Ingredienti]

create view menu as 
(select p.Nome, p.Prezzo, 
		(dbo.listaIngredienti(p.Nome)) as [Ingredienti]
from Pizza p)
drop view menu;
select * from menu;
select * from PizzaIngrediente;
