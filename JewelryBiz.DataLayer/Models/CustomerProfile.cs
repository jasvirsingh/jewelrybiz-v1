using System;
using System.ComponentModel.DataAnnotations;

namespace JewelryBiz.DataAccess.Models
{
    public class CustomerProfile
    {
        [Display(Name = "First Name")]
        public string FName { get; set; }

        [Display(Name = "Last Name")]
        public string LName { get; set; }

        [Display(Name = "Phone")]
        public string Phone { get; set; }

        [Display(Name = "Address1")]
        public string Address1 { get; set; }

        [Display(Name = "Address 2")]
        public string Address2 { get; set; }

        [Display(Name = "Post Code")]
        public string Postcode { get; set; }

        [Display(Name = "State")]
        public string State { get; set; }

        [Display(Name = "Payment Method")]
        public string PaymentMethod { get; set; }

        [Display(Name = "Card Number")]
        public string CardNo { get; set; }

        [Display(Name = "Expiration")]
        public DateTime ExpDate { get; set; }

        [Display(Name = "Email")]
        public string Email { get; set; }
    }
}
