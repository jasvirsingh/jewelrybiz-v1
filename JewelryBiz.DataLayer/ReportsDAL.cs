using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using JewelryBiz.DataAccess.Core;
using JewelryBiz.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JewelryBiz.DataAccess
{
   public class ReportsDAL
    {
        public IEnumerable<Report> GetReports()
        {
                var sqlDAL = new SqlDataAccess();
                var result = sqlDAL.ExecuteStoredProcedure("procGetReports", null);
                if (result != null)
                {
                    IEnumerable<DataRow> rows = from rpt in result.Tables[0].AsEnumerable()
                                                select rpt;
                    var report = rows.Select(r => new Report
                    {
                        ReportName = Convert.ToString(r["ReportName"]),
                        Description = Convert.ToString(r["Description"])
                    });

                    return report;
                }
                return null;
        }

        public void  GenerateCustomersReport()
        {
            var sqlDAL = new SqlDataAccess();
            var result = sqlDAL.ExecuteStoredProcedure("procGetCustomers", null);
            if (result != null)
            {
                //Create a dummy GridView
                GridView GridView1 = new GridView();
                GridView1.AllowPaging = false;
                GridView1.DataSource = result;
                GridView1.DataBind();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition",
                    "attachment;filename=CustomersReport.pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                StringWriter sw = new StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);
                GridView1.RenderControl(hw);
                StringReader sr = new StringReader(sw.ToString());
                Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
                HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
                PdfWriter.GetInstance(pdfDoc, HttpContext.Current.Response.OutputStream);
                pdfDoc.Open();
                htmlparser.Parse(sr);
                pdfDoc.Close();
                HttpContext.Current.Response.Write(pdfDoc);
                HttpContext.Current.Response.End();        
            }
        }
    }
}
