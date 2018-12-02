namespace JewelryBiz.DataAccess.Domain
{
    public class ProductMaterial
    {
        public int MaterialId { get; set; }
        public string MaterialName { get; set; }
        public string Description { get; set; }
        public decimal UnitCost { get; set; }
        public int OnHand { get; set; }
        public int MaterialCategoryId { get; set; }
    }
}