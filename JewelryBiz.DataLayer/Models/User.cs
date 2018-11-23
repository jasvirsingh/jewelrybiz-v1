using System.ComponentModel.DataAnnotations;

namespace JewelryBiz.DataAccess.Models
{
    public class User
    {
        [Required(ErrorMessage ="First name is required.")]
        [Display(Name = "FirstName")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "Last name is required.")]
        [Display(Name = "LastName")]
        public string LastName { get; set; }

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress]
        [Display(Name = "Email")]
        public string Email { get; set; }

        //[Required(ErrorMessage = "User name is required.")]
        //[Display(Name = "UserName")]
        //public string UserName { get; set; }

        [Required]
        [StringLength(16, MinimumLength = 6, ErrorMessage = "Password must be minimum of 6 characters and maximun 10 characters")]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm password")]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }

        public int RoleId { get; set; }
    }
}
