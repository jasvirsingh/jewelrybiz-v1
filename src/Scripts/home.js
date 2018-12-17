$(document).ready(function () {
   
});

function FillCategories() {
    $.ajax({
        type: "GET",
        url: "/Home/GetCategories",
        dataType: "json",
        contentType: "application/json",
        success: function (res) {
            $.each(res, function (data, value) {
                $("#pCategory").append($("<option></option>").val(value.Value).html(value.Text));
            })
        }

    });
}

$("#categories").change(function () {
    alert($('option:selected', this).text());
    var val = $('#categories option:selected').val();
    alert(val);
    if (val == '1') {
        $("#mother").show();
    }
});

function getdetails(sel) {
    var value = sel.value;
    if (value == '1') {
        $("#mother").show();
    }
}

