<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error</title>
<style>
body { font-family: Arial, sans-serif; background: #f5f8ff; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
.box { background: #fff; padding: 40px; border-radius: 16px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.08); max-width: 440px; }
h1 { color: #dc2626; margin-bottom: 10px; }
p { color: #475569; margin-bottom: 24px; }
a { background: #2563eb; color: #fff; text-decoration: none; padding: 11px 22px; border-radius: 8px; }
</style>
</head>
<body>
<div class="box">
    <h1>&#9888;&#65039; <c:out value="${title}"/></h1>
    <p><c:out value="${message}"/></p>
    <a href="${pageContext.request.contextPath}/books">Back to Books</a>
</div>
</body>
</html>