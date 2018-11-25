using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class CustomerService
    {
        public Customer GetByEmail(string email)
        {
            return new CustomerDAL().GetByEmail(email);
        }

        public void CreateCustomerOrder(Customer customer, string userSessionId)
        {
            new CustomerDAL().CreateCustomerOrder(customer, userSessionId);
        }

        public IList<PurchasedItem> GetPurchaseHistory(string email)
        {
            return new CustomerDAL().GetPurchaseHistory(email);
        }

    }
}
