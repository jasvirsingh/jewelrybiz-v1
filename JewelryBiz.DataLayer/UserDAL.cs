﻿using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess
{
    public class UserDAL
    {
        public User VerifyUser(string email, string password)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Password",
                DbType = DbType.String,
                Value = password
            });
            var sqlDataAccess = new SqlDataAccess();

            var result = sqlDataAccess.ExecuteStoredProcedure("procCheckUser", parameters.ToArray());
            if(result!=null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                var row = result.Tables[0].Rows[0];
                return new User
                {
                    Password = password,
                    Email = email,
                    Role = row["RoleName"].ToString()
                };
            }

            return null;
        }

        public int Create(User user)
        {
            var parameters = new List<SqlParameter>();
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
            var result = sqlDataAccess.ExecuteNonQuery("procCreateAccount", parameters.ToArray());
            return result;
        }
    }
}
