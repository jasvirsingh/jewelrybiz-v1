using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class CheckoutController : BaseController
    {
        private List<object> states;

        public CheckoutController()
        {
            states = StatesService.GetStates();
        }
        
        // GET: Checkout
        public ActionResult Index()
        {
            if (Session["ExpressShip"] == null)
            {
                Session["ExpressShip"] = false;
            }

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
        }

        public ActionResult Shipping()
        {
            ShoppingBag();
            ViewBag.States = states;
            return View();
        }

        [HttpGet]
        public void AddExpressShippingCost()
        {
            Session["ExpressShip"] = true;
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
            SetStates();
            SetPaymentMethods();

            return View(customer);
        }

        public ActionResult GuestCheckout()
        {
            ShoppingBag();
            SetStates();
            SetPaymentMethods();

            return View("Purchase");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Purchase(Customer customer)
        {
            if (ModelState.IsValid)
            {
                if (customer.ExpDate <= DateTime.Now)
                {
                    ModelState.AddModelError("", "Credit card has already expired");
                }

                if (customer.PaymentMethodCode == "AMEX")
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
                        ModelState.AddModelError("", customer.PaymentMethodCode + "must be 16 digits");
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
                        PaymentMethodCode = customer.PaymentMethodCode,
                        CardNo = customer.CardNo,
                        ExpDate = customer.ExpDate
                    };

                    var customerService = new CustomerService();
                    customerService.CreateCustomerOrder(c, Session.SessionID, Convert.ToInt32(Session["ShippingCost"]));
                 
                    return RedirectToAction("PurchasedSuccess");

                }

                SetStates();
                SetPaymentMethods();
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

        [HttpGet]
        public void SubtractExpressShippingCost()
        {
            Session["ExpressShip"] = false;
        }

        private void ShoppingBag()
        {
            if (Session != null)
            {
                var shippingCost = Convert.ToDecimal(ConfigurationManager.AppSettings["shippingcost"]);
                var expressshippingCost = Convert.ToDecimal(ConfigurationManager.AppSettings["expressshippingcost"]);
                var shippingOnPrice = Convert.ToDecimal(ConfigurationManager.AppSettings["shippingOnPrice"]);
                var currentUserCartItems = new ShoppingCartDataService().GetCurrentUserCartItems(Session.SessionID);
                if (currentUserCartItems != null)
                {
                    var totalPrice = currentUserCartItems.Sum(c => c.Quantity * c.UnitPrice);

                    if (Session["ExpressShip"] != null && Session["ExpressShip"].Equals(true))
                    {
                        Session["ShippingCost"] = totalPrice < shippingOnPrice ? expressshippingCost : shippingCost;
                    }
                    else if (Session["ExpressShip"] != null && Session["ExpressShip"].Equals(false))
                    {
                        Session["ShippingCost"] = totalPrice < shippingOnPrice ? shippingCost : 0;
                    }
                    else
                    {
                        Session["ShippingCost"] = Session["ShippingCost"] != null ? shippingCost : 0;
                    }

                    ViewBag.CartTotalPrice = totalPrice;
                    ViewBag.Cart = currentUserCartItems; ViewBag.CartUnits = currentUserCartItems.Count();
                }
            }
        }

        private void SetPaymentMethods()
        {
            ViewBag.Cards = new PaymentMethodsService().Get();
        }

        private void SetStates()
        {
            ViewBag.States = states;
        }
    }
}
