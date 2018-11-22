using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace JewelryBiz.DataAccess.Models
{
    public class User
    {
        [Required(ErrorMessage = "FirstName is required")]
        [Display(Name = "First Name")]
        public string FName { get; set; }

        [Required(ErrorMessage = "LastNme is required")]
        [Display(Name = "Last Name")]
        public string LName { get; set; }

        [Display(Name = "Phone")]
        [Required(ErrorMessage = "Phone is required")]
        [StringLength(10, MinimumLength = 10, ErrorMessage = "Phone must be 10 digits")]
        public string Phone { get; set; }

        [Display(Name = "Address1")]
        [Required(ErrorMessage = "Address is required")]
        public string Address1 { get; set; }

        [Display(Name = "Address 2")]
        public string Address2 { get; set; }

        [Required(ErrorMessage = "Postcode is required")]
        [StringLength(4, MinimumLength = 4, ErrorMessage = "Invalid postcode")]
        public string Postcode { get; set; }

        [Required(ErrorMessage = "State is required")]
        public string State { get; set; }

        [Display(Name = "State")]
        public IList<string> States { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress]
        public string Email { get; set; }

        [StringLength(16, MinimumLength = 6, ErrorMessage = "Password must be minimum of 6 characters and maximun 10 characters")]
        [EmailAddress]
        public string Password { get; set; }
    }
}
