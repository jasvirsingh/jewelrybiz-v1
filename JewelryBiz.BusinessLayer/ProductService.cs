using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class ProductService
    {
        public Product GetById(int productId)
        {
            return new ProductDAL().GetById(productId);
        }

        public List<Product> GetAll()
        {
            return new ProductDAL().GetAll();
        }

        public void DecreaseUnitInStockByOne(int productId)
        {
            new ProductDAL().DecreaseUnitInStockByOne(productId);
        }
    }
}
