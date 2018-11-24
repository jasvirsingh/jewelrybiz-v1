using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class ProductService
    {
        public Product GetById(int productId)
        {
            return new ProductDAL().GetById(productId);
        }

        public void DecreaseUnitInStockByOne(int productId)
        {
            new ProductDAL().DecreaseUnitInStockByOne(productId);
        }
    }
}
