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

        public void CreateCustomerOrder(Customer customer, string userSessionId)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@FirstName",
                DbType = DbType.String,
                Value = customer.FName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@LastName",
                DbType = DbType.String,
                Value = customer.LName
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Phone",
                DbType = DbType.String,
                Value = customer.Phone
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Addresss1",
                DbType = DbType.String,
                Value = customer.Address1
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Addresss2",
                DbType = DbType.String,
                Value = customer.Address2
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@PostCode",
                DbType = DbType.String,
                Value = customer.Postcode
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@State",
                DbType = DbType.String,
                Value = customer.State
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@CardType",
                DbType = DbType.String,
                Value = customer.CardType
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@CardNumber",
                DbType = DbType.String,
                Value = customer.CardNo
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@ExpDate",
                DbType = DbType.String,
                Value = customer.ExpDate
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = customer.Email
            });
            var sqlDataAccess = new SqlDataAccess();
            sqlDataAccess.ExecuteStoredProcedure("procAddCustomer", parameters.ToArray());

            var orderDAL = new OrderDAL();
            orderDAL.CreateOrder(userSessionId, customer.Email);
        }
    }
}
