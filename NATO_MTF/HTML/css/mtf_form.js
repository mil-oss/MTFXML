/*
 * Copyright (C) 2015 JD NEUSHUL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

$(function () {
    $('textarea').keyup(function () {
        this.value = this.value.toUpperCase();
        /*force all caps*/
        var u = this.value.replace(/_/g, " ");
        /*replace multiple spaces with underscore to deal with wrapping issues.*/
        this.value = u.replace(/\s+/g, ' ');
        /*with underscore to deal with wrapping issues. Need to remove on save*/
        var fielddiv = $($(this).parents("div.frm")[0]);
        showRegexMismatch(this, fielddiv);
    });
    $('textarea').blur(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").hide();
    });
    $('textarea').focus(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").show();
        showRegexMismatch(this, fielddiv);
    });
    $('input').focus(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").show();
    });
    $('input').blur(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").hide();
    });
    $('select').click(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").show();
        setSelectedValue(this);
    });
    $('select').blur(function () {
        var fielddiv = $($(this).parents("div.frm")[0]);
        fielddiv.find("div.frmdesc").hide();
    });
});

function showRegexMismatch(txtarea, fielddiv) {
    if ($(txtarea).attr("class") !== "freetext") {
        linelen = 30;
        if ($.isNumeric(txtarea.value) && fielddiv.find("span.minval").length > 0) {
            checkValues(txtarea, fielddiv);
        } else {
            var txt = txtarea.value.replace(/_/g, " ");
            //Ignore underscores..
            var rowno = Math.floor(txtarea.value.length / 30) + 1;
            var rgx = $(fielddiv.find("input[pattern]")[0]).attr("pattern");
            var regentryline = fielddiv.find(".regentryline");
            for (e = 0; e < rowno; e++) {
                $(regentryline[e]).empty();
            }
            $(txtarea).css('border', 'none');
            //check whole str for case of required length
            var patt = txtarea.value.match(rgx);
            if (patt !== null && patt[0].length === txtarea.value.length) {
                $(txtarea).css('border', 'none');
            } else {
                for (i = 0; i < txtarea.value.length; i++) {
                    var sub = txtarea.value.substring(i, i + 1);
                    if (sub.search(rgx) === -1) {
                        if (i < linelen) {
                            $(regentryline[0]).append("<span class='badchar'>_</span>");
                        } else if (i < linelen * 2) {
                            $(regentryline[1]).append("<span class='badchar'>_</span>");
                        } else {
                            $(regentryline[2]).append("<span class='badchar'>_</span>");
                        }
                        $(txtarea).css('border', 'thin solid red');
                    } else {
                        if (i < linelen) {
                            $(regentryline[0]).append("<span class='okchar'>_</span>");
                        } else if (i < linelen * 2) {
                            $(regentryline[1]).append("<span class='okchar'>_</span>");
                        } else {
                            $(regentryline[2]).append("<span class='okchar'>_</span>");
                        }
                    }
                }
            }
        }
    }
}

function checkValues(txtfld, fielddiv) {
    var regentryline = fielddiv.find(".regentryline")[0];
    var defdiv = $($(txtfld).parents("div.field")[0]);
    var minv = parseFloat($(fielddiv.find("span.minval")[0]).text(), 10);
    var maxv = parseFloat($(fielddiv.find("span.maxval")[0]).text(), 10);
    var val = parseFloat(txtfld.value, 10);
    if (val >= minv && val <= maxv) {
        $(regentryline).empty();
        $(txtfld).css('border', 'none');
    } else if (val < minv || val > maxv) {
        $(regentryline).empty();
        for (i = 0; i < txtfld.value.length; i++) {
            $(regentryline).append("<span class='badchar'>_</span>");
        }
        $(txtfld).css('border', 'thin solid red');
    }
}

function setSelectedValue(enumsel) {
    var fdiv = $($(enumsel).parents("div.frm")[0]);
    var inpt = fdiv.find("input");
    var showtxt = fdiv.find(".selecttxt");
    var txt = $($(enumsel).children("option:selected")).text();
    inpt.val(enumsel.value);
    showtxt.text(txt.substring(enumsel.value.length + 1));
}