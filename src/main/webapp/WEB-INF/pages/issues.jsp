<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%-- Member ko naya "My Shelf" page dikhao, admin ko neeche wala All Issues table --%>
<c:if test="${not adminView}"><jsp:forward page="/WEB-INF/pages/my-books.jsp"/></c:if>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title><c:out value="${pageTitle}"/> | Library</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f1f5f9;
    color: #0f172a;
}

.topbar {
    background: #0f172a;
    padding: 0 6%;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.brand { color: #fff; font-weight: 700; font-size: 18px; text-decoration: none; }
.top-links { display: flex; gap: 6px; }
.top-links a {
    color: #cbd5e1; text-decoration: none; font-size: 14px;
    padding: 8px 14px; border-radius: 8px; transition: 0.2s;
}
.top-links a:hover { background: #1e293b; color: #fff; }
.top-links a.active { background: #2563eb; color: #fff; }

.container { max-width: 1150px; margin: 34px auto 60px; padding: 0 5%; }

.head { margin-bottom: 22px; }
.head h1 { font-size: 26px; }
.head p { color: #64748b; font-size: 14px; margin-top: 5px; }

.rules { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 22px; }
.rule {
    background: #fff; border: 1px solid #e2e8f0; border-radius: 10px;
    padding: 10px 16px; font-size: 13px; color: #475569;
}
.rule b { color: #0f172a; }

.msg { padding: 12px 16px; border-radius: 10px; margin-bottom: 18px; font-size: 14px; }
.ok  { background: #dcfce7; color: #166534; }
.err { background: #fee2e2; color: #991b1b; }

.panel { background: #fff; border-radius: 14px; border: 1px solid #e2e8f0; overflow: hidden; }
.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th {
    text-align: left; font-size: 12px; text-transform: uppercase; letter-spacing: 0.6px;
    color: #64748b; background: #f8fafc; padding: 14px 18px; white-space: nowrap;
}
td { padding: 15px 18px; border-bottom: 1px solid #eef1f6; font-size: 14px; vertical-align: middle; }
tbody tr:hover { background: #fafcff; }

.book-cell b { display: block; }
.book-cell span { color: #94a3b8; font-size: 12px; }

.badge { padding: 5px 11px; border-radius: 20px; font-size: 12px; font-weight: 700; white-space: nowrap; }
.issued   { background: #dbeafe; color: #1d4ed8; }
.returned { background: #dcfce7; color: #15803d; }
.overdue  { background: #fee2e2; color: #b91c1c; }

.fine { font-weight: 700; }
.fine.has { color: #b91c1c; }

.btn {
    padding: 9px 16px; border: none; border-radius: 8px;
    font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block;
}
.btn-return { background: #16a34a; color: #fff; }
.btn-return:hover { background: #15803d; }

.empty { text-align: center; padding: 60px 20px; color: #64748b; }
.empty .big { font-size: 44px; margin-bottom: 8px; }
.empty a {
    display: inline-block; margin-top: 16px; background: #2563eb; color: #fff;
    text-decoration: none; padding: 11px 22px; border-radius: 8px; font-size: 14px; font-weight: 600;
}
</style>
</head>

<body>

<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
    <nav class="top-links">
        <a href="${pageContext.request.contextPath}/">Home</a>
        <a href="${pageContext.request.contextPath}/explore">Explore</a>
        <a href="${pageContext.request.contextPath}/cart">Cart (${cartCount})</a>
        <a href="${pageContext.request.contextPath}/issues/my">My Books</a>
        <a class="active" href="${pageContext.request.contextPath}/issues/all">All Issues</a>
    </nav>
</header>

<div class="container">

    <div class="head">
        <h1>&#128214; <c:out value="${pageTitle}"/></h1>
        <p>Track issued books, due dates and late fines.</p>
    </div>

    <div class="rules">
        <div class="rule">Loan period: <b>14 days</b></div>
        <div class="rule">Late fine: <b>&#8377; 5 per day</b></div>
        <div class="rule">Max active books: <b>3</b></div>
    </div>

    <c:if test="${not empty success}"><div class="msg ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="msg err"><c:out value="${error}"/></div></c:if>

    <div class="panel">

        <c:if test="${empty issues}">
            <div class="empty">
                <div class="big">&#128237;</div>
                No issue records yet.
                <br>
                <a href="${pageContext.request.contextPath}/explore">Explore Books</a>
            </div>
        </c:if>

        <c:if test="${not empty issues}">
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Book</th>
                    <th>Member</th>
                    <th>Issued</th>
                    <th>Due</th>
                    <th>Returned</th>
                    <th>Status</th>
                    <th>Fine (&#8377;)</th>
                    <th>Action</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="i" items="${issues}">
                    <tr>
                        <td class="book-cell">
                            <b><c:out value="${i.book.title}"/></b>
                            <span>ISBN: <c:out value="${i.book.isbn}"/></span>
                        </td>

                        <td><c:out value="${i.member.username}"/></td>

                        <td>${i.issueDate}</td>
                        <td>${i.dueDate}</td>
                        <td>${empty i.returnDate ? '-' : i.returnDate}</td>

                        <td>
                            <c:choose>
                                <c:when test="${i.status == 'RETURNED'}">
                                    <span class="badge returned">Returned</span>
                                </c:when>
                                <c:when test="${i.overdueDays > 0}">
                                    <span class="badge overdue">Overdue ${i.overdueDays}d</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge issued">Issued</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:set var="fineValue" value="${i.status == 'RETURNED' ? i.fineAmount : i.liveFine}"/>
                            <span class="fine ${fineValue > 0 ? 'has' : ''}">${fineValue}</span>
                        </td>

                        <td>
                            <c:if test="${i.status == 'ISSUED'}">
                                <form action="${pageContext.request.contextPath}/issues/return/${i.id}"
                                      method="post" style="display:inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-return">Return</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        </c:if>

    </div>
</div>

</body>
</html>
