<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Login | Library</title>

<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);
    padding: 20px;
}

.box {
    background: #fff;
    width: 400px;
    max-width: 100%;
    padding: 38px 34px;
    border-radius: 18px;
    box-shadow: 0 25px 55px rgba(0,0,0,0.35);
}

.logo { text-align: center; font-size: 42px; margin-bottom: 6px; }
h1 { text-align: center; color: #172033; font-size: 24px; margin-bottom: 4px; }
.sub { text-align: center; color: #64748b; font-size: 14px; margin-bottom: 26px; }

.msg { padding: 11px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 13px; }
.err { background: #fee2e2; color: #991b1b; }
.ok  { background: #dcfce7; color: #166534; }

label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }

input[type=text], input[type=password] {
    width: 100%;
    padding: 13px 14px;
    margin-bottom: 16px;
    border: 1.5px solid #d5ddeb;
    border-radius: 10px;
    font-size: 15px;
    outline: none;
    transition: 0.2s;
}
input:focus { border-color: #2563eb; box-shadow: 0 0 0 4px rgba(37,99,235,0.12); }

button {
    width: 100%;
    padding: 14px;
    background: #2563eb;
    color: #fff;
    border: none;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s;
}
button:hover { background: #1d4ed8; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(37,99,235,0.3); }

.link { text-align: center; margin-top: 20px; font-size: 13px; color: #64748b; }
.link a { color: #2563eb; text-decoration: none; font-weight: 600; }
.link a:hover { text-decoration: underline; }
</style>
</head>

<body>
<div class="box">

    <div class="logo">&#128218;</div>
    <h1>Welcome Back</h1>
    <div class="sub">Login to Library Management System</div>

    <c:if test="${param.error != null}">
        <div class="msg err">Invalid username or password.</div>
    </c:if>
    <c:if test="${param.logout != null}">
        <div class="msg ok">You have been logged out.</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="msg ok"><c:out value="${success}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter username" required autofocus>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter password" required>

        <button type="submit">Login</button>
    </form>

    <div class="link">
        New member?
        <a href="${pageContext.request.contextPath}/register">Create an account</a>
    </div>

</div>
</body>
</html>
