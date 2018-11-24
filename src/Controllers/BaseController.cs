using JewelryBiz.BusinessLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class BaseController : Controller
    {
        protected JewelryBizEntities _ctx = new JewelryBizEntities();

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