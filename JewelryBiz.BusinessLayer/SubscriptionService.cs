using JewelryBiz.DataAccess;

namespace JewelryBiz.BusinessLayer
{
    public class SubscriptionService
    {
        public int Subscribe(string email)
        {
            return new SubscriptionDAL().Subscribe(email);
        }
    }
}
