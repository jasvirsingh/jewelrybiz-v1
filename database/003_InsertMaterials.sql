delete from [dbo].Material
delete from [dbo].MaterialCategory
--ALTER TABLE [dbo].Material
--ADD CONSTRAINT df1_CreateDate
--DEFAULT getdate() FOR CreatedDate;

--ALTER TABLE [dbo].Material
--ADD CONSTRAINT df2_CreatedBy
--DEFAULT 'admin' FOR CreatedBy;

--ALTER TABLE [dbo].MaterialCategory
--ADD CONSTRAINT df1_CreatedDate
--DEFAULT getdate() FOR CreatedDate;

--ALTER TABLE [dbo].MaterialCategory
--ADD CONSTRAINT df2_CreatedBy
--DEFAULT 'admin' FOR CreatedBy;

Declare @mCategoryId int
Declare @pCategoryId int

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Metal','Metal',1)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Gold','Gold',800.00, 200, @mCategoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Silver','Silver',200.00, 300, @mCategoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Platinum','Platinum',450.00, 100, @mCategoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('WhiteGold','White Gold',1000.00, 400, @mCategoryId)

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Tungstun','Tungstun',1000.00, 250, @mCategoryId)


INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Pearl','Pearl',1)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('BlackPearl','Black Pearl',4000.00, 210, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('WhitePearl','White Pearl',3000.00, 110, @mCategoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive)
VALUES('Birthstone','Birthstone',1)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('January-Garnet','January-Garnet',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('February-Amethyst','February-Amethyst',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('March-Aquamarine','March-Aquamarine',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('April-ClearCrystal','April-ClearCrystal',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('May-Amerald','May-Amerald',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('June-LtAmethyst','June-Lt Amethyst',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('July-Ruby','July-Ruby',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('August-Peridot','August-Peridot',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('September-Sapphire','September-Sapphire',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('October-Rose','October-Rose',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('November-Topaz','November-Topaz',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('December-Bluezipcon','December-Bluezipcon',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Fuschia','Fuschia',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Jet Black','Jet Black',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Light Rose','Light Rose ',30.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Montana Blue','Montana Blue ',30.00, 1000, @mCategoryId)

SELECT @pCategoryId = PCategoryId from ProductCategory WHERE CategoryName ='MOTHER_BRACELET'

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('STRAND','Strand',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('ONESTRAND','One Strand',0.00, 200, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('TWOSTRAND','Two Strand',0.00, 200, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('THREESTRAND','Three Strand',0.00, 200, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('FOURSTRAND','Four Strand',0.00, 200, @mCategoryId)


INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('CLASP','Clasp',1,@pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Heart Toggle','Heart Toggle',0.00, 500, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Round Toggle','Round Toggle',0.00, 400, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Lobster Claw','Lobster Claw',0.00, 300, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Ornate Silver Bali Box','Ornate Silver Bali Box',0.00, 100, @mCategoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('SIZE','Size',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('6.5','6.5',0.00, 200, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('7.0','7.0',0.00, 500, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('7.5','7.5',0.00, 170, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('8','8.0',0.00, 170, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('8.5','8.5',0.00, 170, @mCategoryId)

SELECT @pCategoryId = PCategoryId from ProductCategory WHERE CategoryName ='BABY_BRACELET'

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('SIZE','Size',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('4.5','4.5-5.5',0.00, 210, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('5.5','5.5-6.5',0.00, 500, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('6.5','6.5-7.5',0.00, 270, @mCategoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('DANGLE','Dangle',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Cross','Cross',0.00, 250, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Heart','Heart',0.00, 150, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('Star of David','Star of David',0.00, 1150, @mCategoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('CRYSTAL','Crystal',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('JANUARY','Jan (Garnet-deep red)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('FEBRUARY','Feb (Amethyst-purple)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('MARCH','March (Aquamarine-light blue)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('APRIL','April (Diamond-clear)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('MAY','May (Emerald-deep green)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('JUNE','June (Alexandrite-light purple)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('JULY','July (Ruby-red)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('AUGUST','August (Peridot-light green)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('SEPTEMBER','Sept (Sapphire-bright blue)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('OCTOBER','Oct (Tourmaline-rose)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('NOVEMBER','Nov (Topaz-golden brown)',0.00, 1000, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('DECEMBER','Nov (Topaz-golden brown)',0.00, 1000, @mCategoryId)

SELECT @pCategoryId = PCategoryId from ProductCategory WHERE CategoryName ='EARRING'

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('COLOR','Color',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('GOLD','Gold ',0.00, 50, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('ROSEGOLD','Rose Gold ',0.00, 100, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('SHINYSILVER','Shiny Silver ',0.00, 45, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('HEMATITE','Hematite ',0.00, 200, @mCategoryId)

INSERT INTO [dbo].MaterialCategory(CategoryName, CategoryDescription, IsActive, PCategoryId)
VALUES('SIZE','Size',1, @pCategoryId)
select @mCategoryId = @@IDENTITY

INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('S','Small ',0.00, 10, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('M','Medium ',0.00, 10, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('L','Large ',0.00, 15, @mCategoryId)
INSERT INTO [dbo].Material(MaterialName, MaterialDescription, UnitCost, OnHand, MCategoryId)
VALUES('XL','Extra Large ',0.00, 15, @mCategoryId)