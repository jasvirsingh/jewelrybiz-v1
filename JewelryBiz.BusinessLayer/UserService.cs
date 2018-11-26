using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class UserService
    {
        public User VerifyUser(string email, string password)
        {
            return new UserDAL().VerifyUser(email, password);
        }
        public int Create(User user)
        {
            return new UserDAL().Create(user);
        }
    }
}
