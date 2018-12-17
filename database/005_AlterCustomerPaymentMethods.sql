IF COL_LENGTH('Customer_Payment_Method', 'ExpirationDate') IS NULL
BEGIN
    ALTER TABLE [dbo].Customer_Payment_Method
    ADD ExpirationDate date NOT NULL
END

IF COL_LENGTH('Customer_Payment_Method', 'AccountNo') IS NULL
BEGIN
    ALTER TABLE [dbo].Customer_Payment_Method
    ADD AccountNo varchar(50) NOT NULL
END

ALTER TABLE [dbo].Customer_Payment_Method ADD DEFAULT getdate() FOR CreatedDate
