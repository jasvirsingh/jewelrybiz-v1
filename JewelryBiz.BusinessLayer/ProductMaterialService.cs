using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class ProductMaterialService
    {
        public IEnumerable<ProductMaterial> Get(int productCategoryId)
        {
            return new ProductMaterialDAL().Get(productCategoryId);
        }
    }
}
