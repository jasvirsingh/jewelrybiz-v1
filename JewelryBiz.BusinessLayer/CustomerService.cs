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

        public int Create(User user)
        {
            var customerDAL = new CustomerDAL();
            var result = customerDAL.Create(user);
            return result;
        }
    }
}
