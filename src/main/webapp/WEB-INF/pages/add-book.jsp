<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:,">
    <title>Add Book</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f8ff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }

        .form-container {
            width: 460px;
            max-width: 94%;
            background: white;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.10);
        }

        h1 {
            text-align: center;
            color: #172033;
            margin: 0 0 28px;
        }

        .error-box {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 14px;
            line-height: 1.7;
        }

        .form-group { margin-bottom: 16px; }

        label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-size: 14px;
            font-weight: 600;
        }

        input,
        select {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #d5ddeb;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
        }

        input:focus,
        select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.10);
        }

        .save-btn {
            width: 100%;
            padding: 13px;
            margin-top: 8px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .save-btn:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(37, 99, 235, 0.25);
        }

        .back-btn {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #64748b;
            text-decoration: none;
            font-size: 13px;
        }

        .back-btn:hover { color: #2563eb; }

        /* SUCCESS POPUP */
        .pop-overlay {
            position: fixed; inset: 0; background: rgba(15, 23, 42, 0.55);
            display: flex; align-items: center; justify-content: center; z-index: 50;
        }
        .pop-overlay.hide { display: none; }
        .pop-box {
            background: #fff; width: 380px; max-width: 92%; border-radius: 18px;
            padding: 34px 28px 28px; text-align: center;
            animation: popIn 0.35s ease;
        }
        @keyframes popIn { from { transform: scale(0.8); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .pop-tick {
            width: 70px; height: 70px; border-radius: 50%; background: #16a34a; color: #fff;
            font-size: 38px; display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px; box-shadow: 0 8px 20px rgba(22, 163, 74, 0.35);
        }
        .pop-box h3 { color: #166534; margin-bottom: 8px; font-size: 20px; }
        .pop-box p { color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 22px; word-break: break-word; }
        .pop-ok {
            width: 100%; padding: 13px; border: none; border-radius: 10px;
            background: #16a34a; color: #fff; font-size: 15px; font-weight: 600; cursor: pointer;
        }
        .pop-ok:hover { background: #15803d; }
    </style>
</head>

<body>

<div class="form-container">

    <h1>&#10133; Add New Book</h1>

    <!-- ERROR BOX (validation / duplicate ISBN) -->
    <c:if test="${not empty errorMessages}">
        <div class="error-box">
            <c:forEach var="msg" items="${errorMessages}">
                &bull; <c:out value="${msg}"/><br>
            </c:forEach>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/books/save" method="post">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <!-- TITLE -->
        <div class="form-group">
            <label for="title">Book Title</label>
            <input type="text" id="title" name="title"
                   value="<c:out value='${book.title}'/>"
                   placeholder="Enter book title"
                   maxlength="150" required>
        </div>

        <!-- AUTHOR -->
        <div class="form-group">
            <label for="author">Author</label>
            <input type="text" id="author" name="author"
                   value="<c:out value='${book.author}'/>"
                   placeholder="Enter author name"
                   maxlength="100" required>
        </div>

        <!-- ISBN -->
        <div class="form-group">
            <label for="isbn">ISBN</label>
            <input type="text" id="isbn" name="isbn"
                   value="<c:out value='${book.isbn}'/>"
                   placeholder="Enter ISBN"
                   maxlength="20" required>
        </div>

        <!-- CATEGORY -->
        <div class="form-group">
            <label for="category">Category</label>
            <input type="text" id="category" name="category"
                   value="<c:out value='${book.category}'/>"
                   placeholder="Enter book category"
                   maxlength="50" required>
        </div>

        <!-- PRICE -->
        <div class="form-group">
            <label for="price">Price</label>
            <input type="number" id="price" name="price"
                   value="<c:out value='${book.price}'/>"
                   step="0.01" min="0"
                   placeholder="Enter price" required>
        </div>

        <!-- AVAILABLE -->
        <div class="form-group">
            <label for="available">Availability</label>
            <select id="available" name="available">
                <option value="true" ${book.available == false ? '' : 'selected'}>Available</option>
                <option value="false" ${book.available == false ? 'selected' : ''}>Not Available</option>
            </select>
        </div>

        <!-- SAVE -->
        <button type="submit" class="save-btn">Save Book</button>

    </form>

    <a href="${pageContext.request.contextPath}/books/manage" class="back-btn">
        &larr; Back to Manage Books
    </a>

</div>

<!-- SUCCESS POPUP (book add hone ke baad, isi page par) -->
<c:if test="${not empty success}">
    <div class="pop-overlay" id="successPop">
        <div class="pop-box">
            <div class="pop-tick">&#10003;</div>
            <h3>Book Added Successfully!</h3>
            <p>"<b><c:out value="${success}"/></b>" has been added to the library.<br>You can add another book now.</p>
            <button type="button" class="pop-ok" id="popOk">OK, Add Another Book</button>
        </div>
    </div>

    <script>
        var pop = document.getElementById("successPop");
        function closePop() {
            pop.classList.add("hide");
            document.getElementById("title").focus();
        }
        document.getElementById("popOk").addEventListener("click", closePop);
        pop.addEventListener("click", function (e) { if (e.target === pop) closePop(); });
        document.addEventListener("keydown", function (e) { if (e.key === "Escape") closePop(); });
    </script>
</c:if>

</body>
</html>
