delete from [dbo].ShoppingCart
delete from [dbo].MaterialCategory
delete from [dbo].Product
delete from [dbo].ProductCategory

IF COL_LENGTH('ProductCategory', 'CategoryImage') IS NULL
BEGIN
    ALTER TABLE [dbo].ProductCategory
    ADD CategoryImage VARCHAR(MAX) NULL
END

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('MOTHER_BRACELET','Mothers bracelets',1, GETDATE(), 'admin', 'mother-bracelet.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('BABY_BRACELET','Baby/Christening bracelets',1, GETDATE(), 'admin','baby-bracelet.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('GRANDMOTHER_BRACELET','Grandmothers bracelets',1, GETDATE(), 'admin','grandma-bracelet.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('WEDDING_BRACELET','Wedding bracelets',1, GETDATE(), 'admin','wedding-bracelet.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('MOST_POPULAR','Most popular',1, GETDATE(), 'admin','most-popular.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('EARRING','Earrings',1, GETDATE(), 'admin','earings.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('NECKLACE','Necklaces',1, GETDATE(), 'admin','necklace.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('SET','Sets',1, GETDATE(), 'admin','sets.jpg')

INSERT INTO [dbo].ProductCategory(CategoryName, CategoryDescription, IsActive, CreatedDate, CreatedBy, CategoryImage)
VALUES('EVERYDAY_JEWELARY','Everyday jewelry',1, GETDATE(), 'admin','everyday-jewelry.png')
