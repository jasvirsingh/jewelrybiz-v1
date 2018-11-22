using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;

namespace JewelryBiz.BusinessLayer
{
    public class UserService
    {
        public User VerifyUser(string userName, string password)
        {
            var userDAL = new UserDAL();
            return userDAL.VerifyUser(userName, password);
        }
        public int Create(User user)
        {
            var userDAL = new UserDAL();
            var result = userDAL.Create(user);
            return result;
        }
    }
}
