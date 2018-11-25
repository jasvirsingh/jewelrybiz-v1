using System;

namespace JewelryBiz.DataAccess.Models
{
   public class PurchasedItem
    {
        public string ProductName { get; set; }
        public int OrderQuantity { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public decimal TotalAmount { get; set; }
    }
}
