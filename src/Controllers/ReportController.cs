using JewelryBiz.BusinessLayer;
using JewelryBiz.DataAccess.Models;
using System.Web.Mvc;

namespace JewelryBiz.UI.Controllers
{
    public class ReportController : Controller
    {
        // GET: Report
        public ActionResult Index()
        {
            var result = new ReportsService().GetReports();
            return View(result);
        }

        [HttpPost]
        public void Generate()
        {
            var selectedReport = ((System.Web.HttpRequestWrapper)Request).Form["Report"];

            switch (selectedReport)
            {
                case "CUSTOMER_LIST":
                        new ReportsService().GenerateCustomersReport();
                    break;
                case "INVENTORY_LEVELS":
                    new ReportsService().GenerateFinishedGoodsInventoryReport();
                    break;
                case "MONTHLY_SALE":
                    new ReportsService().GenerateMonthlySalesReport();
                    break;
                case "YEARLY_SALE":
                    new ReportsService().GenerateYearlySalesReport();
                    break;
                case "INVENTORY_COSTS":
                    new ReportsService().GenerateRawMaterialInvReport();
                    break;
                default:
                    break;
        }
            
        }
    }
}