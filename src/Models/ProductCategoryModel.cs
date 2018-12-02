using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Models
{
    public class ProductCategoryModel
    {
        public List<Product> AllProducts
        {
            get
            {
                return new ProductService().GetAll();

            }
        }

        public List<SelectListItem> AllCategories
        {
            get
            {
                return GetAllCategories();

            }
        }

        private List<SelectListItem> GetAllCategories()
        {
            var model = new ProductCategoryModel();
            var categoryService = new CategoryService();
            List<SelectListItem> categories = categoryService.Get()
                .Where(c => c.ParentCategoryId == 0)
                        .Select(n =>
                        new SelectListItem
                        {
                            Value = n.CategoryId.ToString(),
                            Text = n.CategoryName
                        }).ToList();

            var defaultCategory = new SelectListItem()
            {
                Value = null,
                Text = "--- Select ---"
            };
            categories.Insert(0, defaultCategory);
            return categories;
        }
    }
}