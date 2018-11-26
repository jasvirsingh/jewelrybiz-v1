using JewelryBiz.BusinessLayer;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class BaseController : Controller
    {

        public BaseController()
        {
            if (Session != null)
            {
                var currentUserCartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
                ViewBag.CartTotalPrice = currentUserCartItems.Sum(c => c.Quantity * c.UnitPrice);
                ViewBag.Cart = currentUserCartItems;
                ViewBag.CartUnits = currentUserCartItems.Count();
            }
        }
    }
}