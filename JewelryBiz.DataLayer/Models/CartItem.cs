namespace JewelryBiz.DataAccess.Models
{
    public class CartItem
    {
        public string UserSessionId { get; set; }
        public int TempOrderID { get; set; }
        public int ProductId { get; set; }
        public string PName { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public decimal Total { get; set; }
    }
}
