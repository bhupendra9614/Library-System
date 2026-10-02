<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title><c:out value="${book.title}"/> | Book Details</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #eef2f7;
    color: #0f172a;
    min-height: 100vh;
}

.topbar {
    background: #fff;
    border-bottom: 1px solid #e2e8f0;
    padding: 0 6%;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.topbar .brand { font-weight: 700; font-size: 18px; color: #0f172a; text-decoration: none; }
.crumbs { font-size: 13px; color: #94a3b8; }
.crumbs a { color: #7c3aed; text-decoration: none; }
.crumbs a:hover { text-decoration: underline; }
.crumbs span { margin: 0 6px; }

.wrap { max-width: 1000px; margin: 36px auto 60px; padding: 0 5%; }

.detail-card {
    background: #fff;
    border-radius: 20px;
    overflow: hidden;
    display: grid;
    grid-template-columns: 320px 1fr;
    box-shadow: 0 14px 40px rgba(15,23,42,0.10);
}

/* LEFT: COVER */
.cover-side {
    background: linear-gradient(160deg, #6d28d9 0%, #4c1d95 100%);
    padding: 40px 28px;
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #fff;
}
.cover {
    width: 170px;
    height: 230px;
    border-radius: 6px 14px 14px 6px;
    background: linear-gradient(145deg, #a78bfa, #7c3aed);
    box-shadow: 14px 18px 34px rgba(0,0,0,0.35);
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 18px;
    text-align: center;
    font-weight: 700;
    font-size: 17px;
    line-height: 1.3;
    word-break: break-word;
    transform: perspective(700px) rotateY(-12deg);
}
.cover::before {
    content: "";
    position: absolute;
    left: 12px; top: 14px; bottom: 14px;
    width: 3px;
    background: rgba(255,255,255,0.35);
    border-radius: 3px;
}
.status-pill {
    margin-top: 32px;
    padding: 8px 18px;
    border-radius: 30px;
    font-size: 13px;
    font-weight: 700;
}
.status-pill.yes { background: #bbf7d0; color: #166534; }
.status-pill.no { background: #fecaca; color: #991b1b; }
.price-big { margin-top: 18px; font-size: 30px; font-weight: 700; }
.price-label { font-size: 12px; color: #ddd6fe; letter-spacing: 1px; }

/* RIGHT: DETAILS */
.info-side { padding: 38px 40px; }
.category-tag {
    display: inline-block;
    background: #f3e8ff;
    color: #7c3aed;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.8px;
    text-transform: uppercase;
    padding: 5px 12px;
    border-radius: 6px;
    margin-bottom: 14px;
}
.info-side h1 { font-size: 28px; line-height: 1.25; margin-bottom: 6px; word-break: break-word; }
.author { color: #64748b; font-size: 16px; margin-bottom: 28px; }

.grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 30px; }
.item { background: #f8fafc; border: 1px solid #e8edf3; border-radius: 12px; padding: 14px 16px; }
.item .k { font-size: 11px; color: #94a3b8; letter-spacing: 0.7px; text-transform: uppercase; margin-bottom: 5px; }
.item .v { font-size: 15px; font-weight: 600; word-break: break-word; }

.actions { display: flex; gap: 10px; flex-wrap: wrap; padding-top: 24px; border-top: 1px solid #eef1f6; }
.btn {
    padding: 12px 22px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    cursor: pointer;
    border: none;
    transition: 0.2s;
    display: inline-block;
}
.btn-edit { background: #7c3aed; color: #fff; }
.btn-edit:hover { background: #6d28d9; transform: translateY(-2px); box-shadow: 0 8px 18px rgba(124,58,237,0.3); }
.btn-del { background: #fff; color: #dc2626; border: 1.5px solid #fca5a5; }
.btn-del:hover { background: #dc2626; color: #fff; }
.btn-back { background: #f1f5f9; color: #334155; }
.btn-back:hover { background: #e2e8f0; }

/* MODAL */
.overlay {
    position: fixed; inset: 0; background: rgba(15,23,42,0.55);
    display: none; align-items: center; justify-content: center; z-index: 50;
}
.overlay.show { display: flex; }
.modal { background: #fff; width: 390px; max-width: 92%; border-radius: 16px; padding: 28px; text-align: center; }
.modal .w { font-size: 42px; margin-bottom: 8px; }
.modal h3 { margin-bottom: 8px; }
.modal p { color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 20px; }
.modal .btns { display: flex; gap: 10px; }
.modal .btns button { flex: 1; padding: 12px; border: none; border-radius: 9px; font-weight: 600; cursor: pointer; font-size: 14px; }
.m-no { background: #f1f5f9; color: #334155; }
.m-yes { background: #dc2626; color: #fff; }

@media (max-width: 800px) {
    .detail-card { grid-template-columns: 1fr; }
    .info-side { padding: 28px 22px; }
    .grid { grid-template-columns: 1fr; }
    .crumbs { display: none; }
}
</style>
</head>

<body>

<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
    <div class="crumbs">
        <a href="${pageContext.request.contextPath}/">Home</a><span>/</span>
        <a href="${pageContext.request.contextPath}/books/manage">Manage Books</a><span>/</span>
        Book Details
    </div>
</header>

<div class="wrap">
    <div class="detail-card">

        <!-- LEFT: COVER -->
        <div class="cover-side">
            <div class="cover"><c:out value="${book.title}"/></div>

            <c:choose>
                <c:when test="${book.available}">
                    <div class="status-pill yes">&#9679; Available</div>
                </c:when>
                <c:otherwise>
                    <div class="status-pill no">&#9679; Not Available</div>
                </c:otherwise>
            </c:choose>

            <div class="price-big">&#8377; <c:out value="${book.price}"/></div>
            <div class="price-label">PRICE</div>
        </div>

        <!-- RIGHT: DETAILS -->
        <div class="info-side">
            <span class="category-tag"><c:out value="${book.category}"/></span>
            <h1><c:out value="${book.title}"/></h1>
            <div class="author">by <c:out value="${book.author}"/></div>

            <div class="grid">
                <div class="item"><div class="k">Book ID</div><div class="v">#<c:out value="${book.id}"/></div></div>
                <div class="item"><div class="k">ISBN</div><div class="v"><c:out value="${book.isbn}"/></div></div>
                <div class="item"><div class="k">Category</div><div class="v"><c:out value="${book.category}"/></div></div>
                <div class="item">
                    <div class="k">Availability</div>
                    <div class="v">${book.available ? 'In library' : 'Currently issued / unavailable'}</div>
                </div>
                <div class="item"><div class="k">Added on</div><div class="v dt" data-iso="${book.createdAt}">-</div></div>
                <div class="item"><div class="k">Last updated</div><div class="v dt" data-iso="${book.updatedAt}">-</div></div>
            </div>

            <div class="actions">
                <a class="btn btn-edit" href="${pageContext.request.contextPath}/books/edit/${book.id}">&#9998;&#65039; Edit Book</a>
                <button type="button" class="btn btn-del" id="openDelete">&#128465;&#65039; Delete</button>
                <a class="btn btn-back" href="${pageContext.request.contextPath}/books/manage">&larr; Back to Manage</a>
                <a class="btn btn-back" href="${pageContext.request.contextPath}/books">All Books</a>
            </div>
        </div>

    </div>
</div>

<!-- DELETE MODAL -->
<div class="overlay" id="deleteModal">
    <div class="modal">
        <div class="w">&#9888;&#65039;</div>
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
var modal = document.getElementById("deleteModal");

document.getElementById("openDelete").addEventListener("click", function () {
    modal.classList.add("show");
});
document.getElementById("closeDelete").addEventListener("click", function () {
    modal.classList.remove("show");
});
modal.addEventListener("click", function (e) {
    if (e.target === modal) modal.classList.remove("show");
});

/* readable dates */
document.querySelectorAll(".dt").forEach(function (node) {
    var iso = node.getAttribute("data-iso");
    if (!iso) return;
    var d = new Date(iso);
    node.textContent = isNaN(d.getTime())
        ? iso
        : d.toLocaleString("en-IN", { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit" });
});
</script>

</body>
</html>
