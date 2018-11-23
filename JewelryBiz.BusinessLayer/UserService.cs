using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class UserService
    {
        public User VerifyUser(string email, string password)
        {
            var userDAL = new UserDAL();
            return userDAL.VerifyUser(email, password);
        }
        public int Create(User user)
        {
            var userDAL = new UserDAL();
            var result = userDAL.Create(user);
            return result;
        }
    }
}
