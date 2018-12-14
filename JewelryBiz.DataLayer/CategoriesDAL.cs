using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace JewelryBiz.DataAccess
{
   public class CategoriesDAL
    {
        public IEnumerable<Category> Get()
        {
            var sqlDAL = new SqlDataAccess();
            var result = sqlDAL.ExecuteStoredProcedure("procGetCategories", null);
            if(result != null)
            {
                IEnumerable<DataRow> rows = from category in result.Tables[0].AsEnumerable()
                                             select category;
               var categories = rows.Select(r => new Category
                {
                    CategoryId = Convert.ToInt32(r["PCategoryId"]),
                    ParentCategoryId = 0,//Convert.ToInt32(r["ParentCategoryId"]),
                    CategoryName = r["CategoryName"].ToString(),
                    CategoryDescription = r["CategoryDescription"].ToString()
               });

                return categories;
            }
            return null;
        }
    }
}
