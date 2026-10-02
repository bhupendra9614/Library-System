<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Checkout | Library</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f1f5f9;
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
.brand { font-weight: 700; font-size: 18px; color: #0f172a; text-decoration: none; }
.secure { font-size: 13px; color: #16a34a; font-weight: 600; }

.wrap { max-width: 1000px; margin: 34px auto 60px; padding: 0 5%; }
.wrap h1 { font-size: 26px; margin-bottom: 4px; }
.wrap .sub { color: #64748b; font-size: 14px; margin-bottom: 24px; }

.layout { display: grid; grid-template-columns: 1fr 1.25fr; gap: 24px; align-items: start; }

.card { background: #fff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 26px; }
.card h2 { font-size: 16px; margin-bottom: 18px; }

/* SUMMARY */
.book-row { display: flex; gap: 14px; align-items: center; padding-bottom: 18px; border-bottom: 1px dashed #e2e8f0; margin-bottom: 16px; }
.mini-cover {
    width: 54px; height: 72px; border-radius: 4px 8px 8px 4px; flex-shrink: 0;
    background: linear-gradient(145deg, #3b82f6, #1d4ed8);
    box-shadow: 4px 6px 12px rgba(29,78,216,0.3);
}
.book-row b { display: block; font-size: 16px; word-break: break-word; }
.book-row span { color: #64748b; font-size: 13px; }

.line { display: flex; justify-content: space-between; font-size: 14px; padding: 8px 0; color: #475569; }
.line b { color: #0f172a; }
.line.total { border-top: 1px solid #e2e8f0; margin-top: 8px; padding-top: 14px; font-size: 17px; }
.line.total b { color: #2563eb; }

.note { background: #fef9c3; color: #854d0e; border-radius: 10px; padding: 11px 14px; font-size: 12.5px; line-height: 1.6; margin-top: 16px; }

/* PAYMENT */
.methods { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px; }
.method {
    border: 1.5px solid #d5ddeb; border-radius: 12px; padding: 14px 8px;
    text-align: center; cursor: pointer; font-size: 13px; font-weight: 600; color: #475569;
    background: #fff; transition: 0.2s;
}
.method .ic { font-size: 22px; display: block; margin-bottom: 5px; }
.method:hover { border-color: #93c5fd; }
.method.active { border-color: #2563eb; background: #eff6ff; color: #1d4ed8; }

.panel { display: none; }
.panel.show { display: block; }

.field { margin-bottom: 14px; }
.field label { display: block; font-size: 12.5px; font-weight: 600; color: #334155; margin-bottom: 6px; }
.field input {
    width: 100%; padding: 12px 14px; border: 1.5px solid #d5ddeb; border-radius: 10px;
    font-size: 14px; outline: none; transition: 0.2s;
}
.field input:focus { border-color: #2563eb; box-shadow: 0 0 0 4px rgba(37,99,235,0.12); }
.field input.bad { border-color: #dc2626; background: #fef2f2; }
.row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

.bank-list { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.bank {
    border: 1.5px solid #d5ddeb; border-radius: 10px; padding: 12px; font-size: 13px;
    font-weight: 600; text-align: center; cursor: pointer; transition: 0.2s;
}
.bank.active { border-color: #2563eb; background: #eff6ff; color: #1d4ed8; }

.err { color: #b91c1c; font-size: 13px; margin: 6px 0 0; min-height: 18px; }

.pay-btn {
    width: 100%; margin-top: 12px; padding: 15px; border: none; border-radius: 12px;
    background: #16a34a; color: #fff; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.2s;
}
.pay-btn:hover { background: #15803d; transform: translateY(-2px); box-shadow: 0 10px 22px rgba(22,163,74,0.3); }
.cancel { display: block; text-align: center; margin-top: 14px; color: #64748b; font-size: 13px; text-decoration: none; }
.cancel:hover { color: #0f172a; }
.demo { text-align: center; font-size: 12px; color: #94a3b8; margin-top: 14px; line-height: 1.6; }

/* PROCESSING OVERLAY */
.overlay {
    position: fixed; inset: 0; background: rgba(15,23,42,0.65);
    display: none; align-items: center; justify-content: center; z-index: 60;
}
.overlay.show { display: flex; }
.proc { background: #fff; border-radius: 16px; padding: 36px 40px; text-align: center; width: 340px; max-width: 92%; }
.spinner {
    width: 54px; height: 54px; border: 5px solid #dbeafe; border-top-color: #2563eb;
    border-radius: 50%; margin: 0 auto 18px; animation: spin 0.9s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
.proc h3 { margin-bottom: 6px; }
.proc p { color: #64748b; font-size: 13px; }

@media (max-width: 800px) {
    .layout { grid-template-columns: 1fr; }
}
</style>
</head>

<body>

<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
    <span class="secure">&#128274; Secure Checkout (Demo)</span>
</header>

<div class="wrap">
    <h1>Checkout</h1>
    <p class="sub">Review your book and complete the payment to issue it.</p>

    <div class="layout">

        <!-- LEFT: SUMMARY -->
        <div class="card">
            <h2>Order Summary</h2>

            <div class="book-row">
                <div class="mini-cover"></div>
                <div>
                    <b><c:out value="${book.title}"/></b>
                    <span>by <c:out value="${book.author}"/></span>
                </div>
            </div>

            <div class="line"><span>ISBN</span><b><c:out value="${book.isbn}"/></b></div>
            <div class="line"><span>Category</span><b><c:out value="${book.category}"/></b></div>
            <div class="line"><span>Loan period</span><b>${loanDays} days</b></div>
            <div class="line"><span>Return by</span><b>${dueDate}</b></div>
            <div class="line">
                <span>Issue fee</span>
                <b>&#8377; <fmt:formatNumber value="${fee}" minFractionDigits="2" maxFractionDigits="2"/></b>
            </div>

            <div class="line total">
                <span>Total to pay</span>
                <b>&#8377; <fmt:formatNumber value="${fee}" minFractionDigits="2" maxFractionDigits="2"/></b>
            </div>

            <div class="note">
                Late return fine: &#8377; <fmt:formatNumber value="${finePerDay}" minFractionDigits="0" maxFractionDigits="0"/> per day after the return date.
            </div>
        </div>

        <!-- RIGHT: PAYMENT -->
        <div class="card">
            <h2>Payment Method</h2>

            <div class="methods">
                <div class="method active" data-method="UPI"><span class="ic">&#128241;</span>UPI</div>
                <div class="method" data-method="CARD"><span class="ic">&#128179;</span>Card</div>
                <div class="method" data-method="NETBANKING"><span class="ic">&#127974;</span>Net Banking</div>
            </div>

            <!-- UPI -->
            <div class="panel show" id="panel-UPI">
                <div class="field">
                    <label for="upiId">UPI ID</label>
                    <input type="text" id="upiId" placeholder="yourname@bank" autocomplete="off">
                </div>
            </div>

            <!-- CARD -->
            <div class="panel" id="panel-CARD">
                <div class="field">
                    <label for="cardNo">Card Number</label>
                    <input type="text" id="cardNo" placeholder="1234 5678 9012 3456" maxlength="19" inputmode="numeric" autocomplete="off">
                </div>
                <div class="row2">
                    <div class="field">
                        <label for="cardExp">Expiry (MM/YY)</label>
                        <input type="text" id="cardExp" placeholder="MM/YY" maxlength="5" autocomplete="off">
                    </div>
                    <div class="field">
                        <label for="cardCvv">CVV</label>
                        <input type="password" id="cardCvv" placeholder="123" maxlength="3" inputmode="numeric" autocomplete="off">
                    </div>
                </div>
            </div>

            <!-- NET BANKING -->
            <div class="panel" id="panel-NETBANKING">
                <div class="bank-list">
                    <div class="bank" data-bank="SBI">SBI</div>
                    <div class="bank" data-bank="HDFC">HDFC</div>
                    <div class="bank" data-bank="ICICI">ICICI</div>
                    <div class="bank" data-bank="Axis">Axis</div>
                </div>
            </div>

            <div class="err" id="errMsg"></div>

            <button type="button" class="pay-btn" id="payBtn">
                Pay &#8377; <fmt:formatNumber value="${fee}" minFractionDigits="2" maxFractionDigits="2"/> &amp; Issue Book
            </button>

            <a class="cancel" href="${pageContext.request.contextPath}/books/search">&larr; Cancel and go back</a>

            <div class="demo">
                &#9888;&#65039; Demo payment. No real money is charged.<br>
                Card, UPI and bank details are not sent to the server or stored.
            </div>

            <!-- Sirf payment method server ko jata hai -->
            <form id="payForm" action="${pageContext.request.contextPath}/checkout/${book.id}/pay" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <input type="hidden" name="method" id="methodInput" value="UPI">
            </form>
        </div>

    </div>
</div>

<!-- PROCESSING -->
<div class="overlay" id="procOverlay">
    <div class="proc">
        <div class="spinner"></div>
        <h3>Processing payment...</h3>
        <p>Please do not close or refresh this page.</p>
    </div>
</div>

<script>
var current = "UPI";
var selectedBank = "";
var errMsg = document.getElementById("errMsg");

/* method tabs */
document.querySelectorAll(".method").forEach(function (m) {
    m.addEventListener("click", function () {
        document.querySelectorAll(".method").forEach(function (x) { x.classList.remove("active"); });
        document.querySelectorAll(".panel").forEach(function (p) { p.classList.remove("show"); });
        m.classList.add("active");
        current = m.getAttribute("data-method");
        document.getElementById("panel-" + current).classList.add("show");
        document.getElementById("methodInput").value = current;
        errMsg.textContent = "";
    });
});

/* bank select */
document.querySelectorAll(".bank").forEach(function (b) {
    b.addEventListener("click", function () {
        document.querySelectorAll(".bank").forEach(function (x) { x.classList.remove("active"); });
        b.classList.add("active");
        selectedBank = b.getAttribute("data-bank");
        errMsg.textContent = "";
    });
});

/* input helpers */
document.getElementById("cardNo").addEventListener("input", function () {
    var v = this.value.replace(/\D/g, "").substring(0, 16);
    this.value = v.replace(/(.{4})/g, "$1 ").trim();
});
document.getElementById("cardExp").addEventListener("input", function () {
    var v = this.value.replace(/\D/g, "").substring(0, 4);
    if (v.length > 2) v = v.substring(0, 2) + "/" + v.substring(2);
    this.value = v;
});
document.getElementById("cardCvv").addEventListener("input", function () {
    this.value = this.value.replace(/\D/g, "").substring(0, 3);
});

function bad(id, msg) {
    document.getElementById(id).classList.add("bad");
    errMsg.textContent = msg;
    return false;
}

function validate() {
    document.querySelectorAll(".field input").forEach(function (i) { i.classList.remove("bad"); });
    errMsg.textContent = "";

    if (current === "UPI") {
        var upi = document.getElementById("upiId").value.trim();
        if (!/^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$/.test(upi)) {
            return bad("upiId", "Enter a valid UPI ID, e.g. name@bank");
        }
    }

    if (current === "CARD") {
        var no = document.getElementById("cardNo").value.replace(/\s/g, "");
        if (no.length !== 16) return bad("cardNo", "Enter a valid 16 digit card number.");

        var exp = document.getElementById("cardExp").value;
        var m = /^(\d{2})\/(\d{2})$/.exec(exp);
        if (!m || +m[1] < 1 || +m[1] > 12) return bad("cardExp", "Enter expiry as MM/YY.");
        var now = new Date();
        var expDate = new Date(2000 + (+m[2]), +m[1], 1);
        if (expDate <= now) return bad("cardExp", "This card has expired.");

        if (document.getElementById("cardCvv").value.length !== 3) return bad("cardCvv", "Enter the 3 digit CVV.");
    }

    if (current === "NETBANKING" && !selectedBank) {
        errMsg.textContent = "Please select your bank.";
        return false;
    }
    return true;
}

var paying = false;
document.getElementById("payBtn").addEventListener("click", function () {
    if (paying || !validate()) return;
    paying = true;
    document.getElementById("procOverlay").classList.add("show");
    setTimeout(function () {
        document.getElementById("payForm").submit();
    }, 1800);
});
</script>

</body>
</html>
