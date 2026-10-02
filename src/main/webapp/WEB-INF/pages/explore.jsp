<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<title>Explore Books</title>
<style>
  :root{ --blue:#1565c0; --blue-d:#0f4f9a; --link:#0b4f9c; --sand:#e5dfcb; --row:#f4f1ea; --ink:#222; --muted:#6b6455; }
  *{box-sizing:border-box}
  html{scroll-behavior:smooth}
  body{margin:0;background:var(--sand);color:var(--ink);font-family:"Lato","Segoe UI",system-ui,sans-serif}
  :focus-visible{outline:3px solid #f2a900;outline-offset:2px}
  .page{max-width:1500px;margin:0 auto;background:#fff;min-height:100vh;box-shadow:0 0 0 1px #d8d0b8}

  /* top bar */
  .top{position:sticky;top:0;z-index:20;display:flex;gap:12px;align-items:center;flex-wrap:wrap;
       padding:12px 28px;background:#fff;border-bottom:1px solid #e1dccb}
  .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 18px;border-radius:6px;border:0;
       font:600 15px inherit;background:var(--blue);color:#fff;text-decoration:none;cursor:pointer}
  .btn:hover{background:var(--blue-d)}
  .btn.ghost{background:#fff;color:var(--link);border:1px solid #b9c9dc}
  .btn.ghost:hover{background:#eef4fb}
  .btn.add{background:#1f8a4c}.btn.add:hover{background:#17703d}
  .btn.off{background:#cfcab9;color:#5d5748;cursor:not-allowed}
  .search{flex:1;min-width:240px;display:flex}
  .search input{flex:1;padding:11px 14px;border:1px solid #b9c9dc;border-right:0;border-radius:6px 0 0 6px;font-size:15px}
  .search .btn{border-radius:0 6px 6px 0}

  .btns{display:flex;gap:2px;width:210px}
  .btns form{flex:1;display:flex;margin:0;min-width:0}
  .item .btns .btn{height:46px;font-size:15px;padding:0 6px;width:auto;flex:1;min-width:0;white-space:nowrap}
  .item .btns form .btn{width:100%}
  .item .btns .btn.view{flex:0 0 74px;background:var(--blue);color:#fff;border:0}
  .item .btns .btn.view:hover{background:var(--blue-d)}
  .btn.incart{background:#dcfce7;color:#166534}
  dialog#info{border:0;border-radius:14px;padding:0;width:min(560px,92vw);box-shadow:0 20px 60px rgba(0,0,0,.4)}
  dialog#info::backdrop{background:rgba(15,23,42,.6)}
  .dlg{display:flex;gap:20px;padding:24px}
  .dlg .pic{position:relative;flex:0 0 130px;height:190px;border-radius:6px;overflow:hidden;background:linear-gradient(145deg,#3b82f6,#1d4ed8);box-shadow:0 4px 12px rgba(0,0,0,.3)}
  .dlg .pic img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;background:#fff}
  .dlg h3{font:700 22px Georgia,serif;margin:0 0 4px}.dlg .by{color:var(--muted);margin-bottom:14px}
  .dlg dl{display:grid;grid-template-columns:96px 1fr;gap:8px 10px;margin:0;font-size:14px}
  .dlg dt{color:var(--muted)}.dlg dd{margin:0;font-weight:600;word-break:break-word}
  .dlg .st{display:inline-block;padding:3px 10px;border-radius:20px;font-size:12px;font-weight:700}
  .st.y{background:#dcfce7;color:#166534}.st.n{background:#fee2e2;color:#991b1b}
  .dlg-foot{display:flex;justify-content:flex-end;gap:10px;padding:0 24px 20px}
  @media(max-width:560px){.dlg{flex-direction:column;align-items:center}.dlg dl{width:100%}}

  #toast{position:fixed;left:50%;bottom:28px;transform:translateX(-50%) translateY(20px);padding:12px 20px;border-radius:10px;
         font-size:14px;color:#fff;opacity:0;pointer-events:none;transition:.25s;z-index:100;max-width:90%}
  #toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
  #toast.good{background:#166534}#toast.bad{background:#991b1b}
  .wrap{padding:0 28px 40px}
  .flash{margin-top:16px;padding:12px 16px;border-radius:8px;font-size:15px}
  .flash.ok{background:#dcfce7;color:#166534}.flash.ok a{color:#166534;font-weight:700;margin-left:8px}
  .flash.err{background:#fee2e2;color:#991b1b}
    .head{font:400 24px Georgia,"Times New Roman",serif;margin:0;padding:26px 0 14px}
  .head a{color:var(--link)}
  .empty{padding:70px 0;text-align:center;color:var(--muted)}

  /* browse by subject */
  .subjects{position:relative;margin:0 -28px;padding:0 70px 28px}
  .subj-row{display:flex;gap:10px;overflow-x:auto;scroll-behavior:smooth;scrollbar-width:none}
  .subj-row::-webkit-scrollbar{display:none}
  .subj{flex:0 0 190px;text-align:center;text-decoration:none;color:var(--ink);padding:6px}
  .subj i{display:grid;place-items:center;width:48px;height:48px;margin:0 auto 8px;border-radius:50%;
          background:#fbe3e1;font-style:normal;font-size:24px}
  .subj:nth-child(8n+1) i::before{content:"\1F3A8"}
  .subj:nth-child(8n+2) i::before{content:"\1F6F8"}
  .subj:nth-child(8n+3) i::before{content:"\1F984"}
  .subj:nth-child(8n+4) i::before{content:"\1F4D5"}
  .subj:nth-child(8n+5) i::before{content:"\1F374"}
  .subj:nth-child(8n+6) i::before{content:"\1F339"}
  .subj:nth-child(8n+7) i::before{content:"\1F50D"}
  .subj:nth-child(8n+8) i::before{content:"\1F680"}
  .subj b{display:block;font:400 20px Georgia,serif}
  .subj small{font:italic 15px Georgia,serif;color:var(--muted)}
  .subj:hover b{text-decoration:underline}

  /* shelves */
  .shelf{margin:0 -28px;border-top:1px solid #e1dccb}
  .shelf .head{padding:22px 28px 14px;background:#fff}
  .shelf-body{position:relative;background:var(--row);padding:26px 70px 26px}
  .row{display:flex;gap:34px;overflow-x:auto;scroll-snap-type:x proximity;scroll-behavior:smooth;scrollbar-width:none;padding:2px}
  .row::-webkit-scrollbar,.subj-row::-webkit-scrollbar{display:none}
  .item{flex:0 0 210px;scroll-snap-align:start;display:flex;flex-direction:column;align-items:center;gap:12px}
  .cover{position:relative;width:170px;height:260px;display:flex;align-items:flex-end;border-radius:6px;overflow:hidden;
         box-shadow:0 3px 10px rgba(0,0,0,.35);color:#fff}
  .cover .fb{position:absolute;inset:0;padding:16px 14px;display:flex;flex-direction:column;justify-content:space-between;
             box-shadow:inset 7px 0 0 rgba(0,0,0,.18)}
  .cover .fb b{font:700 18px/1.25 Georgia,serif;display:-webkit-box;-webkit-line-clamp:6;-webkit-box-orient:vertical;overflow:hidden}
  .cover .fb span{font-size:13px;opacity:.92}
  .cover img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;background:#fff}
  .c0{background:#7a2e2e}.c1{background:#1d4e6b}.c2{background:#2f6b3c}.c3{background:#5b3a7a}
  .c4{background:#8a5a14}.c5{background:#1f5f5b}.c6{background:#3d3d6b}.c7{background:#6b2f55}
  .item .btn{width:210px;height:48px;font-size:17px;font-weight:500;border-radius:7px}
  .arrow{position:absolute;top:130px;width:46px;height:46px;border-radius:50%;border:0;color:#fff;font-size:30px;line-height:1;
         cursor:pointer;display:grid;place-items:center;padding-bottom:4px}
  .arrow.l{left:18px;background:#b6d4ea}.arrow.r{right:18px;background:#3b8fc8}
  .arrow:hover{filter:brightness(.92)}
  .subjects .arrow{top:22px}

  /* around the library */
  .around{padding-top:12px;border-top:1px solid #e1dccb}
  .head small{font:400 16px "Lato","Segoe UI",sans-serif;color:var(--muted);margin-left:8px}
  .stats{display:grid;grid-template-columns:repeat(4,1fr);gap:28px;padding-bottom:30px}
  .stat{display:flex;flex-direction:column;gap:2px}
  .stat .bar{height:90px;background:linear-gradient(to top,var(--c) var(--p),#ece8da var(--p));border-radius:3px 3px 0 0}
  .stat strong{font:700 34px Georgia,serif;margin-top:8px}
  .stat span{font-size:14px;color:var(--muted);text-transform:none}
  .rules{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;padding-bottom:10px}
  .rules div{background:var(--row);border-radius:8px;padding:18px}
  .rules strong{display:block;font:700 22px Georgia,serif;color:var(--link);margin-bottom:6px}
  .rules span{font-size:14px;line-height:1.5;color:#4b4638}
  @media (max-width:900px){ .stats,.rules{grid-template-columns:repeat(2,1fr)} }

  @media (max-width:700px){
    .wrap{padding:0 14px 30px}.top{padding:10px 14px}
    .subjects,.shelf{margin:0 -14px}.subjects{padding:0 14px 20px}
    .shelf .head{padding:18px 14px 12px}.shelf-body{padding:18px 14px}
    .arrow{display:none}.item{flex-basis:170px}.item .btn{width:170px}.btns{width:170px}.cover{width:150px;height:230px}
    .item .btns .btn{font-size:13px;padding:0 4px}.item .btns .btn.view{flex-basis:56px}
  }
  @media (prefers-reduced-motion:reduce){ html,.row,.subj-row{scroll-behavior:auto} }
</style>
</head>
<body>
<div class="page">

<header class="top">
  <a class="btn ghost" href="${pageContext.request.contextPath}/">Home</a>
  <form class="search" action="${pageContext.request.contextPath}/books/search" method="get" role="search">
    <input type="search" name="keyword" placeholder="Search by title or author" aria-label="Search books">
    <button class="btn" type="submit">Search</button>
  </form>
  <a class="btn ghost" href="${pageContext.request.contextPath}/books/search">View Books</a>
  <a class="btn ghost" href="${pageContext.request.contextPath}/cart">&#128722; Cart (<span class="cart-count">${cartCount}</span>)</a>
  <a class="btn ghost" href="${pageContext.request.contextPath}/issues/my">My Books</a>
  <sec:authorize access="hasRole('ADMIN')">
    <a class="btn add" href="${pageContext.request.contextPath}/books/add">Add Book</a>
  </sec:authorize>
</header>

<div class="wrap">

<c:if test="${not empty success}"><div class="flash ok"><c:out value="${success}"/> <a href="${pageContext.request.contextPath}/cart">View cart</a></div></c:if>
<c:if test="${not empty error}"><div class="flash err"><c:out value="${error}"/></div></c:if>

<c:if test="${empty categories}">
  <div class="empty">No books yet. Books added by the admin will show up here.</div>
</c:if>


<c:if test="${not empty categories}">
  <h2 class="head"><a href="#">Browse by Subject</a></h2>
  <div class="subjects">
    <button class="arrow l" type="button" aria-label="Scroll left" onclick="slide(this,-1)">&#8249;</button>
    <div class="subj-row">
      <c:forEach var="entry" items="${categories}" varStatus="st">
        <c:if test="${entry.key != 'Available Now'}">
          <a class="subj" href="#shelf-${st.index}">
            <i aria-hidden="true"></i>
            <b><c:out value="${entry.key}"/></b>
            <small>${fn:length(entry.value)} Books</small>
          </a>
        </c:if>
      </c:forEach>
    </div>
    <button class="arrow r" type="button" aria-label="Scroll right" onclick="slide(this,1)">&#8250;</button>
  </div>
</c:if>

<c:forEach var="entry" items="${categories}" varStatus="st">
  <section class="shelf" id="shelf-${st.index}">
    <h2 class="head"><a href="#shelf-${st.index}"><c:out value="${entry.key}"/></a></h2>
    <div class="shelf-body">
      <button class="arrow l" type="button" aria-label="Scroll left" onclick="slide(this,-1)">&#8249;</button>
      <div class="row">
        <c:forEach var="book" items="${entry.value}">
          <article class="item" data-id="${book.id}" data-title="<c:out value='${book.title}'/>" data-author="<c:out value='${book.author}'/>"
                   data-isbn="<c:out value='${book.isbn}'/>" data-category="<c:out value='${book.category}'/>"
                   data-price="<c:out value='${book.price}'/>" data-avail="${book.available}">
            <div class="cover c${book.id % 8}">
              <div class="fb">
                <b><c:out value="${book.title}"/></b>
                <span><c:out value="${book.author}"/></span>
              </div>
              <c:if test="${not empty book.isbn}">
                <img loading="lazy" alt="<c:out value='${book.title}'/> cover"
                     src="https://covers.openlibrary.org/b/isbn/${fn:replace(fn:replace(book.isbn,'-',''),' ','')}-M.jpg?default=false"
                     onerror="this.remove()">
              </c:if>
            </div>
            <div class="btns">
              <c:choose>
                <c:when test="${not book.available}">
                  <span class="btn off" aria-disabled="true">Not Available</span>
                </c:when>
                <c:when test="${cartIds.contains(book.id)}">
                  <a class="btn incart" href="${pageContext.request.contextPath}/cart">In Cart &#10003;</a>
                </c:when>
                <c:otherwise>
                  <form class="cartform" data-id="${book.id}" data-done="btn incart" data-cart="${pageContext.request.contextPath}/cart"
                        data-api="${pageContext.request.contextPath}/cart/api/add/${book.id}"
                        action="${pageContext.request.contextPath}/cart/add/${book.id}" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button class="btn" type="submit">Add to Cart</button>
                  </form>
                </c:otherwise>
              </c:choose>
              <button type="button" class="btn ghost view" onclick="openInfo(this)">View</button>
            </div>
          </article>
        </c:forEach>
      </div>
      <button class="arrow r" type="button" aria-label="Scroll right" onclick="slide(this,1)">&#8250;</button>
    </div>
  </section>
</c:forEach>

<c:if test="${not empty categories}">
  <section class="around">
    <h2 class="head">Around the Library <small>Live numbers from our shelves.</small></h2>
    <div class="stats">
      <div class="stat"><div class="bar" style="--c:#738a35;--p:100%"></div><strong>${totalBooks}</strong><span>Total books</span></div>
      <div class="stat"><div class="bar" style="--c:#1f8a4c;--p:${availablePct}%"></div><strong>${availableBooks}</strong><span>Available now</span></div>
      <div class="stat"><div class="bar" style="--c:#f59e2b;--p:${issuedPct}%"></div><strong>${issuedBooks}</strong><span>Currently issued</span></div>
      <div class="stat"><div class="bar" style="--c:#0f6a6e;--p:100%"></div><strong>${categoryCount}</strong><span>Categories</span></div>
    </div>

    <h2 class="head">How borrowing works</h2>
    <div class="rules">
      <div><strong>14 days</strong><span>Keep each book for 14 days from the issue date.</span></div>
      <div><strong>3 books</strong><span>A member can hold up to 3 books at a time.</span></div>
      <div><strong>Rs 20</strong><span>Flat issue fee per book, paid at checkout.</span></div>
      <div><strong>Rs 5 / day</strong><span>Late fine after the due date. Return from My Books.</span></div>
    </div>
  </section>
</c:if>

</div>
</div>


<dialog id="info" aria-labelledby="dTitle">
  <div class="dlg">
    <div class="pic" id="dPic"></div>
    <div style="flex:1;min-width:0">
      <h3 id="dTitle"></h3>
      <div class="by" id="dAuthor"></div>
      <dl>
        <dt>ISBN</dt><dd id="dIsbn"></dd>
        <dt>Category</dt><dd id="dCat"></dd>
        <dt>Price</dt><dd id="dPrice"></dd>
        <dt>Availability</dt><dd><span class="st" id="dAvail"></span></dd>
        <dt>Loan period</dt><dd>14 days</dd>
        <dt>Issue fee</dt><dd>&#8377; 20 per book</dd>
        <dt>Late fine</dt><dd>&#8377; 5 per day</dd>
      </dl>
    </div>
  </div>
  <div class="dlg-foot">
    <a class="btn ghost" id="dFull" href="#">Full details</a>
    <button type="button" class="btn" onclick="document.getElementById('info').close()">Close</button>
  </div>
</dialog>

<div id="toast" role="status" aria-live="polite"></div>
<script>
(function(){
  var token=document.querySelector('meta[name="_csrf"]').content;
  var header=document.querySelector('meta[name="_csrf_header"]').content;
  var toastEl=document.getElementById('toast'), timer;
  function toast(msg, ok){
    toastEl.textContent=msg; toastEl.className='show '+(ok?'good':'bad');
    clearTimeout(timer); timer=setTimeout(function(){toastEl.className='';},3200);
  }
  document.addEventListener('submit',function(e){
    var f=e.target;
    if(!f.classList||!f.classList.contains('cartform')) return;
    e.preventDefault();
    var btn=f.querySelector('button'); btn.disabled=true;
    var h={'Accept':'application/json'}; h[header]=token;
    fetch(f.getAttribute('data-api'),{method:'POST',headers:h,credentials:'same-origin'})
      .then(function(r){return r.json();})
      .then(function(d){
        toast(d.message,d.ok);
        document.querySelectorAll('.cart-count').forEach(function(c){c.textContent=d.count;});
        if(d.ok){
          document.querySelectorAll('.cartform[data-id="'+f.getAttribute('data-id')+'"]').forEach(function(x){
            var a=document.createElement('a');
            a.className=x.getAttribute('data-done'); a.href=x.getAttribute('data-cart');
            a.style.flex='1'; a.innerHTML='In Cart &#10003;';
            x.replaceWith(a);
          });
        } else { btn.disabled=false; }
      })
      .catch(function(){ f.submit(); });
  });
})();
</script>

<script>
function openInfo(btn){
  var a=btn.closest('.item'), d=a.dataset, $=function(i){return document.getElementById(i);};
  $('dTitle').textContent=d.title; $('dAuthor').textContent='by '+d.author;
  $('dIsbn').textContent=d.isbn; $('dCat').textContent=d.category; $('dPrice').textContent='\u20B9 '+d.price;
  var s=$('dAvail'), yes=d.avail==='true';
  s.textContent=yes?'Available':'Not Available'; s.className='st '+(yes?'y':'n');
  $('dFull').href='${pageContext.request.contextPath}/books/'+d.id;
  var pic=$('dPic'); pic.innerHTML='';
  var isbn=(d.isbn||'').replace(/[- ]/g,'');
  if(isbn){ var im=new Image(); im.alt=''; im.onerror=function(){im.remove();};
    im.src='https://covers.openlibrary.org/b/isbn/'+encodeURIComponent(isbn)+'-M.jpg?default=false'; pic.appendChild(im); }
  $('info').showModal();
}
</script>
<script>
  function slide(btn, dir){
    var row = btn.parentElement.querySelector('.row, .subj-row');
    row.scrollBy({left: dir * row.clientWidth * 0.85});
  }
</script>
</body>
</html>
