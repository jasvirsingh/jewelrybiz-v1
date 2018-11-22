﻿namespace JewelryBiz.UI.Helpers
{
    public class UserSecurityManager
    {
        public void AuthorizeUser(JewelryBiz.DataAccess.Models.User user)
        {
            ApplicationUser applicationUser = new ApplicationUser();
            applicationUser.Name = user.UserName;
            applicationUser.Password = user.Password;
            //Update IPrincipleusing UFSUser.
            ApplicationPrinciple userPriniciple = new ApplicationPrinciple(applicationUser, "RolesGoHere");
            System.Web.HttpContext.Current.User = userPriniciple;
        }
    }
}