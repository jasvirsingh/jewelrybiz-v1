using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class ReportsService
    {
        public IEnumerable<Report> GetReports()
        {
            return new ReportsDAL().GetReports();
        }

        public void GenerateCustomersReport()
        {
            new ReportsDAL().GenerateCustomersReport();
        }

        public void GenerateFinishedGoodsInventoryReport()
        {
            new ReportsDAL().GenerateFinishedGoodsInventoryReport();
        }

        public void GenerateMonthlySalesReport()
        {
            new ReportsDAL().GenerateMonthlySalesReport();
        }

        public void GenerateYearlySalesReport()
        {
            new ReportsDAL().GenerateYearlySalesReport();
        }

        public void GenerateRawMaterialInvReport()
        {
            new ReportsDAL().GenerateRawMaterialInventoryReport();
        }
    }
}
