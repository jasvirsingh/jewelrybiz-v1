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

        public void CreateCustomerOrder(Customer customer, string userSessionId, int shippingCost)
        {
            new CustomerDAL().CreateCustomerOrder(customer, userSessionId, shippingCost);
        }

        public IList<PurchasedItem> GetPurchaseHistory(string email)
        {
            return new CustomerDAL().GetPurchaseHistory(email);
        }

        public void SavePersonalInfo(Customer customer, string userSessionId)
        {
            new CustomerDAL().SavePersonalInfo(customer, userSessionId);
        }

        public CustomerProfile GetCustomerProfile(string email)
        {
            return new CustomerDAL().GetCustomerProfile(email);
        }
    }
}
