﻿using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace JewelryBiz.DataAccess
{
    public class CustomerDAL
    {
        public Customer GetByEmail(string email)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procGetCustomerInfo", parameters.ToArray());

            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
                {
                    var row = result.Tables[0].Rows[0];
                    return new Customer
                    {
                        FName = row["FirstName"].ToString(),
                        LName = row["LastName"].ToString(),
                        Phone = row["Phone"].ToString(),
                        Address1 = row["Address1"].ToString(),
                        Address2 = row["Address2"].ToString(),
                        Postcode = row["PostCode"].ToString(),
                        State = row["State"].ToString(),
                        Email = row["Email"].ToString(),
                    };
                }

            return null;
        }

        public void SavePersonalInfo(Customer customer, string userSessionId)
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
                ParameterName = "@Address1",
                DbType = DbType.String,
                Value = customer.Address1
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Address2",
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
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = customer.Email
            });

            var sqlDataAccess = new SqlDataAccess();
            sqlDataAccess.ExecuteStoredProcedure("procAddCustomer", parameters.ToArray());
        }

        public void CreateCustomerOrder(Customer customer, string userSessionId, int shippingCost)
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
                ParameterName = "@Address1",
                DbType = DbType.String,
                Value = customer.Address1
            });
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Address2",
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
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = customer.Email
            });
            var sqlDataAccess = new SqlDataAccess();
            sqlDataAccess.ExecuteStoredProcedure("procAddCustomer", parameters.ToArray());

            var paymentParameters = new List<SqlParameter>();
            paymentParameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = customer.Email
            });
            paymentParameters.Add(new SqlParameter
            {
                ParameterName = "@PaymentMethodCode",
                DbType = DbType.String,
                Value = customer.PaymentMethodCode
            });
            paymentParameters.Add(new SqlParameter
            {
                ParameterName = "@AccountNo",
                DbType = DbType.String,
                Value = customer.CardNo
            });
            paymentParameters.Add(new SqlParameter
            {
                ParameterName = "@ExpirationDate",
                DbType = DbType.Date,
                Value = customer.ExpDate
            });

            var sqlDataAccess2 = new SqlDataAccess();
            sqlDataAccess2.ExecuteNonQuery("procAddCustomerPaymentMethod", paymentParameters.ToArray());

            var orderDAL = new OrderDAL();
            orderDAL.CreateOrder(userSessionId, customer.Email, shippingCost);
        }

        public IList<PurchasedItem> GetPurchaseHistory(string email)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procGetPurchaseHistory", parameters.ToArray());

            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                IEnumerable<DataRow> items = from item in result.Tables[0].AsEnumerable()
                                             select item;
                var purchasedItems = items.Select(item => new PurchasedItem
                {
                    ProductName = item["ProductName"].ToString(),
                    OrderDate = Convert.ToDateTime(item["OrderDate"]),
                    DeliveryDate = Convert.ToDateTime(item["ExpectedDeliveryDate"]),
                    OrderQuantity = Convert.ToInt32(item["Quantity"]),
                    TotalAmount = Convert.ToDecimal(item["TotalAmount"])
                });

                return purchasedItems.ToList();
            }

            return null;
        }

        public CustomerProfile GetCustomerProfile(string email)
        {
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter
            {
                ParameterName = "@Email",
                DbType = DbType.String,
                Value = email
            });

            var sqlDataAccess = new SqlDataAccess();
            var result = sqlDataAccess.ExecuteStoredProcedure("procGetCustomerProfile", parameters.ToArray());

            if (result != null && result.Tables.Count > 0 && result.Tables[0].Rows.Count > 0)
            {
                var row = result.Tables[0].Rows[0];
                return new CustomerProfile
                {
                    FName = row["FirstName"].ToString(),
                    LName = row["LastName"].ToString(),
                    Phone = row["Phone"].ToString(),
                    Address1 = row["Address1"].ToString(),
                    Address2 = row["Address2"].ToString(),
                    Postcode = row["PostCode"].ToString(),
                    State = row["State"].ToString(),
                    Email = row["Email"].ToString(),
                    PaymentMethod =row["MethodName"].ToString(),
                    CardNo = row["AccountNo"].ToString(),
                    ExpDate =  Convert.ToDateTime(row["ExpirationDate"])
                };
            }

            return null;
        }
    }
}
