/// <reference path="sodexo.ui.js" />
/// <reference path="jquery-1.5.2-vsdoc.js />

//////////////////////////////////////////
// Modified 7.20.2012 - Rich Lane - Edited formatting methods to allow users to cut and paste values.
//////////////////////////////////////////

var keycount = 0;

//
$(document).ready(function () {
	CheckMessages();
	//This section is to add the validation image icons next to the text
	var itemlist = $(".ImageValidation");
	for (var i = 0; i < itemlist.length; i++) {
		var markup = ' <img style="display:none;" id="' + $(itemlist[i]).attr('id') + '-Image" src="' + $("#StaticFileURL").val() + '/content/images/erroricon.png" title="Field Error" alt="Field Error" />'
		if ($(itemlist[i]).hasClass("AutoComplete")) {
			$("#" + $(itemlist[i]).attr('id') + "-mag").after(markup);
		} else {
			var controlName = $(itemlist[i]).attr("id");
			if ($("#" + controlName + "-ValidatorSpan").length > 0) {
				$("#" + controlName + "-ValidatorSpan").html(markup);
			} else {
				$(itemlist[i]).after(markup);
			}
		}
	};
	$("input[type=submit][name=button]").removeClass("readonly");
	$(".Decimal").attr("DecimalPlaces", "2");
});


//Prevents users from hitting escape character. Not sure why.
$("body").keydown(function (event) {
	if (event.keyCode == 27) {
		keycount++;
		if (keycount > 1) {
			event.preventDefault();
		}
	}
});

///////////////////
// No Focus on the grids
///////////////////
$(".Button").live("click", function () {
	if ($(this).hasClass("TableInsertButton") ||
        $(this).hasClass("TableEditButton") ||
        $(this).hasClass("TableDeleteButton") ||
        $(this).hasClass("TableInsertBeforeButton") ||
        $(this).hasClass("TableInsertAfterButton")) {
		$(".NoFocus").attr("tabindex", "10000");
	}

});

$(".NoFocus").live("click", function () {
	$(this).removeAttr("tabindex");
});

///////////////////
// Messaging Functions
///////////////////

//Check to see if we need to display any messages stored by MessageControl.cs.
function CheckMessages() {
	var message = $("#Message");
	var messageType = $("#MessageType");
	var messageButtons = $("#MessageButtons");
	if (message.length > 0) {
		Message(message.val(), messageType.val(), messageButtons.val());
	}
	message.val("");
	messageType.val("");
	messageButtons.val("");
}

//Activates the Messaging Information Screen
//Options for Type: Alert, Confirm, Prompt, Info, Error
//Refocus expects the ID of the control you want the focus to go back to
function Message(Message, Type, Buttons, RefocusOn) {
	$("#Message-Box").remove();
	$("#MessageOverlay").remove();
	if (Message == null) return;
	if (Message.length < 2) return;

	//Checks to See if You have made any button selections and if so Adds them in
	if (Buttons == null) {
		Buttons = "OK";
	}
	//Watch the message type
	if (Type == null) {
		Type = "Info";
	}
	//Builds the button Collection
	var buttonArray = Buttons.split(',');
	var buttonHtml = "";
	for (var i = 0; i < buttonArray.length; i++) {
		if (buttonArray[i] == "Cancel") {
			buttonHtml = buttonHtml + "<input type='button' class='ModalButton' id='Modal" + buttonArray[i] + "Button' value='" + buttonArray[i] + "' style='width: 70px; padding:0px;'>";
		}
		else {
			buttonHtml = buttonHtml + "<input type='button' class='ModalButton' id='Modal" + buttonArray[i] + "Button' value='" + buttonArray[i] + "' style='width: 70px; padding:0px;'>";
		}

	}
	//Builds The Messages
	$("body").append("<div id='MessageOverlay'><div id='Message-Box'><div id='Message-InBox'><div id='Message-BoxContent'><div id='Message-BoxContenedor' class='" + Type
    + "'>" + Message + "<div id='Message-Buttons'>" + buttonHtml
    + "</div></div></div></div></div></div>");

	el = document.getElementById("MessageOverlay");
	el.style.visibility = (el.style.visibility == "visible") ? "visible" : "visible";

	$("#Message-Box input:first").focus();
	$("body").data("RefocusOn", RefocusOn);
}

