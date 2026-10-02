<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Register | Library</title>

<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #064e3b 0%, #0f766e 100%);
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

label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }

input[type=text], input[type=password] {
    width: 100%;
    padding: 13px 14px;
    margin-bottom: 6px;
    border: 1.5px solid #d5ddeb;
    border-radius: 10px;
    font-size: 15px;
    outline: none;
    transition: 0.2s;
}
input:focus { border-color: #0d9488; box-shadow: 0 0 0 4px rgba(13,148,136,0.12); }
.hint { font-size: 12px; color: #94a3b8; margin-bottom: 16px; }

button {
    width: 100%;
    padding: 14px;
    margin-top: 6px;
    background: #0d9488;
    color: #fff;
    border: none;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s;
}
button:hover { background: #0f766e; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(13,148,136,0.3); }

.link { text-align: center; margin-top: 20px; font-size: 13px; color: #64748b; }
.link a { color: #0d9488; text-decoration: none; font-weight: 600; }
.link a:hover { text-decoration: underline; }
</style>
</head>

<body>
<div class="box">

    <div class="logo">&#128218;</div>
    <h1>Create Account</h1>
    <div class="sub">Join the library as a member</div>

    <c:if test="${not empty error}">
        <div class="msg err"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <label for="fullName">Full Name</label>
        <input type="text" id="fullName" name="fullName" placeholder="Your full name"
               minlength="2" maxlength="100" required autofocus>
        <div class="hint">As it should appear on library records</div>

        <label for="phone">Mobile Number</label>
        <input type="text" id="phone" name="phone" placeholder="10 digit mobile number"
               pattern="[6-9][0-9]{9}" maxlength="10" inputmode="numeric" required
               title="Enter a valid 10 digit mobile number">
        <div class="hint">10 digits, starting with 6, 7, 8 or 9</div>

        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Choose a username"
               minlength="3" maxlength="50" required>
        <div class="hint">At least 3 characters</div>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Choose a password"
               minlength="6" required>
        <div class="hint">At least 6 characters</div>

        <button type="submit">Register</button>
    </form>

    <div class="link">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login">Login</a>
    </div>

</div>
</body>
</html>
