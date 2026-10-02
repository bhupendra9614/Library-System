<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Edit Book | Library</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f6f3ee;
    color: #1f2937;
    min-height: 100vh;
}

/* HEADER */
.header {
    background: #fff;
    border-bottom: 1px solid #e7e2d9;
    padding: 0 6%;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.header .brand { font-weight: 700; font-size: 18px; color: #1f2937; text-decoration: none; }
.crumbs { font-size: 13px; color: #8a8478; }
.crumbs a { color: #0d9488; text-decoration: none; }
.crumbs a:hover { text-decoration: underline; }
.crumbs span { margin: 0 6px; }

/* LAYOUT */
.wrap {
    max-width: 1100px;
    margin: 34px auto 60px;
    padding: 0 5%;
}

.title-row { margin-bottom: 24px; }
.title-row h1 { font-size: 28px; }
.title-row p { color: #6b7280; font-size: 14px; margin-top: 5px; }

.layout { display: grid; grid-template-columns: 1.6fr 1fr; gap: 24px; align-items: start; }

.card {
    background: #fff;
    border: 1px solid #e7e2d9;
    border-radius: 16px;
    padding: 28px;
}
.card h2 { font-size: 16px; margin-bottom: 18px; display: flex; align-items: center; gap: 8px; }

/* FORM */
.row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.field { margin-bottom: 18px; }
.field label {
    display: flex; justify-content: space-between;
    font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 7px;
}
.field label small { font-weight: 400; color: #9ca3af; }

.field input[type=text],
.field input[type=number] {
    width: 100%;
    padding: 13px 14px;
    border: 1.5px solid #ddd8cd;
    border-radius: 10px;
    font-size: 15px;
    background: #fdfcfa;
    outline: none;
    transition: 0.2s;
}
.field input:focus {
    border-color: #0d9488;
    background: #fff;
    box-shadow: 0 0 0 4px rgba(13,148,136,0.12);
}
.field input.changed { border-color: #f59e0b; background: #fffbeb; }

.price-wrap { position: relative; }
.price-wrap span {
    position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
    color: #6b7280; font-weight: 600;
}
.price-wrap input { padding-left: 34px !important; }

/* TOGGLE */
.toggle-row {
    display: flex; justify-content: space-between; align-items: center;
    background: #f7f5f0; border-radius: 12px; padding: 14px 16px; margin-bottom: 8px;
}
.toggle-row b { display: block; font-size: 14px; }
.toggle-row span { font-size: 12px; color: #6b7280; }

.switch { position: relative; width: 52px; height: 28px; flex-shrink: 0; }
.switch input { opacity: 0; width: 0; height: 0; }
.slider {
    position: absolute; inset: 0; background: #d1d5db; border-radius: 28px;
    cursor: pointer; transition: 0.25s;
}
.slider::before {
    content: ""; position: absolute; width: 22px; height: 22px; left: 3px; top: 3px;
    background: #fff; border-radius: 50%; transition: 0.25s; box-shadow: 0 2px 5px rgba(0,0,0,0.2);
}
.switch input:checked + .slider { background: #0d9488; }
.switch input:checked + .slider::before { transform: translateX(24px); }

/* BUTTONS */
.btn-row {
    display: flex; gap: 10px; flex-wrap: wrap;
    margin-top: 22px; padding-top: 22px; border-top: 1px solid #efebe3;
}
.btn {
    padding: 13px 24px; border-radius: 10px; font-size: 14px; font-weight: 600;
    cursor: pointer; border: none; text-decoration: none; display: inline-block; transition: 0.2s;
}
.btn-save { background: #0d9488; color: #fff; flex: 1; min-width: 160px; }
.btn-save:hover:not(:disabled) { background: #0f766e; transform: translateY(-2px); box-shadow: 0 8px 18px rgba(13,148,136,0.28); }
.btn-save:disabled { background: #cbd5d1; cursor: not-allowed; }
.btn-reset { background: #fff; color: #374151; border: 1.5px solid #ddd8cd; }
.btn-reset:hover { background: #f7f5f0; }
.btn-cancel { background: transparent; color: #6b7280; }
.btn-cancel:hover { color: #1f2937; }

.dirty-note { font-size: 12px; color: #b45309; margin-top: 10px; display: none; }
.dirty-note.show { display: block; }

/* SIDE */
.side { display: flex; flex-direction: column; gap: 20px; position: sticky; top: 20px; }

.preview {
    border-radius: 14px; padding: 20px; color: #fff;
    background: linear-gradient(135deg, #0f766e, #134e4a);
}
.preview .p-cat {
    display: inline-block; font-size: 11px; font-weight: 700; letter-spacing: 0.6px;
    text-transform: uppercase; background: rgba(255,255,255,0.18); padding: 4px 10px; border-radius: 6px;
}
.preview h3 { font-size: 20px; margin: 14px 0 4px; word-break: break-word; }
.preview .p-author { font-size: 14px; color: #99f6e4; margin-bottom: 16px; word-break: break-word; }
.preview .p-bottom { display: flex; justify-content: space-between; align-items: center; font-size: 13px; }
.preview .p-price { font-size: 20px; font-weight: 700; }
.p-status { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
.p-status.yes { background: #bbf7d0; color: #166534; }
.p-status.no { background: #fecaca; color: #991b1b; }
.preview-label { font-size: 12px; color: #8a8478; margin-bottom: 8px; font-weight: 600; letter-spacing: 0.5px; }

.info dl { display: grid; grid-template-columns: auto 1fr; gap: 10px 14px; font-size: 13px; }
.info dt { color: #8a8478; }
.info dd { text-align: right; font-weight: 600; }

.danger { border-color: #fecaca; background: #fffafa; }
.danger h2 { color: #b91c1c; }
.danger p { font-size: 13px; color: #6b7280; margin-bottom: 14px; line-height: 1.6; }
.btn-del { background: #fff; color: #dc2626; border: 1.5px solid #fca5a5; width: 100%; }
.btn-del:hover { background: #dc2626; color: #fff; }

/* MODAL */
.overlay {
    position: fixed; inset: 0; background: rgba(17,24,39,0.55);
    display: none; align-items: center; justify-content: center; z-index: 50;
}
.overlay.show { display: flex; }
.modal { background: #fff; width: 390px; max-width: 92%; border-radius: 16px; padding: 28px; text-align: center; }
.modal .w { font-size: 42px; margin-bottom: 8px; }
.modal h3 { margin-bottom: 8px; }
.modal p { color: #6b7280; font-size: 14px; line-height: 1.6; margin-bottom: 20px; }
.modal .btns { display: flex; gap: 10px; }
.modal .btns button { flex: 1; padding: 12px; border: none; border-radius: 9px; font-weight: 600; cursor: pointer; font-size: 14px; }
.m-no { background: #f3f4f6; color: #374151; }
.m-yes { background: #dc2626; color: #fff; }

@media (max-width: 860px) {
    .layout { grid-template-columns: 1fr; }
    .side { position: static; }
    .row2 { grid-template-columns: 1fr; }
    .crumbs { display: none; }
}
</style>
</head>

<body>

<header class="header">
    <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
    <div class="crumbs">
        <a href="${pageContext.request.contextPath}/">Home</a><span>/</span>
        <a href="${pageContext.request.contextPath}/books/manage">Manage Books</a><span>/</span>
        Edit Book
    </div>
</header>

<div class="wrap">

    <div class="title-row">
        <h1>&#9998;&#65039; Edit Book</h1>
        <p>Update the details below. Changed fields are highlighted in yellow.</p>
    </div>

    <div class="layout">

        <!-- LEFT: FORM -->
        <div class="card">
            <h2>Book Details</h2>

            <c:if test="${not empty errorMessages}">
                <div style="background:#fee2e2;color:#991b1b;padding:12px 16px;border-radius:10px;margin-bottom:18px;font-size:14px;line-height:1.7;">
                    <c:forEach var="msg" items="${errorMessages}">
                        &bull; <c:out value="${msg}"/><br>
                    </c:forEach>
                </div>
            </c:if>

            <form id="editForm"
                  action="${pageContext.request.contextPath}/books/update/${book.id}"
                  method="post">

                <div class="field">
                    <label for="title">Book Title <small id="titleCount">0 / 150</small></label>
                    <input type="text" id="title" name="title" maxlength="150" required
                           value="<c:out value='${book.title}'/>">
                </div>

                <div class="field">
                    <label for="author">Author <small id="authorCount">0 / 100</small></label>
                    <input type="text" id="author" name="author" maxlength="100" required
                           value="<c:out value='${book.author}'/>">
                </div>

                <div class="row2">
                    <div class="field">
                        <label for="isbn">ISBN <small>must be unique</small></label>
                        <input type="text" id="isbn" name="isbn" maxlength="20" required
                               value="<c:out value='${book.isbn}'/>">
                    </div>

                    <div class="field">
                        <label for="category">Category</label>
                        <input type="text" id="category" name="category" maxlength="50" required
                               list="categoryList"
                               value="<c:out value='${book.category}'/>">
                        <datalist id="categoryList">
                            <option value="Programming">
                            <option value="Fiction">
                            <option value="Science">
                            <option value="History">
                            <option value="Biography">
                            <option value="Self Help">
                            <option value="Education">
                            <option value="Novel">
                        </datalist>
                    </div>
                </div>

                <div class="field">
                    <label for="price">Price</label>
                    <div class="price-wrap">
                        <span>&#8377;</span>
                        <input type="number" id="price" name="price" step="0.01" min="0" required
                               value="<c:out value='${book.price}'/>">
                    </div>
                </div>

                <!-- AVAILABILITY TOGGLE -->
                <div class="toggle-row">
                    <div>
                        <b>Availability</b>
                        <span id="toggleText">Book is available for members</span>
                    </div>
                    <label class="switch">
                        <input type="checkbox" id="availableToggle" ${book.available ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>
                <input type="hidden" name="available" id="availableInput" value="${book.available}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="btn-row">
                    <button type="submit" class="btn btn-save" id="saveBtn" disabled>&#10003; Save Changes</button>
                    <button type="button" class="btn btn-reset" id="resetBtn">&#8634; Reset</button>
                    <a class="btn btn-cancel" href="${pageContext.request.contextPath}/books/manage">Cancel</a>
                </div>
                <div class="dirty-note" id="dirtyNote">&#9888;&#65039; You have unsaved changes.</div>
            </form>
        </div>

        <!-- RIGHT: SIDE -->
        <div class="side">

            <div>
                <div class="preview-label">LIVE PREVIEW</div>
                <div class="preview">
                    <span class="p-cat" id="pvCat"></span>
                    <h3 id="pvTitle"></h3>
                    <div class="p-author" id="pvAuthor"></div>
                    <div class="p-bottom">
                        <span class="p-price" id="pvPrice"></span>
                        <span class="p-status" id="pvStatus"></span>
                    </div>
                </div>
            </div>

            <div class="card info">
                <h2>Record Info</h2>
                <dl>
                    <dt>Book ID</dt><dd>#<c:out value="${book.id}"/></dd>
                    <dt>Created</dt><dd class="dt" data-iso="${book.createdAt}">-</dd>
                    <dt>Last updated</dt><dd class="dt" data-iso="${book.updatedAt}">-</dd>
                </dl>
            </div>

            <div class="card danger">
                <h2>&#9888;&#65039; Danger Zone</h2>
                <p>Deleting this book removes it permanently from the library records.</p>
                <button type="button" class="btn btn-del" id="openDelete">Delete This Book</button>
            </div>

        </div>
    </div>
</div>

<!-- DELETE MODAL -->
<div class="overlay" id="deleteModal">
    <div class="modal">
        <div class="w">&#128465;&#65039;</div>
        <h3>Delete this book?</h3>
        <p>"<b><c:out value="${book.title}"/></b>" will be permanently deleted. This cannot be undone.</p>
        <form action="${pageContext.request.contextPath}/books/delete/${book.id}" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="btns">
                <button type="button" class="m-no" id="closeDelete">Cancel</button>
                <button type="submit" class="m-yes">Yes, Delete</button>
            </div>
        </form>
    </div>
</div>

<script>
var fields = ["title", "author", "isbn", "category", "price"];
var el = {};
fields.forEach(function (f) { el[f] = document.getElementById(f); });

var toggle = document.getElementById("availableToggle");
var hidden = document.getElementById("availableInput");
var saveBtn = document.getElementById("saveBtn");
var dirtyNote = document.getElementById("dirtyNote");
var submitting = false;

/* original values */
var original = {};
fields.forEach(function (f) { original[f] = el[f].value; });
original.available = toggle.checked;

/* live preview + counters */
function refresh() {
    document.getElementById("pvTitle").textContent = el.title.value || "Untitled";
    document.getElementById("pvAuthor").textContent = "by " + (el.author.value || "-");
    document.getElementById("pvCat").textContent = el.category.value || "Category";
    document.getElementById("pvPrice").textContent = "\u20B9 " + (el.price.value || "0");

    var st = document.getElementById("pvStatus");
    st.textContent = toggle.checked ? "Available" : "Not Available";
    st.className = "p-status " + (toggle.checked ? "yes" : "no");

    document.getElementById("toggleText").textContent =
        toggle.checked ? "Book is available for members" : "Book is currently not available";
    hidden.value = toggle.checked ? "true" : "false";

    document.getElementById("titleCount").textContent = el.title.value.length + " / 150";
    document.getElementById("authorCount").textContent = el.author.value.length + " / 100";

    /* dirty check */
    var dirty = false;
    fields.forEach(function (f) {
        var changed = el[f].value !== original[f];
        el[f].classList.toggle("changed", changed);
        if (changed) dirty = true;
    });
    if (toggle.checked !== original.available) dirty = true;

    saveBtn.disabled = !dirty;
    dirtyNote.classList.toggle("show", dirty);
    return dirty;
}

fields.forEach(function (f) { el[f].addEventListener("input", refresh); });
toggle.addEventListener("change", refresh);

/* reset */
document.getElementById("resetBtn").addEventListener("click", function () {
    fields.forEach(function (f) { el[f].value = original[f]; });
    toggle.checked = original.available;
    refresh();
});

/* warn before leaving with unsaved changes */
document.getElementById("editForm").addEventListener("submit", function () { submitting = true; });
window.addEventListener("beforeunload", function (e) {
    if (!submitting && refresh()) {
        e.preventDefault();
        e.returnValue = "";
    }
});

/* delete modal */
var modal = document.getElementById("deleteModal");
document.getElementById("openDelete").addEventListener("click", function () {
    submitting = true;
    modal.classList.add("show");
});
document.getElementById("closeDelete").addEventListener("click", function () {
    submitting = false;
    modal.classList.remove("show");
});

/* readable dates */
document.querySelectorAll(".dt").forEach(function (node) {
    var iso = node.getAttribute("data-iso");
    if (!iso) return;
    var d = new Date(iso);
    if (!isNaN(d.getTime())) {
        node.textContent = d.toLocaleString("en-IN", {
            day: "2-digit", month: "short", year: "numeric",
            hour: "2-digit", minute: "2-digit"
        });
    } else {
        node.textContent = iso;
    }
});

refresh();
</script>

</body>
</html>
