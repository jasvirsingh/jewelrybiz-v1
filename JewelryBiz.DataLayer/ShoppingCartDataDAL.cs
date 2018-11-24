using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace JewelryBiz.DataAccess
{
    public class ShoppingCartDataDAL
    {
        public CartItem GetByProductId(string userSessionId, int productId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = userSessionId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = productId
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteQuery("procGetCartItem", parameters.ToArray());
            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                var item = result.Tables[0].Rows[0];
                return new CartItem
                {
                    ProductId = productId,
                    PName = item["PName"].ToString(),
                    UnitPrice = Convert.ToDecimal(item["UnitPrice"]),
                    Quantity = Convert.ToInt32(item["Quantity"])
                };
            }
            return null;
        }

        public IList<CartItem> GetCurrentUserCartItems(string userSessionId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = userSessionId
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteQuery("procGetCartItems", parameters.ToArray());
            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                IEnumerable<DataRow> items = from item in result.Tables[0].AsEnumerable()
                                            select item;
                var cartItems = items.Select(item => new CartItem
                {
                    ProductId = Convert.ToInt32(item["ProductId"]),
                    PName = item["PName"].ToString(),
                    UnitPrice = Convert.ToDecimal(item["UnitPrice"]),
                    Quantity = Convert.ToInt32(item["Quantity"])
                });

                return cartItems.ToList();
            }

            return null;
        }

        public void AddCartItem(CartItem cartItem)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = cartItem.UserSessionId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = cartItem.ProductId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@PName",
                DbType = DbType.String,
                Value = cartItem.PName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UnitPrice",
                DbType = DbType.Decimal,
                Value = cartItem.UnitPrice
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Quantity",
                DbType = DbType.Decimal,
                Value = cartItem.Quantity
            });

            var sqlDataAccess = new SqlDataAccess();
            sqlDataAccess.ExecuteStoredProcedure("procAddCartItem", parameters.ToArray());
        }

        public void IncreaseCartItemQuantity(string userSessionId, int productId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = userSessionId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = productId
            });

            new SqlDataAccess().ExecuteStoredProcedure("procIncreaseQuantity", parameters.ToArray());
        }

        public void ExecuteChangeInQuantity(string userSessionId, int productId, string action)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = userSessionId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ProductId",
                DbType = DbType.Int32,
                Value = productId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Action",
                DbType = DbType.String,
                Value = action
            });

            new SqlDataAccess().ExecuteStoredProcedure("procQuantityChange", parameters.ToArray());
        }

        public void Clear(string userSessionId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserSessionId",
                DbType = DbType.String,
                Value = userSessionId
            });

            new SqlDataAccess().ExecuteStoredProcedure("procClearCart", parameters.ToArray());
        }
    }
}
