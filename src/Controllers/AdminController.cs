using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class AdminController : BaseController
    {
        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Report()
        {
            return View();
        }
    }
}