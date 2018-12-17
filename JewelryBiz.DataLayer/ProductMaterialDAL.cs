using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace JewelryBiz.DataAccess
{
    public class ProductMaterialDAL
    {
        public IEnumerable<ProductMaterial> Get(int productCategoryId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@PCategoryId",
                DbType = DbType.Int32,
                Value = productCategoryId
            });

            var sqlDAL = new SqlDataAccess();
            var result = sqlDAL.ExecuteStoredProcedure("procGetProductMaterial", parameters.ToArray());
            if (result != null)
            {
                IEnumerable<DataRow> rows = from m in result.Tables[0].AsEnumerable()
                                            select m;
                var material = rows.Select(r => new ProductMaterial
                {
                    CategoryName = r["CategoryName"].ToString(),
                    CategoryDescription = r["CategoryDescription"].ToString(),
                    MaterialName = r["MaterialName"].ToString(),
                    MaterialDescription = r["MaterialDescription"].ToString(),
                    MaterialId = Convert.ToInt32(r["MaterialId"])
                });

                return material;
            }
            return null;
        }
    }
}
