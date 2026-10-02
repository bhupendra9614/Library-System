<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Manage Books | Admin Panel</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f4f6fb;
    color: #1e293b;
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    width: 240px;
    background: #111827;
    color: #cbd5e1;
    padding: 24px 16px;
    position: fixed;
    top: 0; bottom: 0; left: 0;
    display: flex;
    flex-direction: column;
}
.sidebar .brand {
    color: #fff; font-size: 18px; font-weight: 700;
    display: flex; align-items: center; gap: 10px;
    padding: 0 10px 24px; border-bottom: 1px solid #1f2937; margin-bottom: 18px;
}
.sidebar .label { font-size: 11px; letter-spacing: 1px; color: #6b7280; padding: 0 10px; margin-bottom: 8px; }
.sidebar a {
    display: flex; align-items: center; gap: 12px;
    color: #cbd5e1; text-decoration: none; font-size: 14px;
    padding: 11px 12px; border-radius: 9px; margin-bottom: 4px; transition: 0.2s;
}
.sidebar a:hover { background: #1f2937; color: #fff; }
.sidebar a.active { background: #4f46e5; color: #fff; }
.sidebar .foot { margin-top: auto; font-size: 12px; color: #6b7280; padding: 0 10px; }

/* MAIN */
.main { margin-left: 240px; flex: 1; padding: 30px 34px 50px; min-width: 0; }

.page-head {
    display: flex; justify-content: space-between; align-items: center;
    flex-wrap: wrap; gap: 14px; margin-bottom: 26px;
}
.page-head h1 { font-size: 26px; }
.page-head p { color: #64748b; font-size: 14px; margin-top: 4px; }

.btn {
    display: inline-flex; align-items: center; gap: 8px;
    text-decoration: none; border: none; cursor: pointer;
    padding: 11px 20px; border-radius: 9px; font-size: 14px; font-weight: 600; transition: 0.2s;
}
.btn-primary { background: #4f46e5; color: #fff; box-shadow: 0 6px 16px rgba(79,70,229,0.28); }
.btn-primary:hover { background: #4338ca; transform: translateY(-2px); }

/* STATS */
.stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 26px; }
.stat {
    background: #fff; border-radius: 14px; padding: 20px 22px;
    display: flex; align-items: center; gap: 16px;
    border: 1px solid #e5e9f2;
}
.stat .ico {
    width: 52px; height: 52px; border-radius: 13px;
    display: flex; align-items: center; justify-content: center; font-size: 24px;
}
.stat .ico.blue { background: #e0e7ff; }
.stat .ico.green { background: #dcfce7; }
.stat .ico.red { background: #fee2e2; }
.stat .num { font-size: 28px; font-weight: 700; line-height: 1; }
.stat .txt { color: #64748b; font-size: 13px; margin-top: 5px; }

/* PANEL */
.panel { background: #fff; border-radius: 14px; border: 1px solid #e5e9f2; overflow: hidden; }

.toolbar {
    display: flex; justify-content: space-between; align-items: center;
    flex-wrap: wrap; gap: 12px; padding: 18px 22px; border-bottom: 1px solid #eef1f7;
}
.toolbar h2 { font-size: 17px; }
.tools { display: flex; gap: 10px; flex-wrap: wrap; }
.tools input, .tools select {
    padding: 10px 14px; border: 1px solid #d8deea; border-radius: 9px;
    font-size: 14px; outline: none; background: #fff;
}
.tools input { width: 250px; }
.tools input:focus, .tools select:focus { border-color: #4f46e5; box-shadow: 0 0 0 3px rgba(79,70,229,0.12); }

.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th {
    text-align: left; font-size: 12px; text-transform: uppercase; letter-spacing: 0.6px;
    color: #64748b; background: #f8fafc; padding: 14px 18px; white-space: nowrap;
}
th a { color: inherit; text-decoration: none; }
th a:hover { color: #4f46e5; }
th a.sorted { color: #4f46e5; }
td { padding: 15px 18px; border-bottom: 1px solid #eef1f7; font-size: 14px; vertical-align: middle; }
tbody tr:hover { background: #fafbff; }

.title-cell b { display: block; font-size: 14px; }
.title-cell span { color: #94a3b8; font-size: 12px; }

.tag { background: #eef2ff; color: #4338ca; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; }
.badge { padding: 5px 11px; border-radius: 20px; font-size: 12px; font-weight: 700; white-space: nowrap; }
.badge.yes { background: #dcfce7; color: #15803d; }
.badge.no { background: #fee2e2; color: #b91c1c; }

.row-actions { display: flex; gap: 6px; }
.icon-btn {
    width: 34px; height: 34px; border-radius: 8px; border: 1px solid #e2e8f0; background: #fff;
    display: inline-flex; align-items: center; justify-content: center;
    text-decoration: none; cursor: pointer; font-size: 15px; transition: 0.2s;
}
.icon-btn.view:hover { background: #e0f2fe; border-color: #7dd3fc; }
.icon-btn.edit:hover { background: #e0e7ff; border-color: #a5b4fc; }
.icon-btn.del:hover { background: #fee2e2; border-color: #fca5a5; }

.empty-row td { text-align: center; padding: 55px 20px; color: #64748b; }
.empty-row .big { font-size: 42px; margin-bottom: 8px; }

/* PAGINATION */
.pager { display: flex; gap: 6px; justify-content: center; flex-wrap: wrap; padding: 18px 22px; border-top: 1px solid #eef1f7; }
.pager a {
    padding: 8px 14px; border: 1px solid #d8deea; border-radius: 8px;
    text-decoration: none; color: #334155; background: #fff; font-size: 14px; transition: 0.2s;
}
.pager a:hover { border-color: #4f46e5; color: #4f46e5; }
.pager a.active { background: #4f46e5; border-color: #4f46e5; color: #fff; }

.panel-foot { padding: 14px 22px; font-size: 13px; color: #64748b; background: #f8fafc; }

/* MODAL */
.overlay {
    position: fixed; inset: 0; background: rgba(15,23,42,0.55);
    display: none; align-items: center; justify-content: center; z-index: 50;
}
.overlay.show { display: flex; }
.modal {
    background: #fff; width: 400px; max-width: 92%; border-radius: 16px; padding: 30px 28px; text-align: center;
    animation: pop 0.2s ease;
}
@keyframes pop { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
.modal .warn { font-size: 44px; margin-bottom: 8px; }
.modal h3 { margin-bottom: 8px; }
.modal p { color: #64748b; font-size: 14px; margin-bottom: 22px; line-height: 1.6; }
.modal .btns { display: flex; gap: 10px; }
.modal .btns button { flex: 1; padding: 12px; border: none; border-radius: 9px; font-size: 14px; font-weight: 600; cursor: pointer; }
.m-cancel { background: #f1f5f9; color: #334155; }
.m-cancel:hover { background: #e2e8f0; }
.m-delete { background: #dc2626; color: #fff; }
.m-delete:hover { background: #b91c1c; }

@media (max-width: 900px) {
    .sidebar { display: none; }
    .main { margin-left: 0; padding: 22px 16px; }
    .stats { grid-template-columns: 1fr; }
    .tools input { width: 100%; }
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="brand">&#128218; Library Admin</div>

    <div class="label">MENU</div>
    <a href="${pageContext.request.contextPath}/">&#127968; Dashboard</a>
    <a href="${pageContext.request.contextPath}/books">&#128214; All Books</a>
    <a class="active" href="${pageContext.request.contextPath}/books/manage">&#9881;&#65039; Manage Books</a>
    <a href="${pageContext.request.contextPath}/books/search">&#128269; Search Books</a>
    <a href="${pageContext.request.contextPath}/books/add">&#10133; Add Book</a>

    <div class="foot">Library Management System</div>
</aside>

<!-- MAIN -->
<div class="main">

    <div class="page-head">
        <div>
            <h1>Manage Books</h1>
            <p>View, edit and remove books from your library records.</p>
        </div>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/books/add">+ Add New Book</a>
    </div>

    <!-- STATS -->
    <div class="stats">
        <div class="stat">
            <div class="ico blue">&#128218;</div>
            <div><div class="num">${totalBooks}</div><div class="txt">Total Books</div></div>
        </div>
        <div class="stat">
            <div class="ico green">&#9989;</div>
            <div><div class="num">${availableBooks}</div><div class="txt">Available</div></div>
        </div>
        <div class="stat">
            <div class="ico red">&#128683;</div>
            <div><div class="num">${unavailableBooks}</div><div class="txt">Not Available</div></div>
        </div>
    </div>

    <!-- TABLE PANEL -->
    <c:set var="base" value="${pageContext.request.contextPath}/books/manage"/>

    <div class="panel">

        <div class="toolbar">
            <h2>Book Records</h2>
            <div class="tools">
                <input type="text" id="liveSearch" placeholder="Filter this page...">
                <select id="statusFilter">
                    <option value="all">All Status</option>
                    <option value="yes">Available</option>
                    <option value="no">Not Available</option>
                </select>
            </div>
        </div>

        <div class="table-wrap">
            <table id="bookTable">
                <thead>
                <tr>
                    <th>
                        <a href="${base}?page=0&size=${size}&sortBy=id&dir=${sortBy == 'id' ? reverseDir : 'asc'}"
                           class="${sortBy == 'id' ? 'sorted' : ''}">
                            ID <c:if test="${sortBy == 'id'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="${base}?page=0&size=${size}&sortBy=title&dir=${sortBy == 'title' ? reverseDir : 'asc'}"
                           class="${sortBy == 'title' ? 'sorted' : ''}">
                            Book <c:if test="${sortBy == 'title'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                        </a>
                    </th>
                    <th>ISBN</th>
                    <th>
                        <a href="${base}?page=0&size=${size}&sortBy=category&dir=${sortBy == 'category' ? reverseDir : 'asc'}"
                           class="${sortBy == 'category' ? 'sorted' : ''}">
                            Category <c:if test="${sortBy == 'category'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="${base}?page=0&size=${size}&sortBy=price&dir=${sortBy == 'price' ? reverseDir : 'asc'}"
                           class="${sortBy == 'price' ? 'sorted' : ''}">
                            Price <c:if test="${sortBy == 'price'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="${base}?page=0&size=${size}&sortBy=available&dir=${sortBy == 'available' ? reverseDir : 'asc'}"
                           class="${sortBy == 'available' ? 'sorted' : ''}">
                            Status <c:if test="${sortBy == 'available'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                        </a>
                    </th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>

                <c:if test="${empty books}">
                    <tr class="empty-row">
                        <td colspan="7">
                            <div class="big">&#128237;</div>
                            No books in the library yet. Click "+ Add New Book" to get started.
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="book" items="${books}">
                    <tr class="book-row" data-status="${book.available ? 'yes' : 'no'}">
                        <td>#<c:out value="${book.id}"/></td>

                        <td class="title-cell">
                            <b><c:out value="${book.title}"/></b>
                            <span>by <c:out value="${book.author}"/></span>
                        </td>

                        <td><c:out value="${book.isbn}"/></td>
                        <td><span class="tag"><c:out value="${book.category}"/></span></td>
                        <td>&#8377; <c:out value="${book.price}"/></td>

                        <td>
                            <c:choose>
                                <c:when test="${book.available}"><span class="badge yes">Available</span></c:when>
                                <c:otherwise><span class="badge no">Not Available</span></c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <div class="row-actions">
                                <a class="icon-btn view" title="View"
                                   href="${pageContext.request.contextPath}/books/${book.id}">&#128065;</a>

                                <a class="icon-btn edit" title="Edit"
                                   href="${pageContext.request.contextPath}/books/edit/${book.id}">&#9998;&#65039;</a>

                                <button type="button" class="icon-btn del" title="Delete"
                                        data-id="${book.id}"
                                        data-title="<c:out value='${book.title}'/>">&#128465;&#65039;</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <tr class="empty-row" id="noMatch" style="display:none;">
                    <td colspan="7">
                        <div class="big">&#128533;</div>
                        No books match your filter.
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <!-- PAGINATION -->
        <c:if test="${totalPages > 1}">
            <div class="pager">
                <c:if test="${currentPage > 0}">
                    <a href="${base}?page=${currentPage - 1}&size=${size}&sortBy=${sortBy}&dir=${dir}">&laquo; Prev</a>
                </c:if>

                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <a class="${i == currentPage ? 'active' : ''}"
                       href="${base}?page=${i}&size=${size}&sortBy=${sortBy}&dir=${dir}">${i + 1}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages - 1}">
                    <a href="${base}?page=${currentPage + 1}&size=${size}&sortBy=${sortBy}&dir=${dir}">Next &raquo;</a>
                </c:if>
            </div>
        </c:if>

        <div class="panel-foot">
            Page ${currentPage + 1} of ${totalPages == 0 ? 1 : totalPages} &middot; ${totalItems} books total
        </div>
    </div>
</div>

<!-- DELETE MODAL -->
<div class="overlay" id="deleteModal">
    <div class="modal">
        <div class="warn">&#9888;&#65039;</div>
        <h3>Delete this book?</h3>
        <p>
            You are about to permanently delete<br>
            "<b id="modalTitle"></b>".<br>
            This action cannot be undone.
        </p>

        <form id="deleteForm" method="post" action="">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="btns">
                <button type="button" class="m-cancel" id="cancelBtn">Cancel</button>
                <button type="submit" class="m-delete">Yes, Delete</button>
            </div>
        </form>
    </div>
</div>

<script>
var ctx = "${pageContext.request.contextPath}";

/* LIVE FILTER (sirf current page ki rows par chalta hai) */
var searchBox = document.getElementById("liveSearch");
var statusBox = document.getElementById("statusFilter");
var rows = document.querySelectorAll(".book-row");
var noMatch = document.getElementById("noMatch");

function applyFilter() {
    var q = searchBox.value.toLowerCase().trim();
    var st = statusBox.value;
    var count = 0;

    rows.forEach(function (row) {
        var textOk = row.textContent.toLowerCase().indexOf(q) !== -1;
        var statusOk = (st === "all" || row.getAttribute("data-status") === st);
        var visible = textOk && statusOk;
        row.style.display = visible ? "" : "none";
        if (visible) count++;
    });

    if (rows.length > 0) {
        noMatch.style.display = (count === 0) ? "" : "none";
    }
}

searchBox.addEventListener("input", applyFilter);
statusBox.addEventListener("change", applyFilter);

/* DELETE MODAL */
var modal = document.getElementById("deleteModal");
var form = document.getElementById("deleteForm");
var modalTitle = document.getElementById("modalTitle");

document.querySelectorAll(".icon-btn.del").forEach(function (btn) {
    btn.addEventListener("click", function () {
        modalTitle.textContent = btn.getAttribute("data-title");
        form.action = ctx + "/books/delete/" + btn.getAttribute("data-id");
        modal.classList.add("show");
    });
});

document.getElementById("cancelBtn").addEventListener("click", function () {
    modal.classList.remove("show");
});

modal.addEventListener("click", function (e) {
    if (e.target === modal) modal.classList.remove("show");
});
</script>

</body>
</html>
