USE [master]
GO
/****** Object:  Database [JewelryMgmt]    Script Date: 12/2/2018 12:22:34 PM ******/
CREATE DATABASE [JewelryMgmt]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'JewelryMgmt', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\JewelryMgmt.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'JewelryMgmt_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\JewelryMgmt_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [JewelryMgmt] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [JewelryMgmt].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [JewelryMgmt] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [JewelryMgmt] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [JewelryMgmt] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [JewelryMgmt] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [JewelryMgmt] SET ARITHABORT OFF 
GO
ALTER DATABASE [JewelryMgmt] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [JewelryMgmt] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [JewelryMgmt] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [JewelryMgmt] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [JewelryMgmt] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [JewelryMgmt] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [JewelryMgmt] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [JewelryMgmt] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [JewelryMgmt] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [JewelryMgmt] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [JewelryMgmt] SET  DISABLE_BROKER 
GO
ALTER DATABASE [JewelryMgmt] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [JewelryMgmt] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [JewelryMgmt] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [JewelryMgmt] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [JewelryMgmt] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [JewelryMgmt] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [JewelryMgmt] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [JewelryMgmt] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [JewelryMgmt] SET  MULTI_USER 
GO
ALTER DATABASE [JewelryMgmt] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [JewelryMgmt] SET DB_CHAINING OFF 
GO
ALTER DATABASE [JewelryMgmt] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [JewelryMgmt] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [JewelryMgmt]
GO
/****** Object:  StoredProcedure [dbo].[procAddCartItem]    Script Date: 12/2/2018 12:22:34 PM ******/
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

	INSERT INTO [dbo].[ShoppingCart]
           ([UserSessionId]
           ,[ProductId]
           ,[Quantity])
     VALUES
           (@UserSessionId
           ,@ProductId
           ,@Quantity)

	UPDATE [dbo].[Product]
	SET [OnHand] = [OnHand] - @Quantity
	WHERE [ProductId] = @ProductId
END
GO
/****** Object:  StoredProcedure [dbo].[procAddCustomer]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procAddCustomer]
(
 @FirstName varchar(50),
 @LastName varchar(50),
 @Phone varchar(50),
 @Addresss1 varchar(50),
 @Addresss2 varchar(50),
 @PostCode char(5),
 @State char(2),
 --@CardType varchar(50),
 --@CardNumber varchar(50),
 --@ExpDate datetime,
 @Email varchar(50)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE Email = @Email)
		BEGIN
				INSERT INTO [dbo].[Customer]
					   ([FirstName]
					   ,[LastName]
					   ,[Phone]
					   ,[Email]
					   ,[CreatedDate])
				 VALUES
					   (@FirstName
					   ,@LastName
					   ,@Phone
					   ,@Email
					   , GETDATE())
			
			Declare @customerId int
			Select @customerId = SCOPE_IDENTITY()

			   INSERT INTO [dbo].[Address]
					   ([CustomerId]
					   ,[AddressType]
					   ,[Address1]
					   ,[Address2]
					   ,[Postcode]
					   ,[State]
					   ,[IsActive]
					   ,[CreatedDate]
					   ,[CreatedBy]
					   ,[LastUpdatedDate]
					   ,[LastUpdatedBy])
				 VALUES
					   (@customerId
					   ,1
					   ,@Addresss1
					   ,@Addresss2
					   ,@PostCode
					   ,@State
					   ,1
					   ,GETDATE()
					   ,@Email
					   ,NULL
					   ,NULL)
		END
	ELSE
		BEGIN
		  UPDATE [dbo].[Customer]
		  SET [FirstName] = @FirstName,
		      [LastName] = @LastName,
			  [Phone] = @Phone,
			  [LastUpdatedDate] = GETDATE()
		  WHERE Email = @Email

		  UPDATE [dbo].[Address]
		  SET [Address1] = @Addresss1,
			  [Address2] = @Addresss2,
			  [Postcode] = @PostCode,
			  [State] = @State,
			  [LastUpdatedDate] = GETDATE(),
			  [LastUpdatedBy] = @Email
		END
END

GO
/****** Object:  StoredProcedure [dbo].[procCheckUser]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procCheckUser]
( 
	@Email varchar(50),
	@Password varchar(50)
)
AS
BEGIN
	
	SELECT U.* , R.RoleName
	FROM [dbo].[User] U
	JOIN [dbo].[Role] R ON R.RoleId = U.RoleId 
	WHERE U.Email = @Email
	   AND U.Password =@Password
	   AND U.IsActive = 1
END


GO
/****** Object:  StoredProcedure [dbo].[procClearCart]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procClearCart]
(
	@UserSessionId varchar(100)
)
AS
BEGIN

	UPDATE P
		SET P.[OnHand] = P.[OnHand] + C.[Quantity]
	FROM [dbo].[Product] P
		INNER JOIN [dbo].[ShoppingCart] C ON 
			C.ProductId = P.ProductId
		WHERE C.[UserSessionId] = @UserSessionId 

	DELETE
	FROM [dbo].[ShoppingCart]
	WHERE [UserSessionId] = @UserSessionId


END

GO
/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 12/2/2018 12:22:34 PM ******/
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
IF NOT EXISTS(SELECT 1 FROM [dbo].[User]  WHERE Email =@Email)
BEGIN
    Declare @roleId int
	SELECT @roleId = RoleId FROM [dbo].Role 
	WHERE RoleName = 'RegisteredCustomer' 

	INSERT INTO [dbo].[User] 
			( 
			Email, 
			Password,
			RoleId,
			IsActive,
			CreatedDate,
			CreatedBy)
	VALUES(
			 @Email,
			 @Password,
			 @roleId, -- 2 role id is for customer
			 1, --1 is for active
			 GETDATE(),
			 @Email
			 )
