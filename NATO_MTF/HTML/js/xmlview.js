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
function f(e) {
    if (e.className === "ci") {
        if (e.children[0].innerHTML.indexOf("\n") > 0) fix(e, "cb");
    }
    if (e.className === "di") {
        if (e.children[0].innerHTML.indexOf("\n") > 0) fix(e, "db");
    }
    e.id = "";
}
function fix(e, cl) {
    e.className = cl;
    e.style.display = "block";
    j = e.parentElement.children[0];
    j.className = "c";
    k = j.children[0];
    k.style.visibility = "visible";
    k.href = "#";
}
function ch(e) {
    mark = e.children[0].children[0];
    if (mark.innerHTML === "+") {
        mark.innerHTML = "-";
        for (var i = 1; i < e.children.length; i++) {
            e.children[i].style.display = "block";
        }
    } else if (mark.innerHTML === "-") {
        mark.innerHTML = "+";
        for (var i = 1; i < e.children.length; i++) {
            e.children[i].style.display = "none";
        }
    }
}
function ch2(e) {
    mark = e.children[0].children[0];
    contents = e.children[1];
    if (mark.innerHTML === "+") {
        mark.innerHTML = "-";
        if (contents.className === "db" || contents.className === "cb") {
            contents.style.display = "block";
        } else {
            contents.style.display = "inline";
        }
    } else if (mark.innerHTML === "-") {
        mark.innerHTML = "+";
        contents.style.display = "none";
    }
}
function cl(event) {
    e = event.target;
    if (e.className !== "c") {
        e = e.parentElement;
        if (e.className !== "c") {
            return;
        }
    }
    e = e.parentElement;
    if (e.className === "e") {
        ch(e);
    }
    if (e.className === "k") {
        ch2(e);
    }
}
function ex() {
}
function h() {
    window.status = " ";
}
document.onclick = cl;