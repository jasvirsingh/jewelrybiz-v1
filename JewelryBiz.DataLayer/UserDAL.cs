using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class UserDAL
    {
        public User VerifyUser(string userName, string password)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserName",
                DbType = DbType.String,
                Value = userName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Password",
                DbType = DbType.String,
                Value = password
            });
            var sqlDataAccess = new SqlDataAccess();

            var result = sqlDataAccess.ExecuteQuery("procCheckUser", parameters.ToArray());
            if(result!=null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                var row = result.Tables[0].Rows[0];
                return new User
                {
                    FirstName = row["FName"].ToString(),
                    LastName = row["LName"].ToString(),
                    UserName = userName,
                    Password = password,
                    Email = row["Email"].ToString(),
                    RoleId = Convert.ToInt32(row["RoleId"])
                };
            }

            return null;
        }

        public int Create(User user)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@FirstName",
                DbType = DbType.String,
                Value = user.FirstName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@LastName",
                DbType = DbType.String,
                Value = user.LastName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = user.Email
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@UserName",
                DbType = DbType.String,
                Value = user.UserName
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