END
END

GO
/****** Object:  StoredProcedure [dbo].[procCreateOrder]    Script Date: 12/2/2018 12:22:34 PM ******/
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

	SELECT @customerId = CustomerId FROM [dbo].[Customer] WHERE Email = @Email
	IF @customerId > 0 
	BEGIN
			INSERT INTO [dbo].[Order]
				   (
				    [CustomerId]
					,[ShipmentId]
				   ,[OrderDate]
				   ,[ExpectedDeliveryDate]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   )
			 VALUES
				   (
				   @customerId
				   , 1
				   ,GETDATE()
				   ,GETDATE() + 5
				   ,GETDATE()
				   ,@Email)

			SELECT @orderId = @@IDENTITY

			INSERT INTO [OrderDetail](OrderNo, OrderLineNo, ProductId, Quantity, UOM, IsActive, CreatedDate, CreatedBy)
			SELECT @orderId AS OrderID, 1, [ProductId], [Quantity], 'lbs', 1, GETDATE(), @Email
			FROM [dbo].[ShoppingCart]
			WHERE [UserSessionId] = @SessionId

			DELETE FROM  [dbo].[ShoppingCart]
		END
END


GO
/****** Object:  StoredProcedure [dbo].[procGetAllProducts]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetAllProducts]
AS
BEGIN
	SELECT *
	FROM [dbo].[Product]
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCartItem]    Script Date: 12/2/2018 12:22:34 PM ******/
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
	SELECT C.ProductId
		 ,C.Quantity
		  ,P.OnHand
		  , P.ProductName
		  , P.UnitPrice
	FROM [dbo].[ShoppingCart] C
	JOIN [dbo].Product P ON P.ProductId = C.ProductId
	WHERE P.[ProductId] = @ProductId AND [UserSessionId] = @UserSessionId
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCartItems]    Script Date: 12/2/2018 12:22:34 PM ******/
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
	SELECT C.ProductId
		 ,C.Quantity
		  ,P.OnHand
		  , P.ProductName
		  , P.UnitPrice
	FROM [dbo].[ShoppingCart] C
	JOIN [dbo].Product P ON P.ProductId = C.ProductId
	WHERE [UserSessionId] = @UserSessionId
END

GO
/****** Object:  StoredProcedure [dbo].[procGetCategories]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetCategories]
AS
BEGIN
	SELECT * FROM [dbo].ProductCategory
	WHERE IsActive = 1
	ORDER BY PCategoryId
END

GO
/****** Object:  StoredProcedure [dbo].[procGetCustomerInfo]    Script Date: 12/2/2018 12:22:34 PM ******/
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
	SELECT C.FirstName,
		   C.LastName,
		   C.Email,
		   C.Phone,
		   A.Address1,
		   A.Address2,
		   A.Postcode,
		   A.State 
	FROM [dbo].Customer C
	JOIN [dbo].Address A ON A.CustomerId = C.CustomerId
	WHERE C.Email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[procGetProductDetails]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetProductDetails]
