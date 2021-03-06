USE [master]
GO
/****** Object:  Database [Pizzeria]    Script Date: 17/12/2021 15:24:43 ******/
CREATE DATABASE [Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pizzeria', FILENAME = N'C:\Users\Luca.finoia\Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Pizzeria_log', FILENAME = N'C:\Users\Luca.finoia\Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Pizzeria] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Pizzeria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Pizzeria] SET QUERY_STORE = OFF
GO
USE [Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[listaIngredienti]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[listaIngredienti](@nomePizza varchar(20))
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
GO
/****** Object:  UserDefinedFunction [dbo].[numeroIngredienti]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[numeroIngredienti] (@nomePizza varchar(20))
returns int
as
begin
declare @numeroPizze int
select @numeroPizze=count(*) from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
where Nome=@nomePizza
return @numeroPizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[numeroPizzeConIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[numeroPizzeConIngrediente] (@nomeIngrediente varchar(20))
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
GO
/****** Object:  UserDefinedFunction [dbo].[numeroPizzeSenzaIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[numeroPizzeSenzaIngrediente] (@nomeIngrediente varchar(20))
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
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[CodicePizza] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](20) NULL,
	[Prezzo] [decimal](4, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[listinoPizze]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[listinoPizze] ()
returns table
as
return select nome, prezzo from Pizza
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[CodiceIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](20) NULL,
	[Costo] [decimal](4, 2) NULL,
	[QuantitaInMagazino] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PizzaIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PizzaIngrediente](
	[CodicePizza] [int] NOT NULL,
	[CodiceIngrediente] [int] NOT NULL,
 CONSTRAINT [PK_PI_IN] PRIMARY KEY CLUSTERED 
(
	[CodicePizza] ASC,
	[CodiceIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[listinoPizzeConIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[listinoPizzeConIngrediente] (@nomeIngrediente varchar(20))
returns table
as
return select p.nome, p.prezzo 
from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
			 join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
where i.Nome=@nomeIngrediente
GO
/****** Object:  UserDefinedFunction [dbo].[listinoPizzeSenzaIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[listinoPizzeSenzaIngrediente] (@nomeIngrediente varchar(20))
returns table
as
return select nome, prezzo from Pizza
where CodicePizza not in (select p.CodicePizza
						  from Pizza p join PizzaIngrediente pin on p.CodicePizza=pin.CodicePizza
									   join Ingrediente i on pin.CodiceIngrediente = i.CodiceIngrediente
						  where i.Nome=@nomeIngrediente)
GO
/****** Object:  View [dbo].[menu]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[menu] as 
(select p.Nome, p.Prezzo, 
		(dbo.listaIngredienti(p.Nome)) as [Ingredienti]
from Pizza p)
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (1, N'pomodoro', CAST(0.50 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (2, N'mozzarella', CAST(1.00 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (3, N'mozzarella di bufala', CAST(2.00 AS Decimal(4, 2)), 3)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (4, N'spianata piccante', CAST(1.50 AS Decimal(4, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (5, N'funghi', CAST(1.00 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (6, N'carciofi', CAST(1.50 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (7, N'cotto', CAST(1.00 AS Decimal(4, 2)), 3)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (8, N'olive', CAST(1.00 AS Decimal(4, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (9, N'funghi porcini', CAST(2.00 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (10, N'stracchino', CAST(1.00 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (11, N'speck', CAST(1.50 AS Decimal(4, 2)), 3)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (12, N'rucola', CAST(1.00 AS Decimal(4, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (13, N'grana', CAST(1.00 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (14, N'verdure di stagione', CAST(1.50 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (15, N'patate', CAST(1.00 AS Decimal(4, 2)), 3)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (16, N'salsiccia', CAST(1.00 AS Decimal(4, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (17, N'pomodorini', CAST(1.00 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (18, N'ricotta', CAST(1.00 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (19, N'provola', CAST(1.00 AS Decimal(4, 2)), 3)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (20, N'gorgonzola', CAST(1.00 AS Decimal(4, 2)), 4)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (21, N'pomodoro fresco', CAST(1.00 AS Decimal(4, 2)), 1)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (22, N'basilico', CAST(0.50 AS Decimal(4, 2)), 2)
INSERT [dbo].[Ingrediente] ([CodiceIngrediente], [Nome], [Costo], [QuantitaInMagazino]) VALUES (23, N'bresaola', CAST(1.00 AS Decimal(4, 2)), 3)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (2, N'Bufala', CAST(7.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (4, N'Quattro Stagioni', CAST(6.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (6, N'Dioniso', CAST(8.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (8, N'Patate e Salsiccia', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (10, N'Quattro Formaggi', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (11, N'Caprese', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([CodicePizza], [Nome], [Prezzo]) VALUES (12, N'Zeus', CAST(7.50 AS Decimal(4, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (1, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (2, 3)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (3, 4)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 5)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 6)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 7)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (4, 8)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (5, 9)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 10)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 11)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 12)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (6, 13)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 1)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (7, 14)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 15)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (8, 16)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 17)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (9, 18)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 13)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 19)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (10, 20)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 21)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (11, 22)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 2)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 12)
INSERT [dbo].[PizzaIngrediente] ([CodicePizza], [CodiceIngrediente]) VALUES (12, 23)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Ingredie__7D8FE3B206D97487]    Script Date: 17/12/2021 15:24:43 ******/
ALTER TABLE [dbo].[Ingrediente] ADD UNIQUE NONCLUSTERED 
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Pizza__7D8FE3B246E5BD5E]    Script Date: 17/12/2021 15:24:43 ******/
ALTER TABLE [dbo].[Pizza] ADD UNIQUE NONCLUSTERED 
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Ingrediente] FOREIGN KEY([CodiceIngrediente])
REFERENCES [dbo].[Ingrediente] ([CodiceIngrediente])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Ingrediente]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_Pizza] FOREIGN KEY([CodicePizza])
REFERENCES [dbo].[Pizza] ([CodicePizza])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_Pizza]
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([Costo]>(0)))
GO
ALTER TABLE [dbo].[Ingrediente]  WITH CHECK ADD CHECK  (([QuantitaInMagazino]>=(0)))
GO
ALTER TABLE [dbo].[Pizza]  WITH CHECK ADD CHECK  (([Prezzo]>(0)))
GO
/****** Object:  StoredProcedure [dbo].[AggiornamentoPrezzoPizza]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[AggiornamentoPrezzoPizza]
@nome varchar(20),
@prezzo decimal(4,2)
as
update Pizza set prezzo=@prezzo where nome=@nome
GO
/****** Object:  StoredProcedure [dbo].[EliminazioneIngredientePizza]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminazioneIngredientePizza]
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
GO
/****** Object:  StoredProcedure [dbo].[InserimentoIngredientePizza]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserimentoIngredientePizza]
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
GO
/****** Object:  StoredProcedure [dbo].[InserimentoPizza]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserimentoPizza]
@nome varchar(20),
@prezzo decimal(4,2)
as
insert into Pizza values(@nome,@prezzo)
GO
/****** Object:  StoredProcedure [dbo].[tassaIngrediente]    Script Date: 17/12/2021 15:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[tassaIngrediente]

@nomeIngrediente varchar(20)
as
declare @codiceIngrediente int
select @codiceIngrediente=CodiceIngrediente from Ingrediente
where Nome=@nomeIngrediente
update Pizza set Prezzo*=1.1 where CodicePizza in (select CodicePizza from PizzaIngrediente where CodiceIngrediente=@codiceIngrediente)
GO
USE [master]
GO
ALTER DATABASE [Pizzeria] SET  READ_WRITE 
GO
