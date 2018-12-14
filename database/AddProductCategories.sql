delete from [dbo].Product
delete from [dbo].ProductCategory

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('MOTHER_BRACELET','Mothers bracelets',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('BABY_BRACELET','Baby/Christening bracelets',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('GRANDMOTHER_BRACELET','Grandmothers bracelets',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('WEDDING_BRACELET','Wedding bracelets',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('MOST_POPULAR','Most popular',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('EARRING','Earrings',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('NECKLACE','Necklaces',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('SET','Sets',1, GETDATE(), 'admin')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy)
VALUES('EVERYDAY_JEWELARY','Everyday jewelry',1, GETDATE(), 'admin')
