using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JewelryBiz.UI
{
    public partial class Product
    {
        private JewelryBizEntities _ctx = new JewelryBizEntities();
        public List<Product> All
        {
            get
            {
                return _ctx.Products.ToList<Product>();

            }
        }
    }
}