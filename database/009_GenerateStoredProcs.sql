USE [JewelryMgmt]
GO
/****** Object:  StoredProcedure [dbo].[CreateOrderDetail]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateOrderDetail]
(@OrderNo Int ,
@OrderLineNo int,
@ProductId int,
@Quantity int
)
AS
BEGIN
	
	Declare @Active Bit
	Declare @Today Datetime
	Declare @OrderDate date
	
	
	Set @OrderDate = GETDATE()
	Set @Active = 1
	Set @Today = GetDate()

	

INSERT INTO [dbo].[OrderDetail]
           ([OrderNo]
           ,[OrderLineNo]
           ,[ProductId]
           ,[Quantity]
           ,[UOM]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[LastUpdatedDate]
           ,[LastUpdatedBy])
     VALUES
           (@OrderNo
           ,@OrderLineNo
           ,@ProductId
           ,@Quantity
           ,'EA'
           ,@Active
           ,@Today
           ,'admin'
           ,GetDate()
           ,'admin')
     
END
GO
/****** Object:  StoredProcedure [dbo].[GetFinishedGoodsInvLvls]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFinishedGoodsInvLvls]
AS
BEGIN
	
Select 
     P.ProductName AS FinishedGoodName,P.ProductDescription As FinishedGood_Descr,
	 P.OnHand As OnHandInventory, (P.OnHand*p.UnitPrice) As FG_InventoryCost
	From  Product AS P 
Order by  P.ProductName
   

END
GO
/****** Object:  StoredProcedure [dbo].[GetMonthlySales]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMonthlySales]
AS
BEGIN
Select 
     Year(O.OrderDate) as Sales_Year, Month(O.OrderDate) AS Sales_month, P.ProductName, SUM (OD.Quantity) As SalesNumber 
	From  [Order] AS O 
	Inner join [OrderDetail] AS OD on 
		O.OrderNo = OD.OrderNo
	Inner join [Product] AS P on 
	     OD.ProductId = P.ProductId
Group by Year(O.OrderDate), Month(O.OrderDate), P.ProductName
Order by Year(O.OrderDate), Month(O.OrderDate)
   

END
GO
/****** Object:  StoredProcedure [dbo].[GetRawMaterialInvLvls]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetRawMaterialInvLvls]
AS
BEGIN
	
Select 
     M.MaterialName As RawMaterial_Name,M.MaterialDescription As RawMaterial_Descr,
	 M.OnHand As OnHandInventory, (M.OnHand*M.UnitCost) As InventoryCost
	From  [Material] AS M 
Order by  M.MaterialName
   

END
GO
/****** Object:  StoredProcedure [dbo].[GetYearlySales]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetYearlySales]
AS
BEGIN
	--Declare @Month1 int,
	--        @Year1 int,
	--	    @Date  DATE

	--Select @Date = GETDATE()
	--Select @Month1 = Month(@Date) 
	--Select @Year1 = Year(@Date)

	--print @Month1
	--print @Year1


Select 
     Year(O.OrderDate) as Sales_Year, P.ProductName, SUM (OD.Quantity) As SalesNumber 
	From  [Order] AS O 
	Inner join [OrderDetail] AS OD on 
		O.OrderNo = OD.OrderNo
	Inner join [Product] AS P on 
	     OD.ProductId = P.ProductId
Group by  Year(O.OrderDate), P.ProductName
Order by  Year(O.OrderDate)
   

END
GO
/****** Object:  StoredProcedure [dbo].[procAddCartItem]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procAddCustomer]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procAddCustomer]
(
 @FirstName varchar(50),
 @LastName varchar(50),
 @Phone varchar(50),
 @Address1 varchar(50),
 @Address2 varchar(50),
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
					   ,@Address1
					   ,@Address2
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
		  SET [Address1] = @Address1,
			  [Address2] = @Address2,
			  [Postcode] = @PostCode,
			  [State] = @State,
			  [LastUpdatedDate] = GETDATE(),
			  [LastUpdatedBy] = @Email
		END
END


GO
/****** Object:  StoredProcedure [dbo].[procAddCustomerPaymentMethod]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procAddCustomerPaymentMethod]
( @Email varchar(50)
, @PaymentMethodCode varchar(50)
, @ExpirationDate date
, @AccountNo varchar(50)
)
AS

Declare @customerId int
SELECT @customerId = CustomerId FROM [dbo].[Customer] WHERE Email = @Email

INSERT INTO [dbo].[Customer_Payment_Method]
           ([CustomerId]
           ,[PaymentMethodCode]
           ,[IsActive]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[LastUpdatedDate]
           ,[LastUpdatedBy]
           ,[ExpirationDate]
           ,[AccountNo])
     VALUES
           (@customerId
           ,@PaymentMethodCode
           ,1
           ,getdate()
           ,@Email
           ,null
           ,null
           ,@ExpirationDate
           ,@AccountNo
		   )

GO
/****** Object:  StoredProcedure [dbo].[procCheckUser]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procClearCart]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procCreateAccount]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procCreateOrder]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procCreateOrder] 
	(@SessionId varchar(100),
	 @Email varchar(50),
	  @ShippingCost int = 0
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
				   ,[OrderDate]
				   ,[ExpectedDeliveryDate]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   )
			 VALUES
				   (
				   @customerId
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
/****** Object:  StoredProcedure [dbo].[procGetAllProducts]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetCartItem]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetCartItems]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetCategories]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetCustomerInfo]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetCustomerProfile]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procGetCustomerProfile]
(
	@Email varchar(50)

)
AS
BEGIN
   SELECT C.[FirstName]
      ,C.[LastName]
      ,C.[Phone]
      ,C.[Email]
      ,C.[CreatedDate]
	  ,A.[Address1]
	  ,A.[Address2]
	  ,A.Postcode
	  ,A.State
	  ,ISNULL(P1.MethodName,'') AS MethodName
	  ,ISNULL(P.AccountNo,'') AS AccountNo
	  ,ISNULL(P.ExpirationDate, '') AS ExpirationDate
FROM [dbo].[Customer] C
JOIN [dbo].Address A ON A.CustomerId = C.CustomerId
LEFT JOIN [dbo].Customer_Payment_Method P ON P.CustomerId = C.CustomerId
LEFT JOIN [dbo].Payment_Method P1 ON P1.PaymentMethodCode = P.PaymentMethodCode
END
GO
/****** Object:  StoredProcedure [dbo].[procGetCustomers]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procGetCustomers]
AS
SELECT C.[FirstName]
      ,C.[LastName]
      ,C.[Phone]
      ,C.[Email]
      ,C.[CreatedDate]
	  ,A.[Address1]
	  ,A.[Address2]
	  ,A.Postcode
	  ,A.State
FROM [dbo].[Customer] C
JOIN [dbo].Address A ON A.CustomerId = C.CustomerId

GO
/****** Object:  StoredProcedure [dbo].[procGetPaymentMethods]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procGetPaymentMethods]
AS
SELECT 
		PaymentMethodCode
		, MethodName
		, Description
FROM [dbo].Payment_Method
WHERE IsActive = 1
GO
/****** Object:  StoredProcedure [dbo].[procGetProductDetails]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetProductMaterial]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[procGetProductMaterial]
(
	@PCategoryId int
)

AS
	
	SELECT 
		C.CategoryName
		,C.CategoryDescription
		,M.MaterialName
		,M.MaterialDescription
		,M.MaterialId
	 FROM [dbo].[Material] M
	JOIN [dbo].[MaterialCategory] C ON C.MCategoryId = M.MCategoryId
	WHERE C.PCategoryId = @PCategoryId
	AND C.IsActive = 1
	AND M.IsActive = 1

GO
/****** Object:  StoredProcedure [dbo].[procGetPurchaseHistory]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procGetReports]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[procGetReports]

AS
	BEGIN
	Declare @roleId int
	SELECT @roleId = RoleId 
	FROM [dbo].Role 
	WHERE RoleName = 'Admin'
	
	SELECT 
		   [ReportName]
		  ,[Description]
	  FROM [JewelryMgmt].[dbo].[Report]
	  WHERE IsActive = 1 AND RoleId = @roleId
  END


GO
/****** Object:  StoredProcedure [dbo].[procIncreaseQuantity]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procQuantityChange]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procSearch]    Script Date: 12/18/2018 8:28:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procSearch]
(
 @searchStr varchar(50)
)

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
	WHERE P.ProductName LIKE '%'+ @searchStr +'%'
END
GO
/****** Object:  StoredProcedure [dbo].[procSubscribe]    Script Date: 12/18/2018 8:28:02 PM ******/
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
/****** Object:  StoredProcedure [dbo].[procUpdateCartItemQuantity]    Script Date: 12/18/2018 8:28:02 PM ******/
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
