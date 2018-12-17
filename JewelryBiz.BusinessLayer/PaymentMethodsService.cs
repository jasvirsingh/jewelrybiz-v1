using JewelryBiz.DataAccess;
using JewelryBiz.DataAccess.Models;
using System.Collections.Generic;

namespace JewelryBiz.BusinessLayer
{
    public class PaymentMethodsService
    {
        public IEnumerable<PaymentMethod> Get()
        {
            return new PaymentMethodsDAL().Get();
        }
    }
}
