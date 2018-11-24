using JewelryBiz.DataAccess.Core;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class OrderDAL
    {
        public int CreateOrder(string userSessionId, string email)
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

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procCreateOrder", parameters.ToArray());
            return result;
        }
    }
}
