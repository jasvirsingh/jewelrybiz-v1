$(document).ready(function () {
    FillCategories();
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

function addStrands(value) {
    $("#strands").html('');
    var text = $("#MotherBraceletMaterial_StrandMaterialId option:selected").text()
    if (text == "One Strand") {
        $("#strands").append("Name1: <input type='text' id='Strand1' name ='Strand1'/>");
    }
    else if (text == "Two Strand") {
        $("#strands").append("Name 1:  <input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2: <input type='text' id='Strand2' name ='Strand2'/>");
    }
    else if (text == "Three Strand") {
        $("#strands").append("Name1:<input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2:<input type='text' id='Strand2' name ='Strand2'/><br/><br/>Name3:<input type='text' id='Strand3' name ='Strand3'/>");
    }
    else if (text == "Four Strand") {
        $("#strands").append("Name1:<input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2:<input type='text' id='Strand2' name ='Strand2'/><br/><br/>Name3:<input type='text' id='Strand3' name ='Strand3'/>&nbsp;&nbsp;Name4:<input type='text' id='Strand4' name ='Strand4'/>");
    }
}