$(".ModalButton").live('click', function () {
	$("#MessageOverlay").remove();
	if ($("body").data("RefocusOn") != undefined) {
		$("#" + $("body").data("RefocusOn")).select();
		$("#" + $("body").data("RefocusOn")).focus();
	}
});

function ErrorMessage(message) {
	//en-us or fr-ca
	var language = "en-us";
	try {
		language = GetLanguageFromBrowser();
	} catch (e) {
	}
	var title = 'Error';
	if (language == "fr-ca") {
		title = 'Erreur';
	}
	Message('<h1>' + title + '</h1><p>' + message + '</p>', 'Error');

}
function WarningMessage(message) { Message('<h1>&nbsp;</h1><p>' + message + '</p>', 'Alert'); }
function InformationMessage(message) { Message('<h1>&nbsp;</h1><p>' + message + '</p>'); }
function SuccessMessage(message) { Message('<h1>&nbsp;</h1><p>' + message + '</p>'); }
function ValidationMessage(message) { Message('<h1>&nbsp;</h1><p>' + message + '</p>'); }

///////////////////
// Field Formating
///////////////////

//Decimal Places
$(".Decimal").live("focus", function () {
	var attribute = $(this).attr("DecimalPlaces");
	if (typeof attribute == 'undefined') {
		$(this).attr("DecimalPlaces", "2");
	}
});


//If a input is a currency it processes it for you
$(".Currency").live('blur', function () {
	var number = $(this).val();
	number = isNaN(number) || number === '' || number === null ? 0.00 : number;
	$(this).val(parseFloat(number).toFixed(2))
});

//This logic formats curreny
function formatCurrency(num) { num = isNaN(num) || num === '' || num === null ? 0.00 : num; return parseFloat(num).toFixed(2); }

//Required Number Validation
$(".RequiredNumber").live("keydown", function (event) {
	var code = event.keyCode || event.which;
	//Backspace, Tab, Negative, Period, Delete
	if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 46 || event.keyCode == 189 || event.keyCode == 190 || event.keyCode == 110 || event.keyCode == 109 || event.keyCode == 17 || event.keyCode == 67 || event.keyCode == 86)
		return true;
	if (event.keyCode > 95 && event.keyCode < 106)
		return true;
	if (event.keyCode > 47 && event.keyCode < 58)
		return true;
	else
		window.event.returnValue = false;
});

//If special Characters are found it supresses them
$(".RequiredNumber").live("keyup", function () {
	currentValue = $(this).val();
	var specialCharacters = currentValue.replace(/[^0-9\.-]+/g, "*");
	if (specialCharacters.indexOf("*") > -1) {
		$(this).val(currentValue.replace(/[^0-9\.-]+/g, ""));
	}
	if (currentValue.endsWith("-")) {
		$(this).val("-" + (currentValue.substr(0, currentValue.length - 1)).replace(/[^0-9\.]+/g, ""));
	}
	if (currentValue.indexOf("-") > 0) {
		$(this).val("-" + currentValue.replace(/[^0-9\.]+/g, ""));
	}
});

//If special Characters are found it supresses them allow letters
$(".AlphaNumeric").live("keyup", function () {
	currentValue = $(this).val();
	var specialCharacters = currentValue.replace(/[^a-zA-Z0-9\.-]+/g, "*");
	if (specialCharacters.indexOf("*") > -1) {
		$(this).val(currentValue.replace(/[^a-zA-Z0-9\.-]+/g, ""));
	}
});

//If special Characters are found it supresses them allow letters
$(".Alpha").live("keyup", function () {
	currentValue = $(this).val();
	var specialCharacters = currentValue.replace(/[^a-zA-Z\.-]+/g, "*");
	if (specialCharacters.indexOf("*") > -1) {
		$(this).val(currentValue.replace(/[^a-zA-Z\.-]+/g, ""));
	}
});