(
	@ProductId int
)
AS
BEGIN
	 SELECT  ProductId
			, ProductName
			, ProductDescription
			, OnHand
			, UnitPrice
			, PCategoryId
			, Image
	 FROM [dbo].Product
	 WHERE ProductId = @ProductId
END

GO
/****** Object:  StoredProcedure [dbo].[procGetPurchaseHistory]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procGetPurchaseHistory]
(
   @Email varchar(50)
 )
AS
BEGIN
    Declare @customerId int
  
	  SELECT @customerId = [CustomerId]
	  FROM [dbo].[Customer]
	  WHERE [Email] = @Email
	
	SELECT O.OrderDate, 
		   O.ExpectedDeliveryDate,
		   OD.Quantity,
		   (P.UnitPrice * OD.Quantity) as TotalAmount,
		   P.ProductName,
		   P.ProductDescription
	FROM [dbo].[Order] O
	JOIN [dbo].OrderDetail  OD ON OD.OrderNo = O.OrderNo
	JOIN [dbo].Product P ON P.ProductId = OD.ProductId
	WHERE O.CustomerId = @customerId
END

GO
/****** Object:  StoredProcedure [dbo].[procIncreaseQuantity]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procIncreaseQuantity]
(
	@UserSessionId varchar(100),
	@ProductId int
)
AS
BEGIN
	UPDATE [dbo].[ShoppingCart]
	SET [Quantity] = [Quantity] +1
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

    UPDATE [dbo].[Product]
    SET [OnHand] = [OnHand] - 1
    WHERE [ProductId] = @ProductId
END

GO
/****** Object:  StoredProcedure [dbo].[procQuantityChange]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
				UPDATE [dbo].[ShoppingCart]
				SET [Quantity] = [Quantity] +1
				WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

				UPDATE [dbo].[Product]
				SET [OnHand] = [OnHand] - 1
				WHERE [ProductId] = @ProductId
		END

		 IF @Action = '-'
		 BEGIN
				UPDATE [dbo].[ShoppingCart]
				SET [Quantity] = [Quantity] - 1
				WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

				UPDATE [dbo].[Product]
				SET [OnHand] = [OnHand] + 1
				WHERE [ProductId] = @ProductId
		END

		IF @Action = 'x'
		 BEGIN
			UPDATE P
				SET P.[OnHand] = P.[OnHand] + C.[Quantity]
			FROM [dbo].[Product] P
				INNER JOIN [dbo].[ShoppingCart] C ON 
					C.ProductId = P.ProductId
		     WHERE C.ProductId = @ProductId AND C.[UserSessionId] = @UserSessionId 

				DELETE
				FROM [dbo].[ShoppingCart]
				WHERE [UserSessionId] = @UserSessionId AND ProductId = @ProductId
		END

		Declare @quantity int
		SELECT @quantity = [Quantity]
		FROM [dbo].[ShoppingCart] 
		WHERE [ProductId] = @ProductId
		AND [UserSessionId] = @UserSessionId

		IF @quantity = 0
			BEGIN
				DELETE FROM [dbo].[ShoppingCart] 
					WHERE [ProductId] = @ProductId
					AND [UserSessionId] = @UserSessionId
			END 
END

GO
/****** Object:  StoredProcedure [dbo].[procSubscribe]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[procUpdateCartItemQuantity]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procUpdateCartItemQuantity]
(
	@UserSessionId varchar(100),
	@ProductId int,
	@Quantity int
)
AS
BEGIN
    Declare @Qty int
	SELECT @Qty = [Quantity]
	FROM [ShoppingCart]
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

	UPDATE [dbo].[Product]
    SET [OnHand] = [OnHand] - @Qty
    WHERE [ProductId] = @ProductId

	UPDATE [dbo].[ShoppingCart]
	SET [Quantity] = @Quantity
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

    UPDATE [dbo].[Product]
    SET [OnHand] = [OnHand] - @Quantity
    WHERE [ProductId] = @ProductId
END

GO
/****** Object:  Table [dbo].[Address]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Address](
	[AddressId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[AddressType] [int] NOT NULL,
	[Address1] [varchar](50) NOT NULL,
	[Address2] [varchar](50) NULL,
	[Postcode] [varchar](50) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer_Payment_Method]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer_Payment_Method](
	[CustomerPaymentMethodID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[PaymentMethodCode] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Customer_Payment_Method] PRIMARY KEY CLUSTERED 
(
	[CustomerPaymentMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Material]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Material](
	[MaterialId] [int] IDENTITY(1,1) NOT NULL,
	[MaterialName] [varchar](50) NOT NULL,
	[MaterialDescription] [varchar](200) NULL,
	[UnitCost] [decimal](18, 2) NOT NULL,
	[OnHand] [int] NOT NULL,
	[MCategoryId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED 
(
	[MaterialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MaterialCategory]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MaterialCategory](
	[MCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](50) NOT NULL,
	[CategoryDescription] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_MaterialCategory] PRIMARY KEY CLUSTERED 
(
	[MCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Order]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order](
	[OrderNo] [int] IDENTITY(100,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderNo] [int] NOT NULL,
	[OrderLineNo] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UOM] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Payment_Method]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Payment_Method](
	[PaymentMethodCode] [varchar](50) NOT NULL,
	[MethodName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
UNIQUE NONCLUSTERED 
(
	[PaymentMethodCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](50) NOT NULL,
	[ProductDescription] [varchar](200) NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[OnHand] [int] NOT NULL,
	[PCategoryId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[Image] [varchar](100) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product_Material]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product_Material](
	[ProductMaterialId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[MaterialId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Product_Material] PRIMARY KEY CLUSTERED 
(
	[ProductMaterialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductCategory](
	[PCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](50) NOT NULL,
	[CategoryDescription] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[PCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Report]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Report](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL,
	[RoleId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Report] PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Role]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Shipment]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Shipment](
	[ShipmentId] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](50) NOT NULL,
	[Destination] [varchar](200) NOT NULL,
	[ShipmentCostId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED 
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Shipment_Cost]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Shipment_Cost](
	[ShipmentCostId] [int] IDENTITY(1,1) NOT NULL,
	[Shipping_tier] [nvarchar](50) NOT NULL,
	[ShippingCost] [money] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Shipment_Cost] PRIMARY KEY CLUSTERED 
(
	[ShipmentCostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShoppingCart](
	[ShoppingCartId] [int] IDENTITY(1,1) NOT NULL,
	[UserSessionId] [varchar](100) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ShoppingCart_created_date]  DEFAULT (getdate()),
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[ShoppingCartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
	[Email] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_Subscription_IsActive]  DEFAULT ((1))
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UOM]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UOM](
	[UOM] [varchar](50) NOT NULL,
	[Description] [varchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_UOM] PRIMARY KEY CLUSTERED 
(
	[UOM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 12/2/2018 12:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[RoleId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
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
ALTER TABLE [dbo].[OrderDetail] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[Customer_Payment_Method]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[Customer_Payment_Method]  WITH CHECK ADD FOREIGN KEY([PaymentMethodCode])
REFERENCES [dbo].[Payment_Method] ([PaymentMethodCode])
GO
ALTER TABLE [dbo].[Material]  WITH CHECK ADD FOREIGN KEY([MCategoryId])
REFERENCES [dbo].[MaterialCategory] ([MCategoryId])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([OrderNo])
REFERENCES [dbo].[Order] ([OrderNo])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([OrderNo])
REFERENCES [dbo].[Order] ([OrderNo])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([UOM])
REFERENCES [dbo].[UOM] ([UOM])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([UOM])
REFERENCES [dbo].[UOM] ([UOM])
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([PCategoryId])
REFERENCES [dbo].[ProductCategory] ([PCategoryId])
GO
ALTER TABLE [dbo].[Product_Material]  WITH CHECK ADD FOREIGN KEY([MaterialId])
REFERENCES [dbo].[Material] ([MaterialId])
GO
ALTER TABLE [dbo].[Product_Material]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[Report]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD FOREIGN KEY([ShipmentCostId])
REFERENCES [dbo].[Shipment_Cost] ([ShipmentCostId])
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
USE [master]
GO
ALTER DATABASE [JewelryMgmt] SET  READ_WRITE 
GO
