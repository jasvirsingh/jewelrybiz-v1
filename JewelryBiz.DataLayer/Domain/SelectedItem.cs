using JewelryBiz.DataAccess.Domain;
using System.Collections.Generic;

namespace JewelryBiz.DataLayer.Domain
{
    public class SelectedItem
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal UnitPrice { get; set; }
        public int OnHand { get; set; }
        public int Quantity { get; set; }
        public string Image { get; set; }

        public ProductMaterial MaterialDetails { get; set; }
    }
}