//Whole number
$(".WholeNumber").live("keydown", function (e) {
	var code = event.keyCode || event.which;
	if (e.ctrlKey) {
		if (event.keyCode == 67 || event.keyCode == 86) {
			return true;
		}
	}
	////Added by Sri. will prevent users using shift+numbers.
	if (e.shiftKey) {
		if (event.keyCode > 47 && event.keyCode < 58) {
			return false;
		}
	}
	//Backspace, Tab, Negative, Period, Delete
	if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 46 || event.keyCode == 189 || event.keyCode == 109 || event.keyCode == 17)
		return true;
	if (event.keyCode > 95 && event.keyCode < 106)
		return true;
	if (event.keyCode > 47 && event.keyCode < 58)
		return true;
	else
		//window.event.returnValue = null;
		return false;
});

//If a input is a whole number it will format the data properly
$(".WholeNumber").live("keyup", function (e) {
	var code = e.keyCode || e.which;
	var rawValue = $(this).val();
	if (rawValue.endsWith("-")) {
		rawValue = "-" + rawValue.substr(0, rawValue.length - 1)
	}
});


//Only allows positive numbers
$(".PositiveOnly").live("keydown", function (e) {
	var code = e.keyCode || e.which;
	if (code == '109' || code == '189') {
		return false;
	}
	return true;
});

//Defaults the number to zero if empty
$(".DefaultZero").live("blur", function (e) {
	if ($(this).val() == "") {
		$(this).val("0");
	}
	$('form').validate().element(this);
	$(this).validate();
});


//Number Validation
$("INPUT[data-val-number]").live("keydown", function (event) {
	var code = event.keyCode || event.which;
	//Backspace, Tab, Negative, Period, Delete
	if (event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 46 || event.keyCode == 189 || event.keyCode == 190 || event.keyCode == 110 || event.keyCode == 109 || event.keyCode == 17 || event.keyCode == 67 || event.keyCode == 86)
		return;
	if (event.keyCode > 95 && event.keyCode < 106)
		return;
	if (event.keyCode > 47 && event.keyCode < 58)
		return;
	else
		window.event.returnValue = false;
});

String.prototype.endsWith = function (suffix) { return this.indexOf(suffix, this.length - suffix.length) !== -1; };

//Decimal Place Validation
$("INPUT[DecimalPlaces]").live("keydown", function (e) {
	var code = e.keyCode || e.which;
	if (code == '190' || code == '110') {
		if ($(this).val().split('.').length > 2) {
			window.event.returnValue = false;
		}
	}
	if (code == '189' || code == '109') {
		if ($(this).val().indexOf('-') > 0) {
			window.event.returnValue = false;
		}
	}
	if (code != '9' && code != '110' && code != '8' && code != '46') {
		var percision = $(this).attr("DecimalPlaces");
		var baseValue = $(this).val().replace('-', '').split('.');
		if (baseValue[1] != undefined && baseValue[1].length <= percision) {
			$(this).data("oldDecimal", $(this).val());
		}
	}
	if ($(this).val().split('.').length == 3 && code != 9) {
		window.event.returnValue = false;
	}
});

//Decimal Place Validation
$("INPUT[DecimalPlaces]").live("keyup", function (e) {
	var code = e.keyCode || e.which;
	if (code != '9' && code != '8' && code != '46') {
		var percision = $(this).attr("DecimalPlaces");
		var baseValue = $(this).val().replace('-', '').split('.');
		if ((baseValue[1] != undefined && baseValue[1].length > percision) || baseValue.length > 2) {
			$(this).val($(this).data("oldDecimal"));
		}
	}
	if ($(this).val().split('.').length == 3 && code != 9) {
		if ($(this).val().endsWith('.')) {
			$(this).val($(this).val().toString().substring(0, $(this).val().length - 1))
		}
	}
});

//NumberLength validation.
$("INPUT[NumberLength]").live("blur", function (e) {
	var percision = $(this).attr("NumberLength");
	var baseValue = $(this).val().split('.');
	if (baseValue[0] != undefined && baseValue[0].length > percision) {
		$(this).val($(this).data("old"));
	}
});

