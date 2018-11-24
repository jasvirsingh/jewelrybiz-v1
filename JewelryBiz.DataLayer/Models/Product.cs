namespace JewelryBiz.DataAccess.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string PName { get; set; }
        public string Brand { get; set; }
        public decimal UnitPrice { get; set; }
        public int UnitsInStock { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
    }
}
