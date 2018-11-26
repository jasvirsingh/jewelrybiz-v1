USE [master]
GO
/****** Object:  Database [JewelryBiz]    Script Date: 11/26/2018 1:14:48 AM ******/
CREATE DATABASE [JewelryBiz]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'JewelryBiz', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\JewelryBiz.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'JewelryBiz_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\JewelryBiz_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [JewelryBiz] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [JewelryBiz].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [JewelryBiz] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [JewelryBiz] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [JewelryBiz] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [JewelryBiz] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [JewelryBiz] SET ARITHABORT OFF 
GO
ALTER DATABASE [JewelryBiz] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [JewelryBiz] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [JewelryBiz] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [JewelryBiz] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [JewelryBiz] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [JewelryBiz] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [JewelryBiz] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [JewelryBiz] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [JewelryBiz] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [JewelryBiz] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [JewelryBiz] SET  DISABLE_BROKER 
GO
ALTER DATABASE [JewelryBiz] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [JewelryBiz] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [JewelryBiz] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [JewelryBiz] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [JewelryBiz] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [JewelryBiz] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [JewelryBiz] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [JewelryBiz] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [JewelryBiz] SET  MULTI_USER 
GO
ALTER DATABASE [JewelryBiz] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [JewelryBiz] SET DB_CHAINING OFF 
GO
ALTER DATABASE [JewelryBiz] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [JewelryBiz] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [JewelryBiz]
GO
/****** Object:  StoredProcedure [dbo].[procAddCartItem]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procAddCartItem]
	(
	@UserSessionId varchar(100),
	@ProductId int,
	@PName varchar(50),
	@UnitPrice money,
	@Quantity int
	)
AS
BEGIN

	INSERT INTO [dbo].[ShoppingCartData]
           ([UserSessionId]
           ,[ProductId]
           ,[PName]
           ,[UnitPrice]
           ,[Quantity])
     VALUES
           (@UserSessionId
           ,@ProductId
           ,@PName
           ,@UnitPrice
           ,@Quantity)

	UPDATE [dbo].[Products]
	SET [UnitsInStock] = [UnitsInStock] - 1
	WHERE [ProductId] = @ProductId
END

GO
/****** Object:  StoredProcedure [dbo].[procAddCustomer]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procAddCustomer]
(
 @FirstName varchar(50),
 @LastName varchar(50),
 @Phone varchar(50),
 @Addresss1 varchar(5),
 @Addresss2 varchar(50),
 @PostCode char(5),
 @State char(2),
 @CardType varchar(50),
 @CardNumber varchar(50),
 @ExpDate datetime,
 @Email varchar(50)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Customers] WHERE Email = @Email)
		BEGIN
				INSERT INTO [dbo].[Customers]
					   ([FName]
					   ,[LName]
					   ,[Phone]
					   ,[Address1]
					   ,[Address2]
					   ,[Postcode]
					   ,[State]
					   ,[CardType]
					   ,[CardNo]
					   ,[ExpDate]
					   ,[Email])
				 VALUES
					   (@FirstName
					   ,@LastName
					   ,@Phone
					   ,@Addresss1
					   ,@Addresss2
					   ,@PostCode
					   ,@State
					   ,@CardType
					   ,@CardNumber
					   ,@ExpDate
					   ,@Email)
		END
	ELSE
		BEGIN
		  UPDATE [dbo].[Customers]
		  SET [FName] = @FirstName,
		      [LName] = @LastName,
			  [Phone] = @Phone,
			  [Address1] = @Addresss1,
			  [Address2] = @Addresss2,
			  [Postcode] = @PostCode,
			  [State] = @State,
			  [CardType] = @CardType,
			  [CardNo] = @CardNumber,
			  [ExpDate] = @ExpDate
		  WHERE Email = @Email
		END
END

GO
/****** Object:  StoredProcedure [dbo].[procCheckUser]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procCheckUser]
( 
@Email varchar(50),
@Password varchar(50)
)
AS
BEGIN
	
	SELECT * FROM [dbo].Users
	WHERE Email = @Email
	   AND Password =@Password
END

GO
/****** Object:  StoredProcedure [dbo].[procClearCart]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procClearCart]
(
@UserSessionId varchar(100)
)
AS
BEGIN

	UPDATE P
		SET P.[UnitsInStock] = P.[UnitsInStock] + C.[Quantity]
	FROM [dbo].[Products] P
		INNER JOIN [dbo].[ShoppingCartData] C ON 
			C.ProductId = P.ProductId
		WHERE C.[UserSessionId] = @UserSessionId 

	DELETE
	FROM [dbo].[ShoppingCartData]
	WHERE [UserSessionId] = @UserSessionId


END

GO
/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jasvir Singh
-- Create date: 11/21/2018
-- Description:	This procedure creates user
-- =============================================
CREATE PROCEDURE [dbo].[procCreateAccount]
(
	@Email varchar(50),
	@Password varchar(50)
)
AS
BEGIN
IF NOT EXISTS(SELECT 1 FROM Users WHERE Email =@Email)
BEGIN
	INSERT INTO [dbo].Users 
			( 
			Email, 
			Password,
			RoleId,
			CreateDate)
	VALUES(
			 @Email,
			 @Password,
			 2,
			 GETDATE()
			 )
END
END

GO
/****** Object:  StoredProcedure [dbo].[procCreateOrder]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procCreateOrder] 
	(@SessionId varchar(100),
	 @Email varchar(50)
	 )
AS
BEGIN
    Declare @customerId int
	Declare @orderId int

	SELECT @customerId = CustomerId FROM [dbo].[Customers] WHERE Email = @Email
	IF @customerId > 0 
	BEGIN
			INSERT INTO [dbo].[Orders]
				   ([OrderDate]
				   ,[DeliveryDate]
				   ,[CustomerId])
			 VALUES
				   (GETDATE()
				   ,GETDATE() + 5
				   ,@customerId)

			SELECT @orderId = @@IDENTITY

			INSERT INTO [Order_Products]
			SELECT @orderId AS OrderID, [ProductId], [Quantity], ([Quantity] *[UnitPrice])
			FROM [dbo].[ShoppingCartData]
			WHERE [UserSessionId] = @SessionId

			DELETE FROM  [dbo].[ShoppingCartData]
		END
END

GO
/****** Object:  StoredProcedure [dbo].[procDecreaseUnitInStock]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procDecreaseUnitInStock]
(
@ProductId int
)
AS
BEGIN
	UPDATE [dbo].[Products]
    SET [UnitsInStock] = [UnitsInStock] - 1
    WHERE [ProductId] = @ProductId
END

GO
/****** Object:  StoredProcedure [dbo].[procGetAllProducts]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetAllProducts]
AS
BEGIN
	SELECT *
	FROM [dbo].[Products]
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCartItem]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procGetCartItem]
	(
@UserSessionId varchar(100),
@ProductId int
)
AS
BEGIN
	SELECT * FROM [dbo].[ShoppingCartData]
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCartItems]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetCartItems]
(
@UserSessionId varchar(100)
)
AS
BEGIN
	SELECT *
	FROM [dbo].[ShoppingCartData]
	WHERE [UserSessionId] = @UserSessionId
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCategories]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procGetCategories]
AS
BEGIN
	SELECT * FROM [dbo].Categories 
	WHERE IsActive = 1
	ORDER BY CategoryId
END

GO
/****** Object:  StoredProcedure [dbo].[procGetCustomerInfo]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procGetCustomerInfo]
(
	@Email varchar(50)
)
AS
BEGIN
	SELECT * FROM [dbo].Customers
	WHERE Email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[procGetPurchaseHistory]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procGetPurchaseHistory]
(
   @Email varchar(50)
 )
AS
BEGIN
    Declare @customerId int
  
	  SELECT @customerId = [CustomerId]
	  FROM [dbo].[Customers]
	  WHERE [Email] = @Email
	
	SELECT O.OrderDate, 
		   O.DeliveryDate,
		   OP.Qty,
		   OP.TotalSale as TotalAmount,
		   P.PName
	FROM [dbo].Orders O
	JOIN [dbo].Order_Products OP ON OP.OrderID = O.OrderID
	JOIN [dbo].Products P ON P.ProductId = OP.ProductId
	WHERE O.CustomerId = @customerId
END

GO
/****** Object:  StoredProcedure [dbo].[procIncreaseQuantity]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procIncreaseQuantity]
(
@UserSessionId varchar(100),
@ProductId int
)
AS
BEGIN
	UPDATE [dbo].[ShoppingCartData]
	SET [Quantity] = [Quantity] +1
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

    UPDATE [dbo].[Products]
    SET [UnitsInStock] = [UnitsInStock] - 1
    WHERE [ProductId] = @ProductId
END

GO
/****** Object:  StoredProcedure [dbo].[procQuantityChange]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procQuantityChange]
(
@UserSessionId varchar(100),
@ProductId int,
@Action char(1)
)
AS
BEGIN
    IF @Action = '+'
		 BEGIN
				UPDATE [dbo].[ShoppingCartData]
				SET [Quantity] = [Quantity] +1
				WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

				UPDATE [dbo].[Products]
				SET [UnitsInStock] = [UnitsInStock] - 1
				WHERE [ProductId] = @ProductId
		END

		 IF @Action = '-'
		 BEGIN
				UPDATE [dbo].[ShoppingCartData]
				SET [Quantity] = [Quantity] - 1
				WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

				UPDATE [dbo].[Products]
				SET [UnitsInStock] = [UnitsInStock] + 1
				WHERE [ProductId] = @ProductId
		END

		IF @Action = 'x'
		 BEGIN
			UPDATE P
				SET P.[UnitsInStock] = P.[UnitsInStock] + C.[Quantity]
			FROM [dbo].[Products] P
				INNER JOIN [dbo].[ShoppingCartData] C ON 
					C.ProductId = P.ProductId
		     WHERE C.ProductId = @ProductId AND C.[UserSessionId] = @UserSessionId 

				DELETE
				FROM [dbo].[ShoppingCartData]
				WHERE [UserSessionId] = @UserSessionId AND ProductId = @ProductId
		END

		Declare @quantity int
		SELECT @quantity = [Quantity]
		FROM [dbo].[ShoppingCartData] 
		WHERE [ProductId] = @ProductId
		AND [UserSessionId] = @UserSessionId

		IF @quantity = 0
			BEGIN
				DELETE FROM [dbo].[ShoppingCartData] 
					WHERE [ProductId] = @ProductId
					AND [UserSessionId] = @UserSessionId
			END 
END

GO
/****** Object:  StoredProcedure [dbo].[procSubscribe]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[procSubscribe]
(
@Email varchar(50)
)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM [dbo].Subscription WHERE Email = @Email)
	BEGIN
	INSERT INTO Subscription(Email, IsActive)
	VALUES(@Email, 1)
	END
END

GO
/****** Object:  Table [dbo].[Categories]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](50) NOT NULL,
	[ParentCategoryId] [int] NOT NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CategoryConfiguration]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CategoryConfiguration](
	[ConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[ConfigurationName] [varchar](50) NOT NULL,
	[Description] [varchar](100) NULL,
 CONSTRAINT [PK_CategoryConfiguration] PRIMARY KEY CLUSTERED 
(
	[ConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[FName] [varchar](50) NOT NULL,
	[LName] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[Address1] [varchar](50) NOT NULL,
	[Address2] [varchar](50) NULL,
	[Postcode] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[CardType] [varchar](50) NOT NULL,
	[CardNo] [varchar](50) NOT NULL,
	[ExpDate] [datetime] NOT NULL,
	[Email] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order_Products]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Products](
	[OrderID] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[TotalSale] [money] NOT NULL,
 CONSTRAINT [PK_Order_Products] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[PName] [varchar](50) NOT NULL,
	[Brand] [varchar](50) NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitsInStock] [int] NOT NULL,
	[Category] [varchar](50) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[ROL] [int] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductStock]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductStock](
	[ProductNumber] [varchar](50) NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[Description] [varchar](500) NULL,
	[CategoryId] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitsInStock] [int] NOT NULL,
	[Brand] [varchar](50) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShoppingCartData]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShoppingCartData](
	[TempOrderID] [int] IDENTITY(1,1) NOT NULL,
	[UserSessionId] [varchar](100) NOT NULL,
	[ProductId] [int] NOT NULL,
	[PName] [varchar](50) NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_ShoppingCartData] PRIMARY KEY CLUSTERED 
(
	[TempOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
	[Email] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_Subscription_IsActive]  DEFAULT ((1))
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/26/2018 1:14:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[RoleId] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Order_Products]  WITH CHECK ADD  CONSTRAINT [FK_Order_Products_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order_Products] CHECK CONSTRAINT [FK_Order_Products_Orders]
GO
ALTER TABLE [dbo].[Order_Products]  WITH CHECK ADD  CONSTRAINT [FK_Order_Products_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Order_Products] CHECK CONSTRAINT [FK_Order_Products_Products]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO
USE [master]
GO
ALTER DATABASE [JewelryBiz] SET  READ_WRITE 
GO