//Decimal Place Validation! Leave Here!
$("INPUT[DecimalPlaces]").live("blur", function () {
	var percision = $(this).attr("DecimalPlaces");
	var rawValue = $.trim($(this).val());
	if (rawValue == "") return false;
	if (rawValue.endsWith("-")) {
		rawValue = "-" + rawValue.substr(0, rawValue.length - 1);
	}
	if (rawValue.endsWith(".")) {
		rawValue = rawValue.substr(0, rawValue.length - 1)
	}
	var baseValue = Number(rawValue);


	if ($(this).val().split('.')[1] != undefined) {
		var valueAfterPeriod = $(this).val().split('.')[1];
		if (valueAfterPeriod.length <= percision) {
			$(this).val(baseValue.toFixed(percision));
		} else {
			var areaToDelete = valueAfterPeriod.length - percision;
			$(this).val(Number($(this).val().toString().substring(0, $(this).val().length - areaToDelete)).toFixed(percision));
		}

	} else {
		$(this).val(baseValue.toFixed(percision));
	}

	if (jQuery.isFunction(jQuery.fn.validate)) {
		$('form').validate().element(this);
		$(this).validate();
	}
});

//NumberLength validation.
$("INPUT[NumberLength]").live("keydown", function (e) {
	var code = e.keyCode || e.which;
	if (code != '9' && code != '110' && code != '8' && code != '46') {
		var percision = $(this).attr("NumberLength");
		var baseValue = $(this).val().split('.');
		if (baseValue[0] != undefined && baseValue[0].length == percision) {
			$(this).data("old", $(this).val());
		}
	}
});

//NumberLength validation.
$("INPUT[NumberLength]").live("keyup", function (e) {
	var code = e.keyCode || e.which;
	if (code != '9' && code != '110' && code != '8' && code != '46') {
		var percision = $(this).attr("NumberLength");
		var baseValue = $(this).val().split('.');
		if (baseValue[0] != undefined && baseValue[0].length > percision) {
			$(this).val($(this).data("old"));
		}
	}
});

///////////////////
// Error validation methods
///////////////////

//Required field validation 
$(".Required").live("blur change result", function () {
	if ($("#ModuleName").val() != undefined && $("#ModuleName").val() != "TJE") {
		if ($(this).val() == "") {
			$(this).addClass("input-validation-error");
			//Error Message
			if ($($(this)).next().attr("id") != $($(this)).attr("id") + "-Image" && $("#" + $(this)[0].id + "-Image").length == 0) {
				if ($("#" + $(this).attr("id") + "-mag").length > 0) {
					//Add Image Validator
					$("#" + $(this).attr("id") + "-mag").after('<IMG id="' + $($(this)).attr("id") + '-Image" title="' + $(this).attr("ErrorMessage") + '" alt="Field Error" src="' + $("#StaticFileURL").val() + '/content/images/erroricon.png">');
					$("#" + $(this)[0].id + "-Image").show();
				} else {
					//Add Image Validator
					$($(this)).after('<IMG id="' + $($(this)).attr("id") + '-Image" title="' + $(this).attr("ErrorMessage") + '" alt="Field Error" src="' + $("#StaticFileURL").val() + '/content/images/erroricon.png">');
					$("#" + $(this)[0].id + "-Image").show();
				}
			}
		}
		else {
			$(this).removeClass("input-validation-error");
			$("#" + $(this).attr("id") + "-Image").remove();
		}
	}
});

//Used for Showing/Hiding the error icon.
jQuery.fn.contentChange = function (callback) {
	var elms = jQuery(this);
	elms.each(
    function (i) {
    	var elm = jQuery(this);
    	elm.data("lastContents", elm.html());
    	window.watchContentChange = window.watchContentChange ? window.watchContentChange : [];
    	window.watchContentChange.push({ "element": elm, "callback": callback });
    }
)
	return elms;
}

//Used for Showing/Hiding the error icon.
setInterval(function () {
	if (window.watchContentChange) {
		for (var i = 0; i <= window.watchContentChange.length - 1; i++) {
			if (window.watchContentChange[i].element.data("lastContents") != window.watchContentChange[i].element.html()) {
				window.watchContentChange[i].callback.apply(window.watchContentChange[i].element);
				window.watchContentChange[i].element.data("lastContents", window.watchContentChange[i].element.html())
			};
		}
	}
}, 100);

