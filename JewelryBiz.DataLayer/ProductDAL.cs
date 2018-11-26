using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace JewelryBiz.DataAccess
{
    public class ProductDAL
    {
        public Product GetById(int productId)
        {
            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.Execute("SELECT * FROM PRODUCTS WHERE PRODUCTID = "+ productId);
            if (result != null && result.Rows.Count > 0)
            {
                return new Product
                {
                    ProductId = productId,
                    PName = result.Rows[0]["PName"].ToString(),
                    Brand = result.Rows[0]["Brand"].ToString(),
                    UnitPrice = Convert.ToDecimal(result.Rows[0]["UnitPrice"]),
                    UnitsInStock = Convert.ToInt32(result.Rows[0]["UnitsInStock"]),
                    Description = result.Rows[0]["Description"].ToString()
                };
            }
            return null;
        }

        public IList<Product> GetAll()
        {
            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procGetAllProducts");
            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                IEnumerable<DataRow> products = from p in result.Tables[0].AsEnumerable()
                                             select p;
                var items = products.Select(p => new Product
                {
                    ProductId = Convert.ToInt32(p["ProductId"]),
                    PName = p["PName"].ToString(),
                    Description = p["Description"].ToString(),
                    UnitPrice = Convert.ToDecimal(p["UnitPrice"]),
                    UnitsInStock = Convert.ToInt32(p["UnitsInStock"]),
                    Category = p["Category"].ToString()
                });

                return items.ToList();
            }
            return null;
        }

        public void DecreaseUnitInStockByOne(int productId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = productId
            });

            new SqlDataAccess().ExecuteStoredProcedure("procDecreaseUnitInStock", parameters.ToArray());          
        }
    }
}
