$(document).ready(function () {
    $("#strands").append("Name1: <input type='text' id='Strand1' name ='Strand1'/>");
});

function addStrands(value) {
    $("#strands").html('');
    var text = $("#MotherBraceletMaterial_StrandMaterialId option:selected").text()
    if (text == "One Strand") {
        $("#strands").append("Name1: <input type='text' id='Strand1' name ='Strand1'/>");
        $("#NoOfStrandsSelected").val(1);
    }
    else if (text == "Two Strand") {
        $("#strands").append("Name 1:  <input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2: <input type='text' id='Strand2' name ='Strand2'/>");
        $("#NoOfStrandsSelected").val(2);
    }
    else if (text == "Three Strand") {
        $("#strands").append("Name1:<input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2:<input type='text' id='Strand2' name ='Strand2'/><br/><br/>Name3:<input type='text' id='Strand3' name ='Strand3'/>");
        $("#NoOfStrandsSelected").val(3);
    }
    else if (text == "Four Strand") {
        $("#strands").append("Name1:<input type='text' id='Strand1' name ='Strand1'/>&nbsp;&nbsp;Name2:<input type='text' id='Strand2' name ='Strand2'/><br/><br/>Name3:<input type='text' id='Strand3' name ='Strand3'/>&nbsp;&nbsp;Name4:<input type='text' id='Strand4' name ='Strand4'/>");
        $("#NoOfStrandsSelected").val(4);
    }
}

$("#addtocart").click(function () {
    var val = $("#NoOfStrandsSelected").val();
    var isValid = true;
    if (val == '1') {
        var text1 = $("#Strand1").val();
        if (text1 == '') {
            alert('Name 1 is required.');
            isValid = false;
        }
    }
    else if (val == '2') {
        var text1 = $("#Strand1").val();
        if (text1 == '') {
            alert('Name 1 is required.');
            isValid = false;
        }
        var text2 = $("#Strand2").val();
        if (text2 == '') {
            alert('Name 2 is required.');
            isValid = false;
        }
    }
    else if (val == '3') {
        var text1 = $("#Strand1").val();
        if (text1 == '') {
            alert('Name 1 is required.');
            isValid = false;
        }
        var text2 = $("#Strand2").val();
        if (text2 == '') {
            alert('Name 2 is required.');
            isValid = false;
        }
        var text3 = $("#Strand3").val();
        if (text3 == '') {
            alert('Name 3 is required.');
            isValid = false;
        }
    }
    else if (val == '4') {
        var text1 = $("#Strand1").val();
        if (text1 == '') {
            alert('Name 1 is required.');
            isValid = false;
        }
        var text2 = $("#Strand2").val();
        if (text2 == '') {
            alert('Name 2 is required.');
            isValid = false;
        }
        var text3 = $("#Strand3").val();
        if (text3 == '') {
            alert('Name 3 is required.');
            isValid = false;
        }
        var text4 = $("#Strand4").val();
        if (text4 == '') {
            alert('Name 4 is required.');
            isValid = false;
        }
    }
    return isValid;
});