//Shows/Hides the error icon.
$('[data-valmsg-for]').contentChange(function () {
	if ($("#" + $(this).attr('data-valmsg-for')).hasClass("ImageValidation")) {
		if ($(this)[0].children.length == 0) {
			$("#" + $(this).attr('data-valmsg-for') + "-Image").hide();
		}
		else if ($(this)[0].children[0].innerHTML != "") {
			$("#" + $(this).attr('data-valmsg-for') + "-Image").show();
			$("#" + $(this).attr('data-valmsg-for') + "-Image").attr("title", $(this)[0].children[0].innerHTML);
		}
	}
});

//???????
String.prototype.endsWith = function (pattern) {
	var d = this.length - pattern.length;
	return d >= 0 && this.lastIndexOf(pattern) === d;
};

jQuery.fn.sortElements = (function () {
	var sort = [].sort;
	return function (comparator, getSortable) {
		getSortable = getSortable || function () { return this; };
		var placements = this.map(function () {
			var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
            // Since the element itself will change position, we have
            // to have some way of storing its original position in
            // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
			return function () {
				if (parentNode === this) { throw new Error("You can't sort elements if any one is a descendant of another."); }
				// Insert before flag:
				parentNode.insertBefore(this, nextSibling);
				// Remove flag:
				parentNode.removeChild(nextSibling);
			};
		});
		return sort.call(this, comparator).each(function (i) {
			placements[i].call(getSortable.call(this));
		});
	};
})();

////////////////////////////////
// Date Validation 
///////////////////////////////

//Formats date fields.
$(".Date").live("blur", function () {
	//Trims the Spaces
	var baseControl = $(this);
	baseControl.val(jQuery.trim(baseControl.val()));
	var isNumber = parseInt(baseControl.val());
	if (isNaN(isNumber)) {
		return false;
	}
	if (baseControl.val().indexOf('/') != -1) {
		DateModification(baseControl);
	} else {
		IntegerToDateConversion(baseControl);
	}
});

//If data annotation is activated on a field then on blur of it the dates will be formatted. 
$("input[data-val-date]").live('blur', function () {
	//Trims the Spaces
	var baseControl = $(this);
	baseControl.val(jQuery.trim(baseControl.val()));
	var isNumber = parseInt(baseControl.val());
	if (isNaN(isNumber)) {
		return false;
	}
	if (baseControl.val().indexOf('/') != -1) {
		DateModification(baseControl);
	} else {
		IntegerToDateConversion(baseControl);
	}
	$('form').validate().element('#' + baseControl[0].id);
	return true;
});

//Adds slashes to a string of digits
function AddSlashes(value) {
	return value.substring(0, 2) + '/' + value.substring(2, 4) + '/' + value.substring(4, 8)
}

//Eduardos Date Modification Code that Formats and Adjusts Raw inputs to valid date inputs
function IntegerToDateConversion(baseControl) {
	var currentDate = new Date();
	var currentValue = baseControl.val();
	currentValue = currentValue.replace("-", "/");
	currentValue = currentValue.replace("-", "/");

	if (currentValue.indexOf('/') > -1) {
		var array = currentValue.split('/');
		if (array.length < 2) {
			currentValue = "01/01/01";
		}
		else {

			if (array.length == 2) {
				array[2] = currentDate.getFullYear();
			}

			if (array[0].length == 1) {
				array[0] = "0" + array[0];
			}
			if (array[1].length == 1) {
				array[1] = "0" + array[1];
			}
			currentValue = array.join("/");
		}
	}

	currentValue = currentValue.replace("/", "");
	currentValue = currentValue.replace("/", "");

	switch (currentValue.length) {
		//Support dates entered as mmdd    
		case 4:
			baseControl.val(AddSlashes(currentValue + currentDate.getFullYear()));
			break;
			//Support dates entered as mmddyy    
		case 6:
			baseControl.val(AddSlashes(currentValue.substring(0, 4) + '20' + currentValue.charAt(4) + currentValue.charAt(5)));
			break;
			//Support dates entered as mmddyyyy    
		case 8:
			baseControl.val(AddSlashes(currentValue));
			break;
		default:
			break;
	}
}

