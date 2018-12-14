USE [JewelryMgmt]
GO

/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 12/13/2018 9:03:08 PM ******/
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


CREATE PROCEDURE [dbo].[procGetAllProducts]
AS
BEGIN
	SELECT *
	FROM [dbo].[Product]
END
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

CREATE PROCEDURE [dbo].[procGetCategories]
AS
BEGIN
	SELECT * FROM [dbo].ProductCategory
	WHERE IsActive = 1
	ORDER BY PCategoryId
END

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



