using JewelryBiz.DataAccess;

namespace JewelryBiz.BusinessLayer
{
    public class SubscriptionService
    {
        public int Subscribe(string email)
        {
            var subscriptionDAL = new SubscriptionDAL();
            return subscriptionDAL.Subscribe(email);
        }
    }
}
