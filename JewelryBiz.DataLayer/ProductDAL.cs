using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

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
