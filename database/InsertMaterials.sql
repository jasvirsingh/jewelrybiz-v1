delete from [dbo].Material
delete from [dbo].MaterialCategory

Declare @categoryId int
INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Metal','Metal',1)
select @categoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Gold','Gold',800.00, 200, @categoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Silver','Silver',200.00, 300, @categoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Platinum','Platinum',450.00, 100, @categoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('WhiteGold','White Gold',1000.00, 400, @categoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Tungstun','Tungstun',1000.00, 250, @categoryId)


INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Pearl','Pearl',1)
select @categoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('BlackPearl','Black Pearl',4000.00, 210, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('WhitePearl','White Pearl',3000.00, 110, @categoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Birthstone','Birthstone',1)
select @categoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('January-Garnet','January-Garnet',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('February-Amethyst','February-Amethyst',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('March-Aquamarine','March-Aquamarine',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('April-ClearCrystal','April-ClearCrystal',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('May-Amerald','May-Amerald',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('June-LtAmethyst','June-Lt Amethyst',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('July-Ruby','July-Ruby',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('August-Peridot','August-Peridot',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('September-Sapphire','September-Sapphire',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('October-Rose','October-Rose',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('November-Topaz','November-Topaz',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('December-Bluezipcon','December-Bluezipcon',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Fuschia','Fuschia',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Jet Black','Jet Black',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Light Rose','Light Rose ',30.00, 1000, @categoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Montana Blue','Montana Blue ',30.00, 1000, @categoryId)