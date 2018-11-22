using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JewelryBiz.UI.Models
{
    public class OrderModel : JewelryBiz.UI.Order
    {

        public decimal TotalPayment
        {
            get
            {
                return this.Order_Products.Sum(p => p.TotalSale);
            }
        }
    }
}