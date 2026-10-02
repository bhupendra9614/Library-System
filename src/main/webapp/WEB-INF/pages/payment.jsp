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
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: linear-gradient(160deg, #ecfdf5 0%, #f1f5f9 60%);
    color: #0f172a;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
}

.box {
    background: #fff;
    width: 480px;
    max-width: 100%;
    border-radius: 20px;
    padding: 38px 34px 30px;
    text-align: center;
    box-shadow: 0 20px 50px rgba(15,23,42,0.12);
}

.tick {
    width: 84px; height: 84px; border-radius: 50%;
    background: #16a34a; color: #fff; font-size: 44px;
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 18px;
    animation: pop 0.5s ease;
    box-shadow: 0 10px 25px rgba(22,163,74,0.35);
}
@keyframes pop { 0% { transform: scale(0); } 70% { transform: scale(1.15); } 100% { transform: scale(1); } }

h1 { font-size: 24px; margin-bottom: 6px; color: #166534; }
.sub { color: #64748b; font-size: 14px; margin-bottom: 24px; line-height: 1.6; }

.receipt {
    background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 14px;
    padding: 18px 20px; text-align: left; margin-bottom: 18px;
}
.receipt .head { font-size: 11px; letter-spacing: 1px; color: #94a3b8; margin-bottom: 10px; }
.line { display: flex; justify-content: space-between; gap: 14px; padding: 7px 0; font-size: 14px; }
.line span { color: #64748b; }
.line b { text-align: right; word-break: break-word; }
.line.total { border-top: 1px solid #e2e8f0; margin-top: 6px; padding-top: 12px; font-size: 16px; }
.line.total b { color: #166534; }

.reminder {
    background: #eff6ff; color: #1e40af; border-radius: 10px;
    padding: 12px 14px; font-size: 13px; line-height: 1.6; margin-bottom: 22px; text-align: left;
}

.actions { display: flex; gap: 10px; }
.btn {
    flex: 1; padding: 14px; border-radius: 12px; font-size: 15px; font-weight: 700;
    text-decoration: none; text-align: center; transition: 0.2s;
}
.btn-primary { background: #2563eb; color: #fff; }
.btn-primary:hover { background: #1d4ed8; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(37,99,235,0.3); }
.btn-ghost { background: #f1f5f9; color: #334155; }
.btn-ghost:hover { background: #e2e8f0; }

@media (max-width: 480px) { .actions { flex-direction: column; } }
</style>
</head>

<body>
<div class="box">

    <div class="tick">&#10003;</div>
    <h1>Payment Successful!</h1>
    <p class="sub">
        Your book has been issued.<br>
        Please keep the transaction ID for your records.
    </p>

    <div class="receipt">
        <div class="head">RECEIPT</div>

        <div class="line"><span>Transaction ID</span><b><c:out value="${payment.transactionId}"/></b></div>
        <div class="line"><span>Payment method</span><b><c:out value="${payment.method}"/></b></div>
        <div class="line"><span>Paid on</span><b id="paidAt" data-iso="${payment.paidAt}">-</b></div>
        <div class="line"><span>Book</span><b><c:out value="${issue.book.title}"/></b></div>
        <div class="line"><span>Issued on</span><b>${issue.issueDate}</b></div>
        <div class="line"><span>Return by</span><b>${issue.dueDate}</b></div>

        <div class="line total">
            <span>Amount paid</span>
            <b>&#8377; <fmt:formatNumber value="${payment.amount}" minFractionDigits="2" maxFractionDigits="2"/></b>
        </div>
    </div>

    <div class="reminder">
        Return the book by <b>${issue.dueDate}</b> to avoid a late fine of
        &#8377; <fmt:formatNumber value="${finePerDay}" minFractionDigits="0" maxFractionDigits="0"/> per day.
    </div>

    <div class="actions">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/books/search">Continue</a>
        <a class="btn btn-ghost" href="${pageContext.request.contextPath}/issues/my">My Books</a>
    </div>

</div>

<script>
var el = document.getElementById("paidAt");
var iso = el.getAttribute("data-iso");
if (iso) {
    var d = new Date(iso);
    if (!isNaN(d.getTime())) {
        el.textContent = d.toLocaleString("en-IN", {
            day: "2-digit", month: "short", year: "numeric",
            hour: "2-digit", minute: "2-digit"
        });
    } else {
        el.textContent = iso;
    }
}
</script>

</body>
</html>
