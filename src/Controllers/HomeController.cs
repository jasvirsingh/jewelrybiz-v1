using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using JewelryBiz.DataLayer;
using JewelryBiz.DataLayer.Domain;
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
            ViewBag.Categories = GetAllCategories();
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

        public ActionResult Category(int CategoryId)
        {
            IList<Product> products;
            if (CategoryId == -1)
            {
                products = new ProductService().GetAll();
            }
            else
            { 
                products = new ProductService().GetAll()
                    .Where(p => p.CategoryId == CategoryId)
                    .ToList<Product>();
            }

            ViewBag.Products = products;
            ViewBag.Categories = GetAllCategories();
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
                products = new ProductService().GetAll()
                    .Where(p => p.Category == catName)
                    .ToList<Product>();
            }
            ViewBag.Products = products;
            return View("Index");
        }

        [HttpPost]
        public ActionResult AddToCart(SelectedItem item)
        {
            addToCart(item.ProductId, item.Quantity);
            return RedirectToAction("Index");
        }

        public ActionResult ProductDetails(int id)
        {
            //addToCart(id);
            var product = new ProductService().GetById(id);
            var productItem = new SelectedItem
            {
                ProductId = id,
                ProductName = product.PName,
                Description = product.Description,
                OnHand = product.UnitsInStock,
                UnitPrice = product.UnitPrice,
                Image = product.Image
            };
            var qtyRange = Enumerable.Range(1, product.UnitsInStock);
            List<SelectListItem> quantityList = qtyRange.Select(q =>
                       new SelectListItem
                       {
                           Value = q.ToString(),
                           Text = q.ToString()
                       }).ToList();

            ViewBag.Quantity = quantityList;
            return View(productItem);
        }

        private void addToCart(int pId, int qty)
        {
            // check if product is valid
           var product = new ProductService().GetById(pId);
            if (product != null && product.UnitsInStock > 0)
            {
                // check if product already existed
                CartItem cart = new ShoppingCartDataService().GetByProductId(Session.SessionID, pId);
                if (cart != null)
                {
                    cart.Quantity++;
                    new ShoppingCartDataService().UpdateCartItemQuantity(Session.SessionID, product.ProductId, qty);
                }
                else
                {
                   var cartItem = new CartItem
                    {
                        PName = product.PName,
                        ProductId = product.ProductId,
                        UnitPrice = product.UnitPrice,
                        Quantity = qty,
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

        private List<SelectListItem> GetAllCategories()
        {
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
                Value = "-1",
                Text = "--- All Products ---"
            };
            categories.Insert(0, defaultCategory);
            return categories;
        }
    }
}