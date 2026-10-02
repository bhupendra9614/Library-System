<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>My Shelf | Library</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{--bg:#0b1020;--glass:rgba(255,255,255,.06);--line:rgba(255,255,255,.12);--txt:#e8ecf8;--mut:#9aa6c4;--acc:#7c9cff;--ok:#34d399;--bad:#fb7185;--warn:#fbbf24}
body{font-family:"Segoe UI",Arial,sans-serif;color:var(--txt);min-height:100vh;
  background:radial-gradient(900px 500px at 85% -10%,#2b3a8a55,transparent),radial-gradient(700px 500px at -10% 110%,#0f766e44,transparent),var(--bg)}
a{color:inherit}
:focus-visible{outline:3px solid var(--warn);outline-offset:2px}

.nav{display:flex;justify-content:space-between;align-items:center;padding:16px 6%;border-bottom:1px solid var(--line);backdrop-filter:blur(10px);position:sticky;top:0;z-index:5;background:rgba(11,16,32,.75)}
.brand{font-weight:700;text-decoration:none;font-size:18px}
.nav nav{display:flex;gap:6px;flex-wrap:wrap}
.nav nav a{text-decoration:none;color:var(--mut);padding:8px 14px;border-radius:999px;font-size:14px}
.nav nav a:hover{color:#fff;background:var(--glass)}.nav nav a.on{background:var(--acc);color:#0b1020;font-weight:700}

.layout{max-width:1200px;margin:30px auto 60px;padding:0 5%;display:grid;grid-template-columns:300px 1fr;gap:26px;align-items:start}

/* profile side */
.side{background:var(--glass);border:1px solid var(--line);border-radius:22px;padding:26px 22px;position:sticky;top:90px}
.av{width:78px;height:78px;border-radius:50%;display:grid;place-items:center;font:700 32px Georgia,serif;margin:0 auto 12px;
  background:linear-gradient(135deg,#7c9cff,#34d399);color:#0b1020}
.side h2{text-align:center;font-size:19px}.side .role{text-align:center;color:var(--mut);font-size:13px;margin:2px 0 18px}
.slots{display:flex;justify-content:center;gap:10px;margin-bottom:6px}
.slot{width:34px;height:46px;border-radius:5px 9px 9px 5px;border:2px dashed var(--line)}
.slot.f{border:0;background:linear-gradient(145deg,#7c9cff,#6366f1);box-shadow:0 6px 14px rgba(99,102,241,.4)}
.slots-t{text-align:center;color:var(--mut);font-size:12.5px;margin-bottom:18px}
.row{display:flex;justify-content:space-between;padding:11px 0;border-top:1px solid var(--line);font-size:14px;color:var(--mut)}
.row b{color:var(--txt)}.row b.bad{color:var(--bad)}.row b.ok{color:var(--ok)}
.side .go{display:block;text-align:center;margin-top:16px;padding:12px;border-radius:12px;background:var(--acc);color:#0b1020;font-weight:700;text-decoration:none;font-size:14px}
.side .go.alt{background:transparent;color:var(--txt);border:1px solid var(--line);margin-top:8px}

/* main */
.head h1{font-size:28px}.head p{color:var(--mut);font-size:14px;margin:4px 0 18px}
.msg{padding:12px 16px;border-radius:12px;margin-bottom:14px;font-size:14px}
.msg.ok{background:#34d39922;color:#6ee7b7;border:1px solid #34d39955}.msg.err{background:#fb718522;color:#fda4af;border:1px solid #fb718555}
.tabs{display:inline-flex;background:var(--glass);border:1px solid var(--line);border-radius:999px;padding:4px;margin-bottom:20px}
.tabs button{border:0;background:transparent;color:var(--mut);padding:9px 20px;border-radius:999px;font-size:14px;font-weight:600;cursor:pointer}
.tabs button.on{background:var(--acc);color:#0b1020}
.pane{display:none}.pane.on{display:block}

.tk{display:grid;grid-template-columns:96px 1fr 104px;gap:20px;align-items:center;background:var(--glass);border:1px solid var(--line);border-radius:20px;padding:18px 20px;margin-bottom:16px;position:relative}
.tk::before,.tk::after{content:"";position:absolute;right:134px;width:18px;height:18px;border-radius:50%;background:var(--bg);border:1px solid var(--line)}
.tk::before{top:-10px}.tk::after{bottom:-10px}
.cv{position:relative;width:96px;height:138px;border-radius:5px 10px 10px 5px;overflow:hidden;background:linear-gradient(145deg,#6366f1,#0ea5e9);box-shadow:6px 8px 18px rgba(0,0,0,.45)}
.cv .t{position:absolute;inset:0;padding:10px 8px;font:700 12px/1.25 Georgia,serif;color:#fff;overflow:hidden}
.cv img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;background:#fff}
.inf h3{font-size:18px;word-break:break-word}.inf .au{color:var(--mut);font-size:13px;margin:2px 0 12px}
.dts{display:flex;gap:22px;flex-wrap:wrap;font-size:12.5px;color:var(--mut);margin-bottom:12px}.dts b{display:block;color:var(--txt);font-size:14px}
.fine{font-size:13px;color:var(--mut)}.fine b{color:var(--bad)}
.ret{margin-top:12px;border:1px solid var(--ok);background:transparent;color:var(--ok);padding:9px 18px;border-radius:999px;font-size:13px;font-weight:700;cursor:pointer}
.ret:hover{background:var(--ok);color:#06281c}
.ring{position:relative;width:104px;height:104px;text-align:center}
.ring svg{transform:rotate(-90deg)}
.ring circle{fill:none;stroke-width:8}
.ring .bg{stroke:var(--line)}.ring .fg{stroke:var(--acc);stroke-linecap:round;transition:stroke-dashoffset .8s}
.ring.late .fg{stroke:var(--bad)}.ring.soon .fg{stroke:var(--warn)}
.ring .n{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center}
.ring .n b{font-size:26px;line-height:1}.ring .n span{font-size:11px;color:var(--mut);margin-top:3px}
.ring.late .n b{color:var(--bad)}

.tl{border-left:2px solid var(--line);margin-left:8px;padding-left:22px}
.ev{position:relative;background:var(--glass);border:1px solid var(--line);border-radius:14px;padding:14px 18px;margin-bottom:12px;display:flex;justify-content:space-between;gap:14px;flex-wrap:wrap}
.ev::before{content:"";position:absolute;left:-30px;top:20px;width:12px;height:12px;border-radius:50%;background:var(--ok);box-shadow:0 0 0 4px var(--bg)}
.ev b{display:block}.ev span{color:var(--mut);font-size:12.5px}.ev .f{text-align:right}
.empty{text-align:center;padding:50px 20px;background:var(--glass);border:1px dashed var(--line);border-radius:20px;color:var(--mut)}
.empty .big{font-size:44px}.empty a{display:inline-block;margin-top:14px;background:var(--acc);color:#0b1020;font-weight:700;text-decoration:none;padding:11px 24px;border-radius:999px;font-size:14px}

@media(max-width:900px){.layout{grid-template-columns:1fr}.side{position:static}}
@media(max-width:560px){.tk{grid-template-columns:80px 1fr}.ring{grid-column:1/-1;margin:0 auto}.tk::before,.tk::after{display:none}.cv{width:80px;height:116px}}
@media(prefers-reduced-motion:reduce){.ring .fg{transition:none}}
</style>
</head>
<body>

<c:set var="activeCnt" value="0"/><c:set var="returnedCnt" value="0"/><c:set var="fineDue" value="0"/>
<c:forEach var="i" items="${issues}">
  <c:choose>
    <c:when test="${i.status == 'RETURNED'}"><c:set var="returnedCnt" value="${returnedCnt + 1}"/></c:when>
    <c:otherwise><c:set var="activeCnt" value="${activeCnt + 1}"/><c:set var="fineDue" value="${fineDue + i.liveFine}"/></c:otherwise>
  </c:choose>
</c:forEach>

<header class="nav">
  <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library</a>
  <nav>
    <a href="${pageContext.request.contextPath}/">Home</a>
    <a href="${pageContext.request.contextPath}/explore">Explore</a>
    <a href="${pageContext.request.contextPath}/cart">Cart (${cartCount})</a>
    <a class="on" href="${pageContext.request.contextPath}/issues/my">My Shelf</a>
  </nav>
</header>

<div class="layout">

  <aside class="side">
    <div class="av" id="avatar">?</div>
    <h2 id="uname"><sec:authentication property="name"/></h2>
    <div class="role">Library member</div>

    <div class="slots" aria-hidden="true">
      <c:forEach begin="1" end="3" var="n"><div class="slot ${n <= activeCnt ? 'f' : ''}"></div></c:forEach>
    </div>
    <div class="slots-t">${activeCnt} of 3 shelf slots used</div>

    <div class="row"><span>Next due</span><b id="nextDue">-</b></div>
    <div class="row"><span>Fine due</span><b class="${fineDue > 0 ? 'bad' : 'ok'}">&#8377; ${fineDue}</b></div>
    <div class="row"><span>Books returned</span><b>${returnedCnt}</b></div>

    <a class="go" href="${pageContext.request.contextPath}/explore">Find more books</a>
    <a class="go alt" href="${pageContext.request.contextPath}/cart">Open cart (${cartCount})</a>
  </aside>

  <main>
    <div class="head">
      <h1>My Shelf</h1>
      <p>Books you are reading, how long you have left, and everything you returned.</p>
    </div>

    <c:if test="${not empty success}"><div class="msg ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="msg err"><c:out value="${error}"/></div></c:if>

    <div class="tabs" role="tablist">
      <button type="button" class="on" data-pane="reading" role="tab">Reading now (${activeCnt})</button>
      <button type="button" data-pane="history" role="tab">History (${returnedCnt})</button>
    </div>

    <section class="pane on" id="pane-reading">
      <c:if test="${activeCnt == 0}">
        <div class="empty"><div class="big">&#128214;</div>Your shelf is empty right now.<br>
          <a href="${pageContext.request.contextPath}/explore">Explore Books</a></div>
      </c:if>

      <c:forEach var="i" items="${issues}">
        <c:if test="${i.status != 'RETURNED'}">
          <article class="tk" data-issued="${i.issueDate}" data-due="${i.dueDate}">
            <div class="cv">
              <div class="t"><c:out value="${i.book.title}"/></div>
              <c:if test="${not empty i.book.isbn}">
                <img loading="lazy" alt="" src="https://covers.openlibrary.org/b/isbn/${fn:replace(fn:replace(i.book.isbn,'-',''),' ','')}-M.jpg?default=false" onerror="this.remove()">
              </c:if>
            </div>
            <div class="inf">
              <h3><c:out value="${i.book.title}"/></h3>
              <div class="au"><c:out value="${i.book.author}"/> &bull; <c:out value="${i.book.category}"/></div>
              <div class="dts">
                <div>Issued<b>${i.issueDate}</b></div>
                <div>Due<b>${i.dueDate}</b></div>
              </div>
              <div class="fine">Fine so far: <b>&#8377; ${i.liveFine}</b></div>
              <form action="${pageContext.request.contextPath}/issues/return/${i.id}" method="post" onsubmit="return confirm('Return this book now?');">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="ret">Return book</button>
              </form>
            </div>
            <div class="ring" aria-label="Days left">
              <svg width="104" height="104" viewBox="0 0 104 104"><circle class="bg" cx="52" cy="52" r="44"/><circle class="fg" cx="52" cy="52" r="44" stroke-dasharray="276.5" stroke-dashoffset="276.5"/></svg>
              <div class="n"><b>-</b><span>days left</span></div>
            </div>
          </article>
        </c:if>
      </c:forEach>
    </section>

    <section class="pane" id="pane-history">
      <c:if test="${returnedCnt == 0}"><div class="empty">Nothing returned yet.</div></c:if>
      <div class="tl">
        <c:forEach var="i" items="${issues}">
          <c:if test="${i.status == 'RETURNED'}">
            <div class="ev">
              <div><b><c:out value="${i.book.title}"/></b><span><c:out value="${i.book.author}"/></span></div>
              <div><span>${i.issueDate} &rarr; ${i.returnDate}</span></div>
              <div class="f"><span>Fine paid</span><b>&#8377; ${i.fineAmount}</b></div>
            </div>
          </c:if>
        </c:forEach>
      </div>
    </section>
  </main>
</div>

<script>
var nm=document.getElementById('uname').textContent.trim();
document.getElementById('avatar').textContent=nm?nm.charAt(0).toUpperCase():'?';

document.querySelectorAll('.tabs button').forEach(function(b){
  b.addEventListener('click',function(){
    document.querySelectorAll('.tabs button').forEach(function(x){x.classList.remove('on');});
    document.querySelectorAll('.pane').forEach(function(p){p.classList.remove('on');});
    b.classList.add('on'); document.getElementById('pane-'+b.dataset.pane).classList.add('on');
  });
});

function d(s){var p=s.split('-');return new Date(+p[0],+p[1]-1,+p[2]);}
var today=new Date(); today.setHours(0,0,0,0);
var C=276.5, nearest=null;
document.querySelectorAll('.tk').forEach(function(el){
  var iss=d(el.dataset.issued), due=d(el.dataset.due);
  var total=Math.max(1,Math.round((due-iss)/864e5)), left=Math.round((due-today)/864e5);
  var ring=el.querySelector('.ring'), n=ring.querySelector('.n');
  if(left<0){ ring.classList.add('late'); n.innerHTML='<b>'+(-left)+'</b><span>days overdue</span>'; ring.querySelector('.fg').style.strokeDashoffset=0; }
  else {
    if(left<=3) ring.classList.add('soon');
    n.innerHTML='<b>'+left+'</b><span>'+(left===1?'day left':'days left')+'</span>';
    ring.querySelector('.fg').style.strokeDashoffset=C*(1-Math.min(1,left/total));
  }
  if(nearest===null||due<nearest) nearest=due;
});
if(nearest){ document.getElementById('nextDue').textContent=nearest.toLocaleDateString('en-IN',{day:'2-digit',month:'short'}); }
</script>
</body>
</html>
