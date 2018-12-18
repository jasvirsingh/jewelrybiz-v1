using JewelryBiz.DataAccess.Core;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class OrderDAL
    {
        public int CreateOrder(string userSessionId, string email, int shippingCost)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@SessionId",
                DbType = DbType.String,
                Value = userSessionId
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });

            parameters.Add(new SqlParameter
            {
                ParameterName = "@ShippingCost",
                DbType = DbType.Int64,
                Value = shippingCost
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteNonQuery("procCreateOrder", parameters.ToArray());
            return result;
        }
    }
}
