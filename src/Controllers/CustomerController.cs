using JewelryBiz.BusinessLayer;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class CustomerController : BaseController
    {
        public ActionResult MyProfile()
        {
            var email = System.Web.HttpContext.Current.User.Identity.Name;
            var info = new CustomerService().GetCustomerProfile(email);
            return View(info);
        }

        public ActionResult PurchaseHistory()
        {
            var email = System.Web.HttpContext.Current.User.Identity.Name;
            var purchaseHistory = new CustomerService().GetPurchaseHistory(email);
            ViewBag.PurchasedItems = purchaseHistory;
            return View();
        }
    }
}