//Eduardos Date Modification Code that Formats and Adjusts Raw inputs to valid date inputs
function DateModification(baseControl) {
	var currentValue = baseControl.val();
	currentValue = currentValue.replace("-", "/");
	currentValue = currentValue.replace("-", "/");
	var currentDate = new Date();
	switch (baseControl.val().length) {
		// Support dates entered in format m/d.    
		case 3:
			baseControl.val('0' + currentValue.charAt(0) + currentValue.charAt(1) + '0' + currentValue.charAt(2) + '/' + currentDate.getFullYear());
			break;
			//  Support dates entered in format mm/d or m/dd    
		case 4:
			if (currentValue.charAt(1) == "/") {
				baseControl.val('0' + currentValue + '/' + currentDate.getFullYear());
			} else {
				baseControl.val(currentValue.substring(0, 3) + '0' + currentValue.charAt(3) + '/' + currentDate.getFullYear());
			}
			break;
			//  Support dates entered in format mm/dd.   
		case 5:
			baseControl.val(currentValue + '/' + currentDate.getFullYear());
			break;
			//  Support dates entered in format m/dd/yy & mm/d/yy.   
		case 6:
			if (currentValue.charAt(1) == "/") {
				baseControl.val('0' + currentValue.substring(0, 4) + '20' + currentValue.charAt(4) + currentValue.charAt(5));
			} else {
				baseControl.val(currentValue.substring(0, 3) + '0' + currentValue.charAt(3) + '/20' + currentValue.charAt(5) + currentValue.charAt(6));
			}
			break;
		case 7:
			if (currentValue.charAt(1) == "/") {
				baseControl.val('0' + currentValue.substring(0, 5) + '20' + currentValue.charAt(5) + currentValue.charAt(6));
			} else {
				baseControl.val(currentValue.substring(0, 3) + '0' + currentValue.charAt(3) + '/20' + currentValue.charAt(5) + currentValue.charAt(6));
			}
			break;
		case 8:
			if (currentValue.charAt(1) == "/") {
				baseControl.val('0' + currentValue.charAt(0) + currentValue.charAt(1) + '0' + currentValue.substring(2, 8));
			} else {
				baseControl.val(currentValue.substring(0, 5) + '/20' + currentValue.charAt(6) + currentValue.charAt(7));
			}

			break;
		case 9:
			if (currentValue.charAt(1) == "/") {
				baseControl.val('0' + currentValue.charAt(0) + currentValue.substring(1));
			} else {
				baseControl.val(currentValue.substring(0, 3) + '0' + currentValue.charAt(3) + "/" + currentValue.substring(5));
			}

			break;
		default:
			break;

	}
}


$("textarea[maxlength]").keydown(function (e) {
	var key = e.which;  // backspace = 8, delete = 46, arrows = 37,38,39,40 
	if (key == 9) { return true; }
	if ((key >= 37 && key <= 40) || key == 8 || key == 46) return;
	if ($(this).val().length < $(this).attr("maxlength")) {
		return true;
	} else {
		return false;
	}
});


/////////////////////
//Language stuff
/////////////////////
function GetLanguageFromBrowser() {
	var url = $("#ApplicationURL").val() + "/Common/GetLanguageFromBrowser";
	var language = "en-us"

	$.ajaxSetup({ async: false });
	$.post(url, null, function (data) {
		language = data;
	});
	$.ajaxSetup({ async: true });

	return language;
}

////////////////////////////////
//Read cookies
///////////////////////////////
function getCookie(name) {
	var re = new RegExp(name + "=([^;]+)");
	var value = re.exec(document.cookie);
	return (value != null) ? unescape(value[1]) : null;
}

/////////////////////
// Base 64 encoding methods. 
/////////////////////

