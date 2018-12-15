/****** Object:  StoredProcedure [dbo].[procAddCartItem]    Script Date: 12/15/2018 12:59:33 AM ******/
DROP PROCEDURE [dbo].[procAddCartItem]
GO

/****** Object:  StoredProcedure [dbo].[procAddCartItem]    Script Date: 12/15/2018 12:59:33 AM ******/
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

	--UPDATE [dbo].[Product]
	--SET [OnHand] = [OnHand] - @Quantity
	--WHERE [ProductId] = @ProductId
END
GO

USE [JewelryMgmt]
GO

/****** Object:  StoredProcedure [dbo].[procAddCustomer]    Script Date: 12/15/2018 1:00:03 AM ******/
DROP PROCEDURE [dbo].[procAddCustomer]
GO

/****** Object:  StoredProcedure [dbo].[procAddCustomer]    Script Date: 12/15/2018 1:00:03 AM ******/
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


/****** Object:  StoredProcedure [dbo].[procCheckUser]    Script Date: 12/15/2018 1:00:23 AM ******/
DROP PROCEDURE [dbo].[procCheckUser]
GO

/****** Object:  StoredProcedure [dbo].[procCheckUser]    Script Date: 12/15/2018 1:00:23 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procClearCart]    Script Date: 12/15/2018 1:00:46 AM ******/
DROP PROCEDURE [dbo].[procClearCart]
GO

/****** Object:  StoredProcedure [dbo].[procClearCart]    Script Date: 12/15/2018 1:00:46 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 12/15/2018 1:01:02 AM ******/
DROP PROCEDURE [dbo].[procCreateAccount]
GO

/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 12/15/2018 1:01:02 AM ******/
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


/****** Object:  StoredProcedure [dbo].[procCreateOrder]    Script Date: 12/15/2018 1:01:21 AM ******/
DROP PROCEDURE [dbo].[procCreateOrder]
GO

/****** Object:  StoredProcedure [dbo].[procCreateOrder]    Script Date: 12/15/2018 1:01:21 AM ******/
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

			UPDATE P
		SET P.[OnHand] = P.[OnHand] - C.[Quantity]
	FROM [dbo].[Product] P
		INNER JOIN [dbo].[ShoppingCart] C ON 
			C.ProductId = P.ProductId
		WHERE C.[UserSessionId] = @SessionId 

			INSERT INTO [OrderDetail](OrderNo, OrderLineNo, ProductId, Quantity, UOM, IsActive, CreatedDate, CreatedBy)
			SELECT @orderId AS OrderID, 1, [ProductId], [Quantity], 'lbs', 1, GETDATE(), @Email
			FROM [dbo].[ShoppingCart]
			WHERE [UserSessionId] = @SessionId

			DELETE FROM  [dbo].[ShoppingCart]
		END
END


GO


/****** Object:  StoredProcedure [dbo].[procGetAllProducts]    Script Date: 12/15/2018 1:01:35 AM ******/
DROP PROCEDURE [dbo].[procGetAllProducts]
GO

/****** Object:  StoredProcedure [dbo].[procGetAllProducts]    Script Date: 12/15/2018 1:01:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procGetAllProducts]
AS
BEGIN
	SELECT P.ProductId
		  , ProductName
		  , ProductDescription
		  , UnitPrice
		  , (OnHand - ISNULL(C.Quantity, 0)) AS OnHand
		  , PCategoryId
		  , Image
	FROM [dbo].[Product] P
	LEFT JOIN [dbo].[ShoppingCart] C ON C.ProductId = P.ProductId

END
GO

/****** Object:  StoredProcedure [dbo].[procGetCartItem]    Script Date: 12/15/2018 1:01:53 AM ******/
DROP PROCEDURE [dbo].[procGetCartItem]
GO

/****** Object:  StoredProcedure [dbo].[procGetCartItem]    Script Date: 12/15/2018 1:01:53 AM ******/
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


/****** Object:  StoredProcedure [dbo].[procGetCartItems]    Script Date: 12/15/2018 1:02:09 AM ******/
DROP PROCEDURE [dbo].[procGetCartItems]
GO

/****** Object:  StoredProcedure [dbo].[procGetCartItems]    Script Date: 12/15/2018 1:02:09 AM ******/
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


/****** Object:  StoredProcedure [dbo].[procGetCategories]    Script Date: 12/15/2018 1:02:24 AM ******/
DROP PROCEDURE [dbo].[procGetCategories]
GO

/****** Object:  StoredProcedure [dbo].[procGetCategories]    Script Date: 12/15/2018 1:02:24 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procGetCustomerInfo]    Script Date: 12/15/2018 1:02:37 AM ******/
DROP PROCEDURE [dbo].[procGetCustomerInfo]
GO

/****** Object:  StoredProcedure [dbo].[procGetCustomerInfo]    Script Date: 12/15/2018 1:02:37 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procGetProductDetails]    Script Date: 12/15/2018 1:02:52 AM ******/
DROP PROCEDURE [dbo].[procGetProductDetails]
GO

/****** Object:  StoredProcedure [dbo].[procGetProductDetails]    Script Date: 12/15/2018 1:02:52 AM ******/
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
			, P.PCategoryId
			, Image
			, C.CategoryName
	 FROM [dbo].Product P
	 JOIN [dbo].ProductCategory C ON C.PCategoryId = p.PCategoryId
	 WHERE ProductId = @ProductId
END

GO


/****** Object:  StoredProcedure [dbo].[procGetPurchaseHistory]    Script Date: 12/15/2018 1:03:07 AM ******/
DROP PROCEDURE [dbo].[procGetPurchaseHistory]
GO

/****** Object:  StoredProcedure [dbo].[procGetPurchaseHistory]    Script Date: 12/15/2018 1:03:07 AM ******/
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


/****** Object:  StoredProcedure [dbo].[procIncreaseQuantity]    Script Date: 12/15/2018 1:03:27 AM ******/
DROP PROCEDURE [dbo].[procIncreaseQuantity]
GO

/****** Object:  StoredProcedure [dbo].[procIncreaseQuantity]    Script Date: 12/15/2018 1:03:27 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procQuantityChange]    Script Date: 12/15/2018 1:03:40 AM ******/
DROP PROCEDURE [dbo].[procQuantityChange]
GO

/****** Object:  StoredProcedure [dbo].[procQuantityChange]    Script Date: 12/15/2018 1:03:40 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procSubscribe]    Script Date: 12/15/2018 1:03:59 AM ******/
DROP PROCEDURE [dbo].[procSubscribe]
GO

/****** Object:  StoredProcedure [dbo].[procSubscribe]    Script Date: 12/15/2018 1:03:59 AM ******/
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

/****** Object:  StoredProcedure [dbo].[procUpdateCartItemQuantity]    Script Date: 12/15/2018 1:04:14 AM ******/
DROP PROCEDURE [dbo].[procUpdateCartItemQuantity]
GO

/****** Object:  StoredProcedure [dbo].[procUpdateCartItemQuantity]    Script Date: 12/15/2018 1:04:14 AM ******/
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

	--UPDATE [dbo].[Product]
 --   SET [OnHand] = [OnHand] - @Qty
 --   WHERE [ProductId] = @ProductId

	UPDATE [dbo].[ShoppingCart]
	SET [Quantity] = @Quantity
	WHERE [ProductId] = @ProductId AND [UserSessionId] = @UserSessionId

    --UPDATE [dbo].[Product]
    --SET [OnHand] = [OnHand] - @Quantity
    --WHERE [ProductId] = @ProductId
END

GO


