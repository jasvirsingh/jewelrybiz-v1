
delete from [dbo].[Report]

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('MONTHLY_SALE'
           ,'Monthly Sale'
           ,1
           ,2
           ,getdate()
           ,'admin')

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('YEARLY_SALE'
           ,'Yearly Sale '
           ,1
           ,2
           ,getdate()
           ,'admin')

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('INVENTORY_LEVELS'
           ,'Inventory Levels'
           ,1
           ,2
           ,getdate()
           ,'admin')

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('INVENTORY_COSTS'
           ,'Inventory Costs'
           ,1
           ,2
           ,getdate()
           ,'admin')

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('CUSTOMER_LIST'
           ,'Customer Lists'
           ,1
           ,2
           ,getdate()
           ,'admin')

INSERT INTO [dbo].[Report]
           ([ReportName]
           ,[Description]
           ,[IsActive]
           ,[RoleId]
           ,[CreatedDate]
           ,[CreatedBy])
     VALUES
           ('MAILING_LABELS'
           ,'Mailing Labels'
           ,1
           ,2
           ,getdate()
           ,'admin')
GO


