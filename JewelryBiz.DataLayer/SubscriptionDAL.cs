using JewelryBiz.DataAccess.Core;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class SubscriptionDAL
    {
        public int Subscribe(string email)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });
            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteNonQuery("procSubscribe", parameters.ToArray());
            return result;
        }
    }
}
