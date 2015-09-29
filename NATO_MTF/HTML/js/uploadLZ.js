var root = "../HTML/";
var schemaroot = "IEPD/";

var filemods =[];
$(document).ready(function () {
    $(function () {
        $('#zipbtn').click(function () {
            $("#progress").empty();
            compressFiles(0);
        });
         $('#schemazipbtn').click(function () {
            $("#progress").empty();
            compressSchemas(0);
        });
    });
});

function compressFiles(count) {
    if (count != xslresources.length) {
        var next = count + 1;
        var p = root + xslresources[count];
        var t = root + compressedxslresources[count];
        compressData(p, t, function () {
            compressFiles(next);
        });
    } else {
        $("#progress").append("<div>UPLOAD COMPLETE</div>");
    }
}

function compressSchemas(count) {

    if (count != schemaresources.length) {
        var next = count + 1;
        var p = schemaroot + schemaresources[count];
        var t = schemaroot + schemaresources[count]+'.lz';
        compressData(p, t, function () {
            compressSchemas(next);
        });
    } else {
        $("#progress").append("<div>UPLOAD COMPLETE</div>");
    }
}


function compressData(rpath, tpath, callback) {
    var filename = rpath.substring(rpath.lastIndexOf('/') + 1);
    console.log('compressData: ' + filename);
    $.ajax({
        type: "GET",
        url: rpath,
        cache: false,
        dataType: "text",
        success: function (strdata) {
            $("#progress").append("<div>Compressing:  " + filename + " . . . </div>");
            var compressed = LZString.compressToUTF16(strdata);
            //console.log(compressed);
            $.ajax({
                type: "PUT",
                url: tpath,
                data: compressed,
                dataType: "text",
                success: function () {
                    console.log("Stored compressed: " + filename+'.lz');
                    $("#progress").append("<div>Uploaded:  " + filename + "</div>");
                    callback();
                },
                fail: function () {
                    console.log("Could not store compressed: file: " + tpath);
                }
            });
        },
        fail: function () {
            $("#progress").append("<div>" + filename + "Not Modified</div>");
            console.log("Could not retrieve file: " + rpath);
            callback();
        }
    });
}