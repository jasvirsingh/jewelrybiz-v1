using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class CategoryService
    {
        public IEnumerable<Category> Get()
        {
            return new CategoriesDAL().Get();
        }
    }
}
