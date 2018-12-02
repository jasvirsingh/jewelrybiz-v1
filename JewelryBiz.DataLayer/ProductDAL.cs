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
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = productId
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procGetProductDetails", parameters.ToArray());
            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                var p = result.Tables[0].Rows[0];
                return new Product
                {
                    ProductId = Convert.ToInt32(p["ProductId"]),
                    PName = p["ProductName"].ToString(),
                    Description = p["ProductDescription"].ToString(),
                    UnitPrice = Convert.ToDecimal(p["UnitPrice"]),
                    UnitsInStock = Convert.ToInt32(p["OnHand"]),
                    CategoryId = Convert.ToInt32(p["PCategoryId"]),
                    Image = p["Image"].ToString(),
                };
            }
            return null;
        }

        public List<Product> GetAll()
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
                    PName = p["ProductName"].ToString(),
                    Description = p["ProductDescription"].ToString(),
                    UnitPrice = Convert.ToDecimal(p["UnitPrice"]),
                    UnitsInStock = Convert.ToInt32(p["OnHand"]),
                    CategoryId = Convert.ToInt32(p["PCategoryId"]),
                    Image = p["Image"].ToString()
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
