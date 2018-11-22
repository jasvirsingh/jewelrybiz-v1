using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using JewelryBiz.UI.Models;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Collections.Generic;
using JewelryBiz.BusinessLayer;
using JewelryBiz.UI.Validators;

namespace JewelryBiz.UI.Controllers
{
    [Authorize]
    public class AccountController : BaseController
    {
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;
        private ApplicationRoleManager _roleManager;

        public AccountController()
        {
        }

        public AccountController(ApplicationUserManager userManager, ApplicationSignInManager signInManager, ApplicationRoleManager roleManager )
        {
            UserManager = userManager;
            SignInManager = signInManager;
            RoleManager = roleManager;
        }

        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        public ApplicationRoleManager RoleManager
        {
            get {
                var role  = _roleManager ?? HttpContext.GetOwinContext().Get<ApplicationRoleManager>();
                return role;
            }
            private set {
                _roleManager = value;
            }
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        //
        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // This doesn't count login failures towards account lockout
            // To enable password failures to trigger account lockout, change to shouldLockout: true
            var result = SignInStatus.Success;
            switch (result)
            {
                case SignInStatus.Success:
                    return RedirectToAction("Index", "Product", new { area = "Admin" });
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Invalid login attempt.");
                    return View(model);
            }
        }

              //
        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            SetStates();
            return View();
        }

        // GET: /Account/EmailsSignup
        [AllowAnonymous]
        public ActionResult EmailsSignup()
        {
            return View();
        }

        // GET: /Account/Signup
        [HttpPost]
        [AllowAnonymous]
        public ActionResult Signup(EmailSignupModel model)
        {
            if (!ModelState.IsValid)
            {
                return View("EmailsSignup",model);
            }
            Subscription subscription = new Subscription()
            {
                Email = model.Email,
                IsActive = true
            };
            //_ctx.Subscriptions.Add(subscription);
           // _ctx.SaveChanges();
            ViewBag.Message = "You have subscriber successfully.";
            return View("EmailsSignup");
        }

        //
        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(RegisterViewModel model)
        {
            const string roleAdmin = "Admin";
            if (ModelState.IsValid)
            {
                var u = new JewelryBiz.DataAccess.Models.User
                {
                    FName = model.FirstName,
                    LName = model.LastName,
                    Email = model.Email,
                    Phone = model.Phone,
                    Address1 = model.Address1,
                    Address2 = model.Address2,
                    Postcode = model.Postcode,
                    State = model.State,
                    Password = model.Password,
                };

                var customerService = new CustomerService();
                customerService.Create(u);
                //_ctx.Users.Add(u);
                //_ctx.SaveChanges();
                ViewBag.Message = "User created successfully.";
                return RedirectToAction("Register", "Account");
                /*var user = new ApplicationUser { UserName = model.Email, Email = model.Email };
                var result = await UserManager.CreateAsync(user, model.Password);

                if (result.Succeeded)
                {
                    var role = RoleManager.FindByName(roleAdmin);
                    if (role == null)
                    {
                        role = new IdentityRole();
                        var roleresult = RoleManager.Create(role);
                    }

                    var roleResult = await UserManager.AddToRoleAsync(user.Id, roleAdmin);
                    if (!roleResult.Succeeded)
                    {
                        ModelState.AddModelError("", result.Errors.First());
                        return View();
                    } else
                    {
                        await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                        return RedirectToAction("Index", "Product", new { area = "Admin" });
                    }
                }
                AddErrors(result);
            }*/
            }
            SetStates();
            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ConfirmEmail
        [AllowAnonymous]
        public async Task<ActionResult> ConfirmEmail(string userId, string code)
        {
            if (userId == null || code == null)
            {
                return View("Error");
            }
            var result = await UserManager.ConfirmEmailAsync(userId, code);
            return View(result.Succeeded ? "ConfirmEmail" : "Error");
        }

        //
        // GET: /Account/ForgotPassword
        [AllowAnonymous]
        public ActionResult ForgotPassword()
        {
            return View();
        }

        //
        // POST: /Account/ForgotPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ForgotPassword(ForgotPasswordViewModel model)
        {
            if (ModelState.IsValid)
            {
                var user = await UserManager.FindByNameAsync(model.Email);
                if (user == null || !(await UserManager.IsEmailConfirmedAsync(user.Id)))
                {
                    // Don't reveal that the user does not exist or is not confirmed
                    return View("ForgotPasswordConfirmation");
                }

                // For more information on how to enable account confirmation and password reset please visit http://go.microsoft.com/fwlink/?LinkID=320771
                // Send an email with this link
                // string code = await UserManager.GeneratePasswordResetTokenAsync(user.Id);
                // var callbackUrl = Url.Action("ResetPassword", "Account", new { userId = user.Id, code = code }, protocol: Request.Url.Scheme);		
                // await UserManager.SendEmailAsync(user.Id, "Reset Password", "Please reset your password by clicking <a href=\"" + callbackUrl + "\">here</a>");
                // return RedirectToAction("ForgotPasswordConfirmation", "Account");
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        //
        // GET: /Account/ForgotPasswordConfirmation
        [AllowAnonymous]
        public ActionResult ForgotPasswordConfirmation()
        {
            return View();
        }

        //
        // GET: /Account/ResetPassword
        [AllowAnonymous]
        public ActionResult ResetPassword(string code)
        {
            return code == null ? View("Error") : View();
        }

        //
        // POST: /Account/ResetPassword
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }
            var user = await UserManager.FindByNameAsync(model.Email);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            var result = await UserManager.ResetPasswordAsync(user.Id, model.Code, model.Password);
            if (result.Succeeded)
            {
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            AddErrors(result);
            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Home");
        }

        [AllowAnonymous]
        public ActionResult Logout()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Product");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }
        
        private void SetStates()
        {
            ViewBag.States = new List<object> {
new { SID = "AL", SName = "Alabama" },
new { SID = "AK", SName ="Alaska" },
new { SID = "AZ", SName = "Arizona" },
new { SID = "AR", SName = "Arkansas" },
new { SID = "CA", SName = "California" },
new { SID = "CO", SName = "Colorado" },
new { SID = "CT", SName = "Connecticut" },
new { SID = "DE", SName = "Delaware" },
new { SID = "FL", SName = "Florida" },
new { SID = "GA", SName = "Georgia" },
new { SID = "HI", SName = "Hawaii" },
new { SID = "ID", SName = "Idaho" },
new { SID = "IL", SName = "Illinois Indiana" },
new { SID = "IA", SName = "Iowa" },
new { SID = "KS", SName = "Kansas" },
new { SID = "KY", SName = "Kentucky" },
new { SID = "LA", SName = "Louisiana" },
new { SID = "ME", SName = "Maine" },
new { SID = "MD", SName = "Maryland" },
new { SID = "MA", SName = "Massachusetts" },
new { SID = "MI", SName = "Michigan" },
new { SID = "MN", SName = "Minnesota" },
new { SID = "MS", SName = "Mississippi" },
new { SID = "MO", SName = "Missouri" },
new { SID = "MT", SName = "Montana Nebraska" },
new { SID = "NV", SName = "Nevada" },
new { SID = "NH", SName = "New Hampshire" },
new { SID = "NJ", SName = "New Jersey" },
new { SID = "NM", SName = "New Mexico" },
new { SID = "NY", SName = "New York" },
new { SID = "NC", SName = "North Carolina" },
new { SID = "ND", SName = "North Dakota" },
new { SID = "OH", SName = "Ohio" },
new { SID = "OK", SName = "Oklahoma" },
new { SID = "OR", SName = "Oregon" },
new { SID = "PRI", SName = "Pennsylvania Rhode Island" },
new { SID = "SC", SName = "South Carolina" },
new { SID = "SD", SName = "South Dakota" },
new { SID = "TN", SName = "Tennessee" },
new { SID = "TX", SName = "Texas" },
new { SID = "UT", SName = "Utah" },
new { SID = "VT", SName = "Vermont" },
new { SID = "VA", SName = "Virginia" },
new { SID = "WA", SName = "Washington" },
new { SID = "WV", SName = "West Virginia" },
new { SID = "WI", SName = "Wisconsin" },
new { SID = "WY", SName = "Wyoming" }
            };
        }
        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion
    }
}