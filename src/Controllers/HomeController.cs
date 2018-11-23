using JewelryBiz.UI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class HomeController : BaseController
    {
        
        public ActionResult Index()
        {
            ViewBag.Products = _ctx.Products.ToList<Product>();
            //ViewBag.Categories = _ctx.Categories.ToList<Category>();
            var model = new ProductCategoryModel();
            //List<SelectListItem> categories = _ctx.Categories.ToList<Category>()
            //        .OrderBy(n => n.CategoryId)
            //            .Select(n =>
            //            new SelectListItem
            //            {
            //                Value = n.CategoryId.ToString(),
            //                Text = n.CategoryName
            //            }).ToList();

            //var defaultCategory = new SelectListItem()
            //{
            //    Value = null,
            //    Text = "--- Select ---"
            //};
            //categories.Insert(0, defaultCategory);
            //ViewBag.Categories = categories;
            return View();
        }

        public JsonResult GetCategories()
        {
            ViewBag.Products = _ctx.Products.ToList<Product>();
            //ViewBag.Categories = _ctx.Categories.ToList<Category>();
            var model = new ProductCategoryModel();
            List<SelectListItem> categories = _ctx.Categories.ToList<Category>()
                    .OrderBy(n => n.CategoryId)
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

        public ActionResult Category(string catName)
        {
            List<Product> products;
            if (catName == "")
            {
                products = _ctx.Products.ToList<Product>();
            } else { 
                products = _ctx.Products.Where(p => p.Category == catName).ToList<Product>();
            }
            ViewBag.Products = products;
            return View("Index");
        }

        public ActionResult GetProducts(string catName)
        {
            List<Product> products;
            if (catName == "")
            {
                products = _ctx.Products.ToList<Product>();
            }
            else
            {
                products = _ctx.Products.Where(p => p.Category == catName).ToList<Product>();
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
            Product product = _ctx.Products.FirstOrDefault(p => p.PID == pId);
            if (product != null && product.UnitsInStock > 0)
            {
                // check if product already existed
                ShoppingCartData cart = _ctx.ShoppingCartDatas.FirstOrDefault(c => c.PID == pId);
                if (cart != null)
                {
                    cart.Quantity++;
                }
                else
                {

                    cart = new ShoppingCartData
                    {
                        PName = product.PName,
                        PID = product.PID,
                        UnitPrice = product.UnitPrice,
                        Quantity = 1
                    };

                    _ctx.ShoppingCartDatas.Add(cart);
                }
                product.UnitsInStock--;
                _ctx.SaveChanges();
            }
        }

        public ActionResult About()
        {
            ViewBag.Message = "";

            return View();
        }

        public ActionResult Contact()
        {
            return View();
        }
    }
}