function base64_decode(data) {
	// http://kevin.vanzonneveld.net
	// +   original by: Tyler Akins (http://rumkin.com)
	// +   improved by: Thunder.m
	// +      input by: Aman Gupta
	// +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// +   bugfixed by: Onno Marsman
	// +   bugfixed by: Pellentesque Malesuada
	// +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// +      input by: Brett Zamir (http://brett-zamir.me)
	// +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// *     example 1: base64_decode('S2V2aW4gdmFuIFpvbm5ldmVsZA==');
	// *     returns 1: 'Kevin van Zonneveld'
	// mozilla has this native
	// - but breaks in 2.0.0.12!
	//if (typeof this.window['atob'] === 'function') {
	//    return atob(data);
	//}
	var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	var o1, o2, o3, h1, h2, h3, h4, bits, i = 0,
    ac = 0,
    dec = "",
    tmp_arr = [];

	if (!data) {
		return data;
	}

	data += '';

	do { // unpack four hexets into three octets using index points in b64
		h1 = b64.indexOf(data.charAt(i++));
		h2 = b64.indexOf(data.charAt(i++));
		h3 = b64.indexOf(data.charAt(i++));
		h4 = b64.indexOf(data.charAt(i++));

		bits = h1 << 18 | h2 << 12 | h3 << 6 | h4;

		o1 = bits >> 16 & 0xff;
		o2 = bits >> 8 & 0xff;
		o3 = bits & 0xff;

		if (h3 == 64) {
			tmp_arr[ac++] = String.fromCharCode(o1);
		} else if (h4 == 64) {
			tmp_arr[ac++] = String.fromCharCode(o1, o2);
		} else {
			tmp_arr[ac++] = String.fromCharCode(o1, o2, o3);
		}
	} while (i < data.length);

	dec = tmp_arr.join('');

	return dec;
}


function base64_encode(data) {
	// http://kevin.vanzonneveld.net
	// +   original by: Tyler Akins (http://rumkin.com)
	// +   improved by: Bayron Guevara
	// +   improved by: Thunder.m
	// +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// +   bugfixed by: Pellentesque Malesuada
	// +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// +   improved by: Rafał Kukawski (http://kukawski.pl)
	// *     example 1: base64_encode('Kevin van Zonneveld');
	// *     returns 1: 'S2V2aW4gdmFuIFpvbm5ldmVsZA=='
	// mozilla has this native
	// - but breaks in 2.0.0.12!
	//if (typeof this.window['btoa'] == 'function') {
	//    return btoa(data);
	//}
	var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	var o1, o2, o3, h1, h2, h3, h4, bits, i = 0,
    ac = 0,
    enc = "",
    tmp_arr = [];

	if (!data) {
		return data;
	}

	do { // pack three octets into four hexets
		o1 = data.charCodeAt(i++);
		o2 = data.charCodeAt(i++);
		o3 = data.charCodeAt(i++);

		bits = o1 << 16 | o2 << 8 | o3;

		h1 = bits >> 18 & 0x3f;
		h2 = bits >> 12 & 0x3f;
		h3 = bits >> 6 & 0x3f;
		h4 = bits & 0x3f;

		// use hexets to index into b64, and append result to encoded string
		tmp_arr[ac++] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
	} while (i < data.length);

	enc = tmp_arr.join('');

	var r = data.length % 3;

	return (r ? enc.slice(0, r - 3) : enc) + '==='.slice(r || 3);

}

/**
*  Base64 encode / decode
*  http://www.webtoolkit.info/
**/

var Base64 = {
	// private property
	_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

	// public method for encoding
	encode: function (input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		input = Base64._utf8_encode(input);

		while (i < input.length) {
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);

			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;

			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}

			output = output +
      this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
      this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
		}

		return output;
	},

	// public method for decoding
	decode: function (input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;

		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

		while (i < input.length) {
			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));

			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;

			output = output + String.fromCharCode(chr1);

			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}
		}

		output = Base64._utf8_decode(output);

		return output;
	},

	// private method for UTF-8 encoding
	_utf8_encode: function (string) {
		string = string.replace(/\r\n/g, "\n");
		var utftext = "";

		for (var n = 0; n < string.length; n++) {
			var c = string.charCodeAt(n);

			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if ((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
		}

		return utftext;
	},

	// private method for UTF-8 decoding
	_utf8_decode: function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;

		while (i < utftext.length) {
			c = utftext.charCodeAt(i);

			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			}
			else if ((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i + 1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i + 1);
				c3 = utftext.charCodeAt(i + 2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
		}

		return string;
	}
}
