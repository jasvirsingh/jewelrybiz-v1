delete from [dbo].[Payment_Method]

INSERT INTO [dbo].[Payment_Method](PaymentMethodCode, MethodName, Description, IsActive, CreatedDate, CreatedBy)
VALUES('CR','Credit Card','Use of Credit Card',1, GETDATE(), 'admin')

INSERT INTO [dbo].[Payment_Method](PaymentMethodCode, MethodName, Description, IsActive, CreatedDate, CreatedBy)
VALUES('CK','Check','Use of Bank Check',1, GETDATE(), 'admin')

INSERT INTO [dbo].[Payment_Method](PaymentMethodCode, MethodName, Description, IsActive,  CreatedDate, CreatedBy)
VALUES('WT','Wire Transfer','Use of Wire Transfer',1, GETDATE(), 'admin')

INSERT INTO [dbo].[Payment_Method](PaymentMethodCode, MethodName, Description, IsActive,  CreatedDate, CreatedBy)
VALUES('CH','Cash Transfer','Use of Currency',1, GETDATE(), 'admin')

INSERT INTO [dbo].[Payment_Method](PaymentMethodCode, MethodName, Description, IsActive, CreatedDate, CreatedBy)
VALUES('DB','Debit Card','Use of Debit Card',1, GETDATE(), 'admin')