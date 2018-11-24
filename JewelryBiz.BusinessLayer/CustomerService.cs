using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class CustomerService
    {
        public int Get(Customer customer)
        {
            var customerDAL = new CustomerDAL();
            var result = customerDAL.Get(customer);
            return 0;
        }

        public void CreateCustomerOrder(Customer customer, string userSessionId)
        {
            var customerDAL = new CustomerDAL();
            customerDAL.CreateCustomerOrder(customer, userSessionId);
        }
    }
}
