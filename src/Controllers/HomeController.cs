﻿using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using JewelryBiz.UI.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class HomeController : BaseController
    {
        
        public ActionResult Index()
        {
            ShoppingBag();

            ViewBag.Products = new ProductService().GetAll();
            return View();
        }

        public JsonResult GetCategories()
        {
            ViewBag.Products = new ProductService().GetAll();
            //ViewBag.Categories = _ctx.Categories.ToList<Category>();
            var model = new ProductCategoryModel();
            var categoryService = new CategoryService();
            List<SelectListItem> categories = categoryService.Get()
                .Where(c => c.ParentCategoryId == 0)
                        .Select(n =>
                        new SelectListItem
                        {
                            Value = n.CategoryId.ToString(),
                            Text = n.CategoryName
                        }).ToList();

            var defaultCategory = new SelectListItem()
            {
                Value = null,
                Text = "--- Select ---"
            };
            categories.Insert(0, defaultCategory);
           return Json(categories, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Category(int pCategory)
        {
            IList<Product> products;
            if (pCategory == 0)
            {
                products = new ProductService().GetAll();
            } else { 
                products = new ProductService().GetAll().Where(p => p.CategoryId == pCategory).ToList<Product>();
            }
            ViewBag.Products = products;
            return View("Index");
        }

        public ActionResult GetProducts(string catName)
        {
            IList<Product> products;
            if (catName == "")
            {
                products = new ProductService().GetAll();
            }
            else
            {
                products = new ProductService().GetAll().Where(p => p.Category == catName).ToList<Product>();
            }
            ViewBag.Products = products;
            return View("Index");
        }

        public ActionResult AddToCart(int id)
        {
            addToCart(id);
            return RedirectToAction("Index");
        }

        private void addToCart(int pId)
        {
            // check if product is valid
           JewelryBiz.DataAccess.Models.Product product = new ProductService().GetById(pId);
            if (product != null && product.UnitsInStock > 0)
            {
                // check if product already existed
                CartItem cart = new ShoppingCartDataService().GetByProductId(Session.SessionID, pId);
                if (cart != null)
                {
                    cart.Quantity++;
                    new ShoppingCartDataService().IncreaseCartItemQuantity(Session.SessionID, product.ProductId);
                }
                else
                {
                   var cartItem = new CartItem
                    {
                        PName = product.PName,
                        ProductId = product.ProductId,
                        UnitPrice = product.UnitPrice,
                        Quantity = 1,
                        UserSessionId = Session.SessionID
                    };
                    new ShoppingCartDataService().AddCartItem(cartItem);
                }
                product.UnitsInStock--;
            }
        }

        public ActionResult About()
        {
            ShoppingBag();
            ViewBag.Message = "";

            return View();
        }

        public ActionResult Contact()
        {
            ShoppingBag();
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