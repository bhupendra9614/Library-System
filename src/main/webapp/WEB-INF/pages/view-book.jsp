<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>View Books</title>

<style>
body { font-family: Arial, sans-serif; background: #f5f8ff; margin: 0; }
.container { width: 90%; margin: 40px auto; }
.header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
h1 { color: #172033; }
.search-box { display: flex; gap: 10px; margin-bottom: 25px; }
.search-box input { width: 300px; padding: 12px; border: 1px solid #d5ddeb; border-radius: 8px; }
button, .btn { padding: 10px 16px; border: none; border-radius: 7px; text-decoration: none; cursor: pointer; font-size: 14px; display: inline-block; }
.search-btn { background: #2563eb; color: white; }
.add-btn { background: #16a34a; color: white; }
.home-btn { background: #64748b; color: white; }
.msg { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
.msg.ok { background: #dcfce7; color: #166534; }
.msg.err { background: #fee2e2; color: #991b1b; }

table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
th { background: #172033; color: white; padding: 15px; }
th a { color: inherit; text-decoration: none; }
th a:hover { color: #93c5fd; }
td { padding: 14px; text-align: center; border-bottom: 1px solid #edf0f5; }
.edit { background: #2563eb; color: white; }
.delete { background: #dc2626; color: white; }
.empty { padding: 30px; color: #64748b; }

.pager { display: flex; gap: 6px; justify-content: center; margin-top: 22px; flex-wrap: wrap; }
.pager a { padding: 8px 14px; border: 1px solid #d5ddeb; border-radius: 8px; text-decoration: none; color: #334155; background: #fff; font-size: 14px; }
.pager a:hover { border-color: #2563eb; color: #2563eb; }
.pager a.active { background: #2563eb; border-color: #2563eb; color: #fff; }
.total { text-align: center; color: #64748b; font-size: 13px; margin-top: 10px; }
</style>
</head>

<body>
<div class="container">

    <div class="header">
        <h1>&#128218; All Books</h1>
        <div>
            <a class="btn home-btn" href="${pageContext.request.contextPath}/">Home</a>
            <sec:authorize access="hasRole('ADMIN')">
                <a class="btn add-btn" href="${pageContext.request.contextPath}/books/add">+ Add Book</a>
            </sec:authorize>
        </div>
    </div>

    <c:if test="${not empty success}"><div class="msg ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="msg err"><c:out value="${error}"/></div></c:if>

    <form class="search-box"
          action="${pageContext.request.contextPath}/books/search"
          method="get">
        <input type="text" name="keyword"
               placeholder="Search by title or author..." required>
        <button class="search-btn" type="submit">Search</button>
    </form>

    <c:set var="base" value="${pageContext.request.contextPath}/books"/>

    <table>
        <thead>
        <tr>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=id&dir=${sortBy == 'id' ? reverseDir : 'asc'}">
                    ID <c:if test="${sortBy == 'id'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=title&dir=${sortBy == 'title' ? reverseDir : 'asc'}">
                    Title <c:if test="${sortBy == 'title'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=author&dir=${sortBy == 'author' ? reverseDir : 'asc'}">
                    Author <c:if test="${sortBy == 'author'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>ISBN</th>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=category&dir=${sortBy == 'category' ? reverseDir : 'asc'}">
                    Category <c:if test="${sortBy == 'category'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=price&dir=${sortBy == 'price' ? reverseDir : 'asc'}">
                    Price <c:if test="${sortBy == 'price'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>
                <a href="${base}?page=0&size=${size}&sortBy=available&dir=${sortBy == 'available' ? reverseDir : 'asc'}">
                    Available <c:if test="${sortBy == 'available'}">${dir == 'asc' ? '&#9650;' : '&#9660;'}</c:if>
                </a>
            </th>
            <th>Actions</th>
        </tr>
        </thead>

        <tbody>

        <c:if test="${empty books}">
            <tr>
                <td colspan="8" class="empty">No books found.</td>
            </tr>
        </c:if>

        <c:forEach var="book" items="${books}">
            <tr>
                <td><c:out value="${book.id}"/></td>
                <td><c:out value="${book.title}"/></td>
                <td><c:out value="${book.author}"/></td>
                <td><c:out value="${book.isbn}"/></td>
                <td><c:out value="${book.category}"/></td>
                <td><c:out value="${book.price}"/></td>
                <td><c:out value="${book.available}"/></td>
                <td>
                    <a class="btn" style="background:#64748b;color:white;"
                       href="${pageContext.request.contextPath}/books/${book.id}">View</a>

                    <c:if test="${book.available}">
                        <form style="display:inline"
                              action="${pageContext.request.contextPath}/issues/issue/${book.id}"
                              method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn" type="submit" style="background:#16a34a;color:white;">Issue</button>
                        </form>
                    </c:if>

                    <sec:authorize access="hasRole('ADMIN')">
                    <a class="btn edit"
                       href="${pageContext.request.contextPath}/books/edit/${book.id}">Edit</a>

                    <form style="display:inline"
                          action="${pageContext.request.contextPath}/books/delete/${book.id}"
                          method="post"
                          onsubmit="return confirm('Are you sure you want to delete this book?');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button class="btn delete" type="submit">Delete</button>
                    </form>
                    </sec:authorize>
                </td>
            </tr>
        </c:forEach>

        </tbody>
    </table>

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

    <div class="total">Total books: ${totalItems}</div>

</div>
</body>
</html>
