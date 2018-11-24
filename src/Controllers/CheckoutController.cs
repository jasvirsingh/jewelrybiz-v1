﻿using JewelryBiz.BusinessLayer;
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
            states = new List<object> {
new { SID = "AL", SName = "Alabama" },
new { SID = "AK", SName ="Alaska" },
new { SID = "AZ", SName = "Arizona" },
new { SID = "AR", SName = "Arkansas" },
new { SID = "CA", SName = "California" },
new { SID = "CO", SName = "Colorado" },
new { SID = "CT", SName = "Connecticut" },
new { SID = "DE", SName = "Delaware" },
new { SID = "FL", SName = "Florida" },
new { SID = "GA", SName = "Georgia" },
new { SID = "HI", SName = "Hawaii" },
new { SID = "ID", SName = "Idaho" },
new { SID = "IL", SName = "Illinois Indiana" },
new { SID = "IA", SName = "Iowa" },
new { SID = "KS", SName = "Kansas" },
new { SID = "KY", SName = "Kentucky" },
new { SID = "LA", SName = "Louisiana" },
new { SID = "ME", SName = "Maine" },
new { SID = "MD", SName = "Maryland" },
new { SID = "MA", SName = "Massachusetts" },
new { SID = "MI", SName = "Michigan" },
new { SID = "MN", SName = "Minnesota" },
new { SID = "MS", SName = "Mississippi" },
new { SID = "MO", SName = "Missouri" },
new { SID = "MT", SName = "Montana Nebraska" },
new { SID = "NV", SName = "Nevada" },
new { SID = "NH", SName = "New Hampshire" },
new { SID = "NJ", SName = "New Jersey" },
new { SID = "NM", SName = "New Mexico" },
new { SID = "NY", SName = "New York" },
new { SID = "NC", SName = "North Carolina" },
new { SID = "ND", SName = "North Dakota" },
new { SID = "OH", SName = "Ohio" },
new { SID = "OK", SName = "Oklahoma" },
new { SID = "OR", SName = "Oregon" },
new { SID = "PRI", SName = "Pennsylvania Rhode Island" },
new { SID = "SC", SName = "South Carolina" },
new { SID = "SD", SName = "South Dakota" },
new { SID = "TN", SName = "Tennessee" },
new { SID = "TX", SName = "Texas" },
new { SID = "UT", SName = "Utah" },
new { SID = "VT", SName = "Vermont" },
new { SID = "VA", SName = "Virginia" },
new { SID = "WA", SName = "Washington" },
new { SID = "WV", SName = "West Virginia" },
new { SID = "WI", SName = "Wisconsin" },
new { SID = "WY", SName = "Wyoming" }
            };

            cards = new List<object> {
                new { Type = "VISA" },
                new { Type = "Master Card" },
                new { Type = "AMEX" }
            };

        }
        
        // GET: Checkout
        public ActionResult Index()
        {
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
        
        public JsonResult QuanityChange(int type, int pId)
        {
            JewelryBizEntities context = new JewelryBizEntities();

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

            if (product.Quantity == 0)
            {
                quantity = 0;
            }
            else
            {
                quantity = product.Quantity;
            }

            return Json(new { d = quantity });
        }
        
        [HttpGet]
        public JsonResult UpdateTotal()
        {
            JewelryBizEntities context = new JewelryBizEntities();
            decimal total;
            try
            {

                total = context.ShoppingCartDatas.Select(p => p.UnitPrice * p.Quantity).Sum();
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
            ViewBag.States = states;
            ViewBag.Cards = cards;

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Purchase(JewelryBiz.UI.Models.Customer customer)
        {
            ViewBag.States = states;
            ViewBag.Cards = cards;

            if (ModelState.IsValid)
            {
                if (customer.ExpDate <= DateTime.Now)
                {
                    ModelState.AddModelError("", "Credit card has already expired");
                }

                if (customer.Ctype == "AMEX")
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
                        ModelState.AddModelError("", customer.Ctype + "must be 16 digits");
                    }
                }

                if (ModelState.IsValid)
                {
                    var c = new JewelryBiz.DataAccess.Models.Customer
                    {
                        FName = customer.FName,
                        LName = customer.LName,
                        Email = customer.Email,
                        Phone = customer.Phone,
                        Address1 = customer.Address1,
                        Address2 = customer.Address2,
                        Postcode = customer.Postcode,
                        State = customer.State,
                        CardType = customer.Ctype,
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
    }
}
