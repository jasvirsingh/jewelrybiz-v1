using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using JewelryBiz.DataLayer.Domain;
using System.Linq;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class ProductsController : BaseController
    {
        public ActionResult Index(int cid)
        {
            ShoppingBag();
            var products = new ProductService().GetAll()
                    .Where(p => p.CategoryId == cid)
                    .ToList<Product>();

            return View(products);
        }

        public ActionResult Search(string searchStr)
        {
            var result = new ProductService().Search(searchStr);
            return View("Index", result);
        }

        public ActionResult ProductDetails(int pid)
        {
            var product = new ProductService().GetById(pid);
            var productItem = new SelectedItem
            {
                ProductId = pid,
                ProductName = product.PName,
                Description = product.Description,
                OnHand = product.UnitsInStock,
                UnitPrice = product.UnitPrice,
                Image = product.Image,
                PCategoryName = product.PCategoryName
            };
            var qtyRange = Enumerable.Range(1, product.UnitsInStock);
            var quantityList = qtyRange.Select(q =>
                       new SelectListItem
                       {
                           Value = q.ToString(),
                           Text = q.ToString()
                       }).ToList();

            ViewBag.Quantity = quantityList;

            if (product.PCategoryName == "MOTHER_BRACELET")
            {
                return RedirectToAction("MomyBracelet", new { pid = pid });
            }

            if (product.PCategoryName == "BABY_BRACELET")
            {
                return RedirectToAction("BabyBracelet",  new { pid = pid });
            }

            if (product.PCategoryName == "EARRING")
            {
                return RedirectToAction("Earring", new { pid = pid });
            }

            if (product.PCategoryName == "SET")
            {
                return RedirectToAction("Set", new { pid = pid });
            }

            ShoppingBag();

            return View(productItem);
        }

        public ActionResult MomyBracelet(int pid)
        {
            var model = GetDetails(pid);
            ShoppingBag();
            return View(model);
        }

        public ActionResult BabyBracelet(int pid)
        {
            var model = GetDetails(pid);
            ShoppingBag();
            return View(model);
        }

        public ActionResult Earring(int pid)
        {
            var model = GetDetails(pid);
            ShoppingBag();
            return View(model);
        }

        public ActionResult Set(int pid)
        {
            var model = GetDetails(pid);
            ShoppingBag();
            return View(model);
        }

        private SelectedItem GetDetails(int pid)
        {
            var product = new ProductService().GetById(pid);
            var materials = new ProductMaterialService().Get(product.CategoryId);
            var productItem = new SelectedItem
            {
                ProductId = pid,
                ProductName = product.PName,
                Description = product.Description,
                OnHand = product.UnitsInStock,
                UnitPrice = product.UnitPrice,
                Image = product.Image,
                PCategoryName = product.PCategoryName,
                Materials = product.Materials
            };
            var qtyRange = Enumerable.Range(1, product.UnitsInStock);
            var quantityList = qtyRange.Select(q =>
                       new SelectListItem
                       {
                           Value = q.ToString(),
                           Text = q.ToString()
                       }).ToList();

            ViewBag.Quantity = quantityList;
            return productItem;
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