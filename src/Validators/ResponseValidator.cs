using System.Text;
using System.Web.Mvc;

namespace JewelryBiz.UI.Validators
{
    /// <summary>
    /// This class provides messaging fundtions to the Modal message box in the UI. 
    /// </summary>
    public static class ResponseValidator
    {
        /// <summary>
        /// 
        /// </summary>
        public enum MessageType
        {
            Alert, Confirm, Prompt, Info, Error
        }

        //Added a Button Type Enumerator
        public enum ButtonType
        {
            Close, OkCancel, Ok, RetryCancel
        }


        /// <summary>
        /// Validates the mode state and shows errors if needed.
        /// </summary>
        public static void ValidateModelState(ModelStateDictionary modelState, ViewDataDictionary view, string nodeCode, string userID)
        {
            //I do not want the application to fails becuase of a logging issue.
            try
            {
                StringBuilder friendlyMessages = new StringBuilder();
                StringBuilder innerExceptions = new StringBuilder();

                //Loop errrors and build string builders
                foreach (ModelState state in modelState.Values)
                {
                    foreach (ModelError error in state.Errors)
                    {
                        //Extract messages
                        if (error.ErrorMessage != null)
                        {
                            friendlyMessages.Append(error.ErrorMessage + "<br>");
                        }
                        else
                        {
                            innerExceptions.Append("Model state is invalid but there is no Message.");
                        }

                        //Extract exception
                        if (error.Exception != null)
                        {
                            innerExceptions.Append(error.Exception.Message);
                        }
                        else
                        {
                            innerExceptions.Append("Model state is invalid but there is no Exception.");
                        }
                    }
                }

                //Log to DB and flat file.
                //InspectorAgent.LogRequest(friendlyMessages.ToString(), nodeCode, userID);
                //Logger.Error(friendlyMessages.ToString());

                //InspectorAgent.LogRequest(friendlyMessages.ToString(), nodeCode, userID);
                //Logger.Error("Node: " + nodeCode + "..." + innerExceptions.ToString());

                //show message
                ShowMessage("Error",
                                "",
                                friendlyMessages.ToString(),
                                ResponseValidator.MessageType.Error, ResponseValidator.ButtonType.Ok, view);
            }
            catch
            {
            }
        }

        /// <summary>
        /// Validates the mode state and shows errors if needed.
        /// </summary>
        public static void ValidateModelState(ModelStateDictionary modelState, ViewDataDictionary view)
        {
            ValidateModelState(modelState, view, "NA", "NA");
        }


        /// <summary>
        /// This stores messages in the viewbag for modal display. 
        /// </summary>
        public static void ShowMessage(string title, string subTitle, string message, MessageType messageType, ViewDataDictionary view)
        {
            ShowMessage(title, subTitle, message, messageType, ButtonType.RetryCancel, view);
        }

        /// <summary>
        /// This stores messages in the viewbag for modal display. 
        /// </summary>
        public static void ShowMessage(string title, string subTitle, string message, MessageType messageType, ButtonType messageButtons, ViewDataDictionary view)
        {
            //Class='error', 'warning', 'informational'
            StringBuilder sb = new StringBuilder();
            sb.Append(@"<h2>" + title + "</h2>");
            sb.Append(@"<em>" + subTitle + "</em>");
            sb.Append("<p>" + message + "</p>");

            //Stuff the error in the view.
            if (view["Message"] != null)
            {
                view["Message"] = view["Message"].ToString() + sb.ToString();
            }
            else
            {
                view["Message"] = sb.ToString();
            }

            //Stuff the message type in the view.
            //MessageType: Alert, Confirm, Prompt, Info, Error
            view["MessageType"] = messageType;

            //This does the button Type Logic
            switch (messageButtons)
            {
                case ButtonType.Close:
                    view["MessageButtons"] = "Close";
                    break;
                case ButtonType.Ok:
                    view["MessageButtons"] = "OK";
                    break;
                case ButtonType.OkCancel:
                    view["MessageButtons"] = "OK,Cancel";
                    break;
                case ButtonType.RetryCancel:
                    view["MessageButtons"] = "Retry,Cancel";
                    break;
                default:
                    view["MessageButtons"] = "Close";
                    break;
            }

        }
    }
}