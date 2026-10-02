<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>My Cart | Library</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f1f5f9;color:#0f172a;min-height:100vh}
.topbar{background:#fff;border-bottom:1px solid #e2e8f0;padding:0 6%;height:64px;display:flex;align-items:center;justify-content:space-between}
.brand{font-weight:700;font-size:18px;color:#0f172a;text-decoration:none}
.nav a{color:#475569;text-decoration:none;font-size:14px;padding:8px 14px;border-radius:8px}
.nav a:hover{background:#eef2f7}.nav a.on{background:#2563eb;color:#fff}
.wrap{max-width:1080px;margin:32px auto 60px;padding:0 5%}
h1{font-size:26px;margin-bottom:4px}.sub{color:#64748b;font-size:14px;margin-bottom:22px}
.msg{padding:12px 16px;border-radius:10px;margin-bottom:16px;font-size:14px}
.ok{background:#dcfce7;color:#166534}.err{background:#fee2e2;color:#991b1b}.warn{background:#fef9c3;color:#854d0e}
.layout{display:grid;grid-template-columns:1.2fr 1fr;gap:24px;align-items:start}
.card{background:#fff;border:1px solid #e2e8f0;border-radius:16px;padding:24px}
.card h2{font-size:16px;margin-bottom:16px}
.item{display:flex;gap:14px;align-items:center;padding:14px 0;border-bottom:1px dashed #e2e8f0}
.item:last-of-type{border-bottom:0}
.cv{position:relative;width:54px;height:76px;flex-shrink:0;border-radius:4px 8px 8px 4px;overflow:hidden;background:linear-gradient(145deg,#3b82f6,#1d4ed8);box-shadow:3px 5px 10px rgba(29,78,216,.3)}
.cv img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;background:#fff}
.info{flex:1;min-width:0}.info b{display:block;font-size:15px;word-break:break-word}
.info span{color:#64748b;font-size:13px}.price{font-weight:700;color:#2563eb;white-space:nowrap}
.rm{border:1px solid #fca5a5;background:#fff;color:#dc2626;border-radius:8px;padding:7px 12px;font-size:12.5px;font-weight:600;cursor:pointer}
.rm:hover{background:#dc2626;color:#fff}
.line{display:flex;justify-content:space-between;font-size:14px;padding:7px 0;color:#475569}.line b{color:#0f172a}
.line.total{border-top:1px solid #e2e8f0;margin-top:8px;padding-top:14px;font-size:17px}.line.total b{color:#2563eb}
.note{background:#fef9c3;color:#854d0e;border-radius:10px;padding:10px 14px;font-size:12.5px;line-height:1.6;margin:14px 0 18px}
.methods{display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin:6px 0 16px}
.method{border:1.5px solid #d5ddeb;border-radius:12px;padding:12px 6px;text-align:center;cursor:pointer;font-size:13px;font-weight:600;color:#475569;background:#fff}
.method .ic{font-size:21px;display:block;margin-bottom:4px}.method.active{border-color:#2563eb;background:#eff6ff;color:#1d4ed8}
.panel{display:none}.panel.show{display:block}
.field{margin-bottom:12px}.field label{display:block;font-size:12.5px;font-weight:600;color:#334155;margin-bottom:5px}
.field input{width:100%;padding:11px 13px;border:1.5px solid #d5ddeb;border-radius:10px;font-size:14px;outline:none}
.field input:focus{border-color:#2563eb;box-shadow:0 0 0 4px rgba(37,99,235,.12)}.field input.bad{border-color:#dc2626;background:#fef2f2}
.row2{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.banks{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.bank{border:1.5px solid #d5ddeb;border-radius:10px;padding:11px;font-size:13px;font-weight:600;text-align:center;cursor:pointer}.bank.active{border-color:#2563eb;background:#eff6ff;color:#1d4ed8}
.errm{color:#b91c1c;font-size:13px;min-height:18px;margin-top:4px}
.pay{width:100%;margin-top:10px;padding:14px;border:0;border-radius:12px;background:#16a34a;color:#fff;font-size:16px;font-weight:700;cursor:pointer}
.pay:hover{background:#15803d}
.demo{text-align:center;font-size:12px;color:#94a3b8;margin-top:12px;line-height:1.6}
.empty{text-align:center;padding:60px 20px;color:#64748b}.empty .big{font-size:46px;margin-bottom:8px}
.empty a,.more{display:inline-block;margin-top:14px;background:#2563eb;color:#fff;text-decoration:none;padding:11px 22px;border-radius:8px;font-size:14px;font-weight:600}
.more{background:#fff;color:#2563eb;border:1px solid #bfd3f8;margin-top:6px}
.overlay{position:fixed;inset:0;background:rgba(15,23,42,.65);display:none;align-items:center;justify-content:center;z-index:60}.overlay.show{display:flex}
.proc{background:#fff;border-radius:16px;padding:34px 38px;text-align:center;width:340px;max-width:92%}
.spin{width:52px;height:52px;border:5px solid #dbeafe;border-top-color:#2563eb;border-radius:50%;margin:0 auto 16px;animation:sp .9s linear infinite}
@keyframes sp{to{transform:rotate(360deg)}}
@media(max-width:800px){.layout{grid-template-columns:1fr}}
@media(prefers-reduced-motion:reduce){.spin{animation:none}}
</style>
</head>
<body>
<header class="topbar">
  <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
  <nav class="nav">
    <a href="${pageContext.request.contextPath}/explore">Explore</a>
    <a class="on" href="${pageContext.request.contextPath}/cart">Cart (${cartCount})</a>
    <a href="${pageContext.request.contextPath}/issues/my">My Books</a>
  </nav>
</header>

<div class="wrap">
  <h1>&#128722; My Cart</h1>
  <p class="sub">Add up to ${maxActive} books, then pay once to issue them all.</p>

  <c:if test="${not empty success}"><div class="msg ok"><c:out value="${success}"/></div></c:if>
  <c:if test="${not empty error}"><div class="msg err"><c:out value="${error}"/></div></c:if>

  <c:if test="${count == 0}">
    <div class="card empty">
      <div class="big">&#128722;</div>
      Your cart is empty.<br>
      <a href="${pageContext.request.contextPath}/explore">Explore Books</a>
    </div>
  </c:if>

  <c:if test="${count > 0}">
    <c:set var="tooMany" value="${count > slotsLeft}"/>
    <c:if test="${tooMany}">
      <div class="msg warn">You already have ${activeCount} book(s) issued, so you can issue only ${slotsLeft} more. Remove some books from the cart to continue.</div>
    </c:if>

    <div class="layout">
      <div class="card">
        <h2>Books in cart (${count})</h2>
        <c:forEach var="b" items="${items}">
          <div class="item">
            <div class="cv">
              <c:if test="${not empty b.isbn}">
                <img loading="lazy" alt="" src="https://covers.openlibrary.org/b/isbn/${fn:replace(fn:replace(b.isbn,'-',''),' ','')}-M.jpg?default=false" onerror="this.remove()">
              </c:if>
            </div>
            <div class="info">
              <b><c:out value="${b.title}"/></b>
              <span>by <c:out value="${b.author}"/> &bull; <c:out value="${b.category}"/></span>
            </div>
            <div class="price">&#8377; <fmt:formatNumber value="${fee}" minFractionDigits="2" maxFractionDigits="2"/></div>
            <form action="${pageContext.request.contextPath}/cart/remove/${b.id}" method="post">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <button class="rm" type="submit">Remove</button>
            </form>
          </div>
        </c:forEach>
        <a class="more" href="${pageContext.request.contextPath}/explore">+ Add more books</a>
      </div>

      <div class="card">
        <h2>Order Summary</h2>
        <div class="line"><span>Books</span><b>${count}</b></div>
        <div class="line"><span>Fee per book</span><b>&#8377; <fmt:formatNumber value="${fee}" minFractionDigits="2" maxFractionDigits="2"/></b></div>
        <div class="line"><span>Loan period</span><b>${loanDays} days</b></div>
        <div class="line"><span>Return by</span><b>${dueDate}</b></div>
        <div class="line total"><span>Total to pay</span><b>&#8377; <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></b></div>
        <div class="note">Late return fine: &#8377; <fmt:formatNumber value="${finePerDay}" minFractionDigits="0" maxFractionDigits="0"/> per day per book after the return date.</div>

        <c:if test="${not tooMany}">
          <h2>Payment Method</h2>
          <div class="methods">
            <div class="method active" data-method="UPI"><span class="ic">&#128241;</span>UPI</div>
            <div class="method" data-method="CARD"><span class="ic">&#128179;</span>Card</div>
            <div class="method" data-method="NETBANKING"><span class="ic">&#127974;</span>Net Banking</div>
          </div>

          <div class="panel show" id="panel-UPI">
            <div class="field"><label for="upiId">UPI ID</label><input type="text" id="upiId" placeholder="yourname@bank" autocomplete="off"></div>
          </div>
          <div class="panel" id="panel-CARD">
            <div class="field"><label for="cardNo">Card Number</label><input type="text" id="cardNo" placeholder="1234 5678 9012 3456" maxlength="19" inputmode="numeric" autocomplete="off"></div>
            <div class="row2">
              <div class="field"><label for="cardExp">Expiry (MM/YY)</label><input type="text" id="cardExp" placeholder="MM/YY" maxlength="5" autocomplete="off"></div>
              <div class="field"><label for="cardCvv">CVV</label><input type="password" id="cardCvv" placeholder="123" maxlength="3" inputmode="numeric" autocomplete="off"></div>
            </div>
          </div>
          <div class="panel" id="panel-NETBANKING">
            <div class="banks">
              <div class="bank" data-bank="SBI">SBI</div><div class="bank" data-bank="HDFC">HDFC</div>
              <div class="bank" data-bank="ICICI">ICICI</div><div class="bank" data-bank="Axis">Axis</div>
            </div>
          </div>

          <div class="errm" id="errMsg"></div>
          <button type="button" class="pay" id="payBtn">Pay &#8377; <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/> &amp; Issue ${count} Book(s)</button>
          <div class="demo">&#9888;&#65039; Demo payment. No real money is charged.<br>Card, UPI and bank details are not sent to the server or stored.</div>

          <form id="payForm" action="${pageContext.request.contextPath}/cart/pay" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="method" id="methodInput" value="UPI">
          </form>
        </c:if>
      </div>
    </div>
  </c:if>
</div>

<div class="overlay" id="procOverlay"><div class="proc"><div class="spin"></div><h3>Processing payment...</h3><p style="color:#64748b;font-size:13px">Please do not close or refresh this page.</p></div></div>

<script>
var current="UPI", selectedBank="", errMsg=document.getElementById("errMsg"), paying=false;
function $(id){return document.getElementById(id);}
document.querySelectorAll(".method").forEach(function(m){
  m.addEventListener("click",function(){
    document.querySelectorAll(".method").forEach(function(x){x.classList.remove("active");});
    document.querySelectorAll(".panel").forEach(function(p){p.classList.remove("show");});
    m.classList.add("active"); current=m.getAttribute("data-method");
    $("panel-"+current).classList.add("show"); $("methodInput").value=current; errMsg.textContent="";
  });
});
document.querySelectorAll(".bank").forEach(function(b){
  b.addEventListener("click",function(){
    document.querySelectorAll(".bank").forEach(function(x){x.classList.remove("active");});
    b.classList.add("active"); selectedBank=b.getAttribute("data-bank"); errMsg.textContent="";
  });
});
if($("cardNo")){
  $("cardNo").addEventListener("input",function(){var v=this.value.replace(/\D/g,"").substring(0,16);this.value=v.replace(/(.{4})/g,"$1 ").trim();});
  $("cardExp").addEventListener("input",function(){var v=this.value.replace(/\D/g,"").substring(0,4);if(v.length>2)v=v.substring(0,2)+"/"+v.substring(2);this.value=v;});
  $("cardCvv").addEventListener("input",function(){this.value=this.value.replace(/\D/g,"").substring(0,3);});
}
function bad(id,msg){$(id).classList.add("bad");errMsg.textContent=msg;return false;}
function validate(){
  document.querySelectorAll(".field input").forEach(function(i){i.classList.remove("bad");});
  errMsg.textContent="";
  if(current==="UPI"){ if(!/^[a-zA-Z0-9.\-_]{2,}@[a-zA-Z]{2,}$/.test($("upiId").value.trim())) return bad("upiId","Enter a valid UPI ID, e.g. name@bank"); }
  if(current==="CARD"){
    if($("cardNo").value.replace(/\s/g,"").length!==16) return bad("cardNo","Enter a valid 16 digit card number.");
    var m=/^(\d{2})\/(\d{2})$/.exec($("cardExp").value);
    if(!m||+m[1]<1||+m[1]>12) return bad("cardExp","Enter expiry as MM/YY.");
    if(new Date(2000+(+m[2]),+m[1],1)<=new Date()) return bad("cardExp","This card has expired.");
    if($("cardCvv").value.length!==3) return bad("cardCvv","Enter the 3 digit CVV.");
  }
  if(current==="NETBANKING"&&!selectedBank){errMsg.textContent="Please select your bank.";return false;}
  return true;
}
if($("payBtn")){
  $("payBtn").addEventListener("click",function(){
    if(paying||!validate()) return;
    paying=true; $("procOverlay").classList.add("show");
    setTimeout(function(){$("payForm").submit();},1800);
  });
}
</script>
</body>
</html>
