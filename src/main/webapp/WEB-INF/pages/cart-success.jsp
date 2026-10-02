<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Payment Successful | Library</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f1f5f9;color:#0f172a;min-height:100vh;padding:40px 5%}
.box{max-width:640px;margin:0 auto;background:#fff;border:1px solid #e2e8f0;border-radius:18px;padding:34px}
.tick{width:68px;height:68px;border-radius:50%;background:#dcfce7;color:#16a34a;font-size:36px;display:grid;place-items:center;margin:0 auto 14px}
h1{text-align:center;font-size:24px}.sub{text-align:center;color:#64748b;font-size:14px;margin:6px 0 22px}
.b{padding:14px 0;border-top:1px dashed #e2e8f0}
.b b{display:block;font-size:15px}.b span{font-size:13px;color:#64748b;display:block;margin-top:3px}
.line{display:flex;justify-content:space-between;font-size:14px;padding:8px 0;color:#475569}.line b{color:#0f172a}
.total{border-top:1px solid #e2e8f0;margin-top:6px;padding-top:14px;font-size:17px}.total b{color:#16a34a}
.note{background:#fef9c3;color:#854d0e;border-radius:10px;padding:10px 14px;font-size:12.5px;margin:16px 0}
.btns{display:flex;gap:12px;flex-wrap:wrap;margin-top:6px}
.btns a{flex:1;min-width:160px;text-align:center;text-decoration:none;padding:13px;border-radius:10px;font-weight:600;font-size:14px;background:#2563eb;color:#fff}
.btns a.alt{background:#fff;color:#2563eb;border:1px solid #bfd3f8}
</style>
</head>
<body>
<div class="box">
  <div class="tick">&#10003;</div>
  <h1>Payment Successful!</h1>
  <p class="sub">${payments.size()} book(s) issued to you.</p>

  <c:forEach var="p" items="${payments}">
    <div class="b">
      <b><c:out value="${p.issue.book.title}"/></b>
      <span>Return by ${p.issue.dueDate} &bull; Txn: <c:out value="${p.transactionId}"/></span>
    </div>
  </c:forEach>

  <div class="line"><span>Payment method</span><b><c:out value="${payments[0].method}"/></b></div>
  <div class="line total"><span>Total paid</span><b>&#8377; <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></b></div>
  <div class="note">Late return fine: &#8377; <fmt:formatNumber value="${finePerDay}" minFractionDigits="0" maxFractionDigits="0"/> per day per book. Demo payment, no real money charged.</div>

  <div class="btns">
    <a href="${pageContext.request.contextPath}/issues/my">Go to My Books</a>
    <a class="alt" href="${pageContext.request.contextPath}/explore">Continue Exploring</a>
  </div>
</div>
</body>
</html>
