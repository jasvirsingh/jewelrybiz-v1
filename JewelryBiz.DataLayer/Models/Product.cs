using System.Collections.Generic;

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
        public int CategoryId { get; set; }
        public string Image { get; set; }
        public string PCategoryName { get; set; }

        public IList<ProductMaterial> Materials { get; set; }
    }
}
