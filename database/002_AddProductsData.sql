delete from [dbo].ShoppingCart
delete from [dbo].Product

alter table [dbo].[Product]
ALTER  column [ProductDescription] [varchar](max) NULL

Declare @categoryId int
SELECT @categoryId = PCategoryId FROM [dbo].ProductCategory
WHERE CategoryName ='MOTHER_BRACELET'

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Bali Bead & Crystal Mommy Bracelet','This Mom Bracelet features sterling silver letter blocks accented with sterling silver Bali bead flowers and your choice of Swarovski crystals or freshwater pearls. Choose one to four strands. Option of heart toggle, round toggle, lobster claw, or ornate silver bali box clasp with safety (additional $30)',
89.00,500, @categoryId, 1, GETDATE(), 'admin','balicrystal_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Black Onyx & Gold-filled Mommy Bracelet','This Mother Bracelet features sterling silver letter blocks and black onyx. Accented with 14k gold filled beads and sterling silver bali beads. Choose one to four strands. Option of heart toggle, round toggle, lobster claw, or ornate silver bali box clasp with safety (additional $30).',
79.00,200, @categoryId, 1, GETDATE(), 'admin','Black_Onyx_Gold_Filled_Mommy_Bracelet1000_large.jpg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Black Onyx & Pearl Mommy Bracelet','This Mommy Bracelet features sterling silver letter blocks and black onyx rondels alternating with sterling silver bali beads. Accented with fresh water pearls and Swarovski crystals. Crystals can represent the childrens birth months or if you like the design shown choose April for the clear crystals. Choose one to four strands. Option of heart toggle, round toggle, lobster claw, or ornate silver bali box clasp with safety (additional $30)',
79.00,300, @categoryId, 1, GETDATE(), 'admin','bopl_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Crystal & Pearl Dangle Mommy Bracelet','This Mommy Bracelet features sterling silver letter blocks with silver links and dangles of pearl, crystal and gold-fill. Bracelet may be personalized with your choice of crystals. Great for grandmothers who want to include a crystal in each of her children or grandchildrens birthstone colors. Lobster claw clasp.',
99.00,350, @categoryId, 1, GETDATE(), 'admin','crystalpearldangle_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Double Infinity Bracelet','Our sterling silver infinity bracelet made with double silver link chain. Comes with a secure fastening lobster clasp which allows 1" of length adjustment. Customize with birthstone dangles to represent the ones she loves or your team colors!',
69.00,450, @categoryId, 1, GETDATE(), 'admin','double_infinity_bracelet_4_charms_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Dangle Mommy Bracelet','Sterling silver letter blocks with sterling silver links and dangles of silver, gold-fill, gemstones, crystals and cloisonne. Each bracelet is unique. Your bracelet can be personalized with one to three names, fourteen letters maximum. Lobster claw clasp. ',
99.00,750, @categoryId, 1, GETDATE(), 'admin','dangle_large.jpeg')

SELECT @categoryId = PCategoryId FROM [dbo].ProductCategory
WHERE CategoryName ='NECKLACE'

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('DROP CHAIN NECKLACE','Style your Drop Chain necklace in five fashionable ways. The necklace is anchored with a shiny silver accent for an elegant and classic look.',
60.00,250, @categoryId, 1, GETDATE(), 'admin','rc-2.jpg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('ORIGINS BAR NECKLACE','Crafted in .925 sterling silver and symbolizing new beginnings, this Origins Bar Necklace features a wheat motif with high polish accents and millegrain beading down the center. It is finished with a station pavéd with White Pure Brilliance Zirconia. 16” with a 2” extender.',
150.00,270, @categoryId, 1, GETDATE(), 'admin','1225-0061.jpg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('ALIGHT PENDANT','This single leaf element - a symbol of growth – is pavéd with Swarovski Pure Brilliance Zirconia and designed with our signature connections pattern. The pendant exquisitely hangs from a smooth, polished leaf-shaped bail. Light weight due to its open interior and pillowed shape, it is crafted in .925 sterling silver and is beautifully finished on the back with a gallery that includes our Hummingbird icon. 16“ (40,6 cm) adjustable to 18“ (45,7 cm)',
115.00,170, @categoryId, 1, GETDATE(), 'admin','1225-0041.jpg')

SELECT @categoryId = PCategoryId FROM [dbo].ProductCategory
WHERE CategoryName ='BABY_BRACELET'

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Little Princess Crystal & Hematite Bracelet','Petite sterling silver letter blocks (4.5mm letters as opposed to 6mm letters on adult bracelets), dark grey metallic hematite, gold-filled, and your choice of lead free Czech glass crystals or freshwater pearls. Choose between a tiny Cross, Star of David or Heart dangle. Adjustable chain closure allows it to grow with her. Image has been enlarged to show detail. Be sure to see our coordinating items at the bottom of this page.',
62.00,1170, @categoryId, 1, GETDATE(), 'admin','lilprincessii_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Little Princess Gemstones & Bali Bracelet','A colorful array of gemstones with petite sterling silver letter blocks (4.5mm letters as opposed to 6mm letters on adult bracelets), and sterling silver bali flower beads. Choose between a tiny Cross, Star of David or Heart dangle. Adjustable chain closure allows it to grow with her. Image has been enlarged to show detail.',
64.00,1100, @categoryId, 1, GETDATE(), 'admin','pringbbig_large.jpeg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES('Little Princess Silver Bracelet','The classic name bracelet with petite sterling silver letter blocks (4.5mm letters as opposed to 6mm letters on adult bracelets). All smooth sterling silver beads in alternating 3mm and 4mm pattern. Choose between a tiny Cross, Star of David or Heart dangle. Adjustable chain closure allows it to grow with her. Image has been enlarged to show detail.',
62.00,1100, @categoryId, 1, GETDATE(), 'admin','prinsilbig_large.jpeg')

SELECT @categoryId = PCategoryId FROM [dbo].ProductCategory
WHERE CategoryName ='EARRING'

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES(
'Large Metal Hoop Earrings'
,'Enliven your desk-to-dinner ensembles with these stunning earrings. Large hoops frame your face and accentuate your neckline for a polished, dramatic look.

<li>Hoop earrings</li>
<li>Push-through closure</li>
<li>Base metal</li>
<li>Lead and nickel free</li>
<li>Imported</li>',
7.45,190, @categoryId, 1, GETDATE(), 'admin','earring-1.jpg')

INSERT INTO [dbo].Product(ProductName, ProductDescription, UnitPrice, OnHand, PCategoryId, IsActive, CreatedDate, CreatedBy, Image)
VALUES(
'Cubic Zirconia Teardrop Earrings'
,'Keep your style sparkling with these crystal-accented teardrop earrings.

<li>Teardrop earrings</li>
<li>Cubic zirconia accents</li>
<li>Approx. 1" long</li>
<li>Cubic zirconia/Brass</li>
<li>Lead and nickel free</li>
<li>Imported</li>',
9.95,140, @categoryId, 1, GETDATE(), 'admin','earring-2.jpg')