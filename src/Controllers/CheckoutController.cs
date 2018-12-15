using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class CheckoutController : BaseController
    {
        private List<object> states;
        private List<object> cards;

        public CheckoutController()
        {
            states = StatesService.GetStates();

            cards = new List<object> {
                new { Type = "VISA" },
                new { Type = "Master Card" },
                new { Type = "AMEX" }
            };

        }
        
        // GET: Checkout
        public ActionResult Index()
        {
            ShoppingBag();
            var currentUserCartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
            ViewBag.Cart = currentUserCartItems;
            decimal total = 0;
            if(currentUserCartItems != null && currentUserCartItems.Any())
            {
                total = currentUserCartItems.Select(p => p.UnitPrice * p.Quantity).Sum();
            }
            ViewBag.CartTotalPrice = total;
            return View();
        }
        
        public ActionResult QuanityChange(int type, int pId)
        {
            var product = new ShoppingCartDataService().GetByProductId(Session.SessionID, pId);
            if (product == null)
            {
                return Json(new { d = "0" });
            }

            var actualProduct = new ProductService().GetById(pId);
            int quantity;
            // if type 0, decrease quantity
            // if type 1, increase quanity
            switch (type)
            {
                case 0:
                    product.Quantity--;
                    actualProduct.UnitsInStock++;
                    new ShoppingCartDataService().ExecuteChangeInQuantity(Session.SessionID, pId, "-");
                    break;
                case 1:
                    product.Quantity++;
                    actualProduct.UnitsInStock--;
                    new ShoppingCartDataService().ExecuteChangeInQuantity(Session.SessionID, pId, "+");
                    break;
                case -1:
                    actualProduct.UnitsInStock += product.Quantity;
                    product.Quantity = 0;
                    new ShoppingCartDataService().ExecuteChangeInQuantity(Session.SessionID, pId, "x");
                    break;
                default:
                    return Json(new { d = "0" });
            }

            return RedirectToAction("Index");
            //if (product.Quantity == 0)
            //{
            //    quantity = 0;
            //}
            //else
            //{
            //    quantity = product.Quantity;
            //}

            //return Json(new { d = quantity });
        }

        [HttpGet]
        public JsonResult UpdateTotal()
        {
            decimal total;
            try
            {
                var cartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
                total = cartItems.Select(p => p.UnitPrice * p.Quantity).Sum();
            }
            catch (Exception) { total = 0; }

            return Json(new { d = String.Format("{0:c}", total) }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Clear()
        {
            try
            {
                new ShoppingCartDataService().Clear(Session.SessionID);
            }
            catch (Exception) { }
            return RedirectToAction("Index", "Home", null);
        }

        public ActionResult Purchase()
        {
            ShoppingBag();
            if (Request.Cookies["User"] ==null)
            {
                Session["Checkout"] = "FromCheckout";
               return RedirectToAction("Login", "Account");
            }
            var email = Request.Cookies["User"]["Email"];
            var customer = new CustomerService().GetByEmail(email);
            ViewBag.States = states;
            ViewBag.Cards = cards;

            return View(customer);
        }

        public ActionResult GuestCheckout()
        {
            ShoppingBag();
            ViewBag.States = states;
            ViewBag.Cards = cards;

            return View("Purchase");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Purchase(Customer customer)
        {
            ViewBag.States = states;
            ViewBag.Cards = cards;

            if (ModelState.IsValid)
            {
                if (customer.ExpDate <= DateTime.Now)
                {
                    ModelState.AddModelError("", "Credit card has already expired");
                }

                if (customer.CardType == "AMEX")
                {
                    if (customer.CardNo.Length != 15)
                    {
                        ModelState.AddModelError("", "AMEX must be 15 digits");
                    }
                }
                else
                {
                    if (customer.CardNo.Length != 16)
                    {
                        ModelState.AddModelError("", customer.CardType + "must be 16 digits");
                    }
                }

                if (ModelState.IsValid)
                {
                    var c = new Customer
                    {
                        FName = customer.FName,
                        LName = customer.LName,
                        Email = Request.Cookies["User"] == null? customer.Email : Request.Cookies["User"]["Email"],
                        Phone = customer.Phone,
                        Address1 = customer.Address1,
                        Address2 = customer.Address2,
                        Postcode = customer.Postcode,
                        State = customer.State,
                        CardType = customer.CardType,
                        CardNo = customer.CardNo,
                        ExpDate = customer.ExpDate
                    };

                    var customerService = new CustomerService();
                    customerService.CreateCustomerOrder(c, Session.SessionID);
                 
                    return RedirectToAction("PurchasedSuccess");

                }
            }

            List<ModelError> errors = new List<ModelError>();
            foreach (ModelState modelState in ViewData.ModelState.Values)
            {
                foreach (ModelError error in modelState.Errors)
                {
                    errors.Add(error);
                }
            }
            return View(customer);
        }

        public ActionResult PurchasedSuccess()
        {
            return View();
        }

        private void ShoppingBag()
        {
            if (Session != null)
            {
                var currentUserCartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
                if (currentUserCartItems != null)
                {
                    ViewBag.CartTotalPrice = currentUserCartItems.Sum(c => c.Quantity * c.UnitPrice);
                    ViewBag.Cart = currentUserCartItems;
                    ViewBag.CartUnits = currentUserCartItems.Count();
                }
            }
        }
    }
}
