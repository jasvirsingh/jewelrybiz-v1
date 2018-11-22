using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class CustomerDAL
    {
        public int Get(Customer customer)
        {
            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.Execute("SELECT * FROM CUSTOMERS");
            return 0;
        }

        public int Create(User user)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@FirstName",
                DbType = DbType.String,
                Value = user.FName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@LastName",
                DbType = DbType.String,
                Value = user.LName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Phone",
                DbType = DbType.String,
                Value = user.Phone
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Addresss1",
                DbType = DbType.String,
                Value = user.Address1
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Addresss2",
                DbType = DbType.String,
                Value = user.Address2
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@PostCode",
                DbType = DbType.String,
                Value = user.Postcode
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@State",
                DbType = DbType.String,
                Value = user.State
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = user.Email
            });
            parameters.Add(new SqlParameter
                {
                    ParameterName = "@Password",
                    DbType = DbType.String,
                    Value = user.Password
                });
            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procCreateAccount", parameters.ToArray());
            return result;
        }
    }
}
