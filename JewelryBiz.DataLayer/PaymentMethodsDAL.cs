using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace JewelryBiz.DataAccess
{
   public class PaymentMethodsDAL
    {
        public IEnumerable<PaymentMethod> Get()
        {
            var sqlDAL = new SqlDataAccess();
            var result = sqlDAL.ExecuteStoredProcedure("procGetPaymentMethods", null);
            if (result != null)
            {
                IEnumerable<DataRow> rows = from method in result.Tables[0].AsEnumerable()
                                            select method;
                var paymentMethods = rows.Select(r => new PaymentMethod
                {
                    PaymentMethodCode = Convert.ToString(r["PaymentMethodCode"]),
                    MethodName = Convert.ToString(r["MethodName"])
                });

                return paymentMethods;
            }
            return null;
        }
    }
}
