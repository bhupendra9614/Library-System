<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<title>Search Books | Library</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f1f5f9;
    color: #0f172a;
    min-height: 100vh;
}

/* TOP BAR */
.topbar {
    background: #0f172a;
    padding: 0 6%;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.brand { color: #fff; font-weight: 700; font-size: 18px; text-decoration: none; display: flex; gap: 10px; align-items: center; }
.top-links { display: flex; gap: 8px; }
.top-links a {
    color: #cbd5e1; text-decoration: none; font-size: 14px;
    padding: 8px 14px; border-radius: 8px; transition: 0.2s;
}
.top-links a:hover { background: #1e293b; color: #fff; }
.top-links a.active { background: #2563eb; color: #fff; }

/* SEARCH HERO */
.search-hero {
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%);
    padding: 55px 6% 75px;
    text-align: center;
    color: #fff;
}
.search-hero h1 { font-size: 34px; margin-bottom: 8px; }
.search-hero p { color: #bfdbfe; font-size: 15px; margin-bottom: 28px; }

.search-form {
    max-width: 680px;
    margin: auto;
    display: flex;
    background: #fff;
    border-radius: 14px;
    padding: 7px;
    box-shadow: 0 20px 45px rgba(0,0,0,0.30);
}
.search-form .icon { padding: 0 14px; display: flex; align-items: center; font-size: 18px; }
.search-form input {
    flex: 1; border: none; outline: none; font-size: 16px; color: #0f172a; background: transparent;
}
.btn-search {
    border: none; cursor: pointer; background: #2563eb; color: #fff;
    padding: 13px 28px; border-radius: 10px; font-size: 15px; font-weight: 600; transition: 0.2s;
}
.btn-search:hover { background: #1d4ed8; }
.btn-clear {
    text-decoration: none; display: flex; align-items: center;
    color: #64748b; font-size: 13px; padding: 0 14px;
}
.btn-clear:hover { color: #dc2626; }

/* CONTENT */
.content { max-width: 1150px; margin: -35px auto 50px; padding: 0 5%; }

.msg { padding: 12px 16px; border-radius: 10px; margin-bottom: 18px; font-size: 14px; }
.msg.ok  { background: #dcfce7; color: #166534; }
.msg.ok a { color: #166534; font-weight: 700; margin-left: 8px; }
.msg.err { background: #fee2e2; color: #991b1b; }

.result-bar {
    background: #fff; border-radius: 12px; padding: 16px 20px;
    display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;
    box-shadow: 0 4px 14px rgba(15,23,42,0.08); margin-bottom: 22px;
}
.result-bar .count { font-size: 15px; color: #334155; }
.result-bar .count b { color: #2563eb; }

.filters { display: flex; gap: 8px; }
.chip {
    border: 1px solid #cbd5e1; background: #fff; color: #475569;
    padding: 7px 15px; border-radius: 20px; font-size: 13px; cursor: pointer; transition: 0.2s;
}
.chip:hover { border-color: #2563eb; color: #2563eb; }
.chip.active { background: #2563eb; border-color: #2563eb; color: #fff; }

/* CARDS */
.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; }

.card {
    background: #fff; border-radius: 14px; padding: 22px;
    border: 1px solid #e2e8f0; display: flex; flex-direction: column;
    transition: transform 0.25s, box-shadow 0.25s;
}
.card:hover { transform: translateY(-5px); box-shadow: 0 14px 30px rgba(15,23,42,0.12); }

.card-top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 12px; }
.category { background: #eff6ff; color: #2563eb; font-size: 11px; font-weight: 700; padding: 5px 10px; border-radius: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
.badge { font-size: 11px; font-weight: 700; padding: 5px 10px; border-radius: 20px; }
.badge.yes { background: #dcfce7; color: #15803d; }
.badge.no  { background: #fee2e2; color: #b91c1c; }

.card h3 { font-size: 18px; margin-bottom: 4px; }
.card .author { color: #64748b; font-size: 14px; margin-bottom: 14px; }

.meta { display: flex; justify-content: space-between; border-top: 1px dashed #e2e8f0; padding-top: 12px; font-size: 13px; color: #475569; margin-bottom: 16px; }
.meta .price { font-weight: 700; color: #0f172a; font-size: 16px; }

.actions { display: flex; gap: 8px; margin-top: auto; }
.actions a, .actions button {
    flex: 1; text-align: center; text-decoration: none; border: none; cursor: pointer;
    padding: 10px 0; border-radius: 8px; font-size: 13px; font-weight: 600; transition: 0.2s;
}
.actions form { flex: 1; display: flex; }
.actions form button { width: 100%; }
.b-view { background: #f1f5f9; color: #334155; }
.b-view:hover { background: #e2e8f0; }
.b-edit { background: #2563eb; color: #fff; }
.b-edit:hover { background: #1d4ed8; }
.b-cart { background: #16a34a; color: #fff; }
.b-cart:hover { background: #15803d; }
.b-incart { background: #dcfce7; color: #166534; }
.b-del { background: #fff; color: #dc2626; border: 1px solid #fecaca !important; }
.b-del:hover { background: #dc2626; color: #fff; }


#toast{position:fixed;left:50%;bottom:28px;transform:translateX(-50%) translateY(20px);padding:12px 20px;border-radius:10px;
       font-size:14px;color:#fff;opacity:0;pointer-events:none;transition:.25s;z-index:100;max-width:90%}
#toast.show{opacity:1;transform:translateX(-50%) translateY(0)}
#toast.good{background:#166534}#toast.bad{background:#991b1b}

/* EMPTY STATES */
.state {
    background: #fff; border-radius: 14px; padding: 60px 20px; text-align: center;
    border: 1px dashed #cbd5e1;
}
.state .big { font-size: 48px; margin-bottom: 10px; }
.state h3 { margin-bottom: 6px; }
.state p { color: #64748b; font-size: 14px; margin-bottom: 20px; }
.state a {
    display: inline-block; text-decoration: none; background: #16a34a; color: #fff;
    padding: 11px 22px; border-radius: 8px; font-size: 14px; font-weight: 600;
}

@media (max-width: 600px) {
    .search-hero h1 { font-size: 26px; }
    .btn-clear { display: none; }
    .top-links a { padding: 8px 9px; font-size: 13px; }
}
</style>
</head>

<body>

<!-- TOP BAR -->
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/">&#128218; Library Management</a>
    <nav class="top-links">
        <a href="${pageContext.request.contextPath}/">Home</a>
        <a href="${pageContext.request.contextPath}/explore">Explore</a>
        <a href="${pageContext.request.contextPath}/cart">&#128722; Cart (<span class="cart-count">${cartCount}</span>)</a>
        <a href="${pageContext.request.contextPath}/issues/my">My Books</a>
        <a class="active" href="${pageContext.request.contextPath}/books/search">Search</a>
        <sec:authorize access="hasRole('ADMIN')">
            <a href="${pageContext.request.contextPath}/books/add">+ Add Book</a>
        </sec:authorize>
    </nav>
</header>

<!-- SEARCH HERO -->
<section class="search-hero">
    <h1>Find Any Book Instantly</h1>
    <p>Search the library by book title or author name</p>

    <form class="search-form"
          action="${pageContext.request.contextPath}/books/search"
          method="get">
        <span class="icon">&#128269;</span>
        <input type="text" name="keyword" value="<c:out value='${keyword}'/>"
               placeholder="e.g. Java, Harry Potter, Chetan Bhagat" required autofocus>
        <c:if test="${not empty keyword}">
            <a class="btn-clear" href="${pageContext.request.contextPath}/books/search">&#10005; Clear</a>
        </c:if>
        <button class="btn-search" type="submit">Search</button>
    </form>
</section>

<!-- RESULTS -->
<main class="content">

    <c:if test="${not empty success}">
        <div class="msg ok"><c:out value="${success}"/> <a href="${pageContext.request.contextPath}/cart">View cart</a></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="msg err"><c:out value="${error}"/></div>
    </c:if>

    <!-- After search -->
    <c:if test="${searched}">

        <div class="result-bar">
            <div class="count">
                <c:choose>
                    <c:when test="${empty keyword}">
                        <b>${books.size()}</b> book(s) in the library
                    </c:when>
                    <c:otherwise>
                        <b>${books.size()}</b> result(s) for
                        "<b><c:out value="${keyword}"/></b>"
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty books}">
                <div class="filters">
                    <button type="button" class="chip active" data-filter="all">All</button>
                    <button type="button" class="chip" data-filter="yes">Available</button>
                    <button type="button" class="chip" data-filter="no">Not Available</button>
                </div>
            </c:if>
        </div>

        <c:if test="${empty books}">
            <div class="state">
                <div class="big">&#128533;</div>
                <h3>No books found</h3>
                <p>We couldn't find anything matching your search. Try another keyword or add this book.</p>
                <a href="${pageContext.request.contextPath}/books/add">+ Add New Book</a>
            </div>
        </c:if>

        <div class="grid">
            <c:forEach var="book" items="${books}">
                <div class="card" data-status="${book.available ? 'yes' : 'no'}">

                    <div class="card-top">
                        <span class="category"><c:out value="${book.category}"/></span>
                        <c:choose>
                            <c:when test="${book.available}">
                                <span class="badge yes">&#9679; Available</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge no">&#9679; Not Available</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h3><c:out value="${book.title}"/></h3>
                    <div class="author">by <c:out value="${book.author}"/></div>

                    <div class="meta">
                        <span>ISBN: <c:out value="${book.isbn}"/></span>
                        <span class="price">&#8377; <c:out value="${book.price}"/></span>
                    </div>

                    <div class="actions">
                        <a class="b-view" href="${pageContext.request.contextPath}/books/${book.id}">View</a>
                        <c:if test="${book.available}">
                            <c:choose>
                                <c:when test="${cartIds.contains(book.id)}">
                                    <a class="b-incart" href="${pageContext.request.contextPath}/cart">In Cart &#10003;</a>
                                </c:when>
                                <c:otherwise>
                                    <form class="cartform" data-id="${book.id}" data-done="b-incart" data-cart="${pageContext.request.contextPath}/cart"
                                          data-api="${pageContext.request.contextPath}/cart/api/add/${book.id}"
                                          action="${pageContext.request.contextPath}/cart/add/${book.id}" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="b-cart">Add to Cart</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <sec:authorize access="hasRole('ADMIN')">
                        <a class="b-edit" href="${pageContext.request.contextPath}/books/edit/${book.id}">Edit</a>
                        <form action="${pageContext.request.contextPath}/books/delete/${book.id}"
                              method="post"
                              onsubmit="return confirm('Delete this book permanently?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="b-del">Delete</button>
                        </form>
                        </sec:authorize>
                    </div>

                </div>
            </c:forEach>
        </div>

    </c:if>
</main>


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
var chips = document.querySelectorAll(".chip");
var cards = document.querySelectorAll(".card");

chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
        chips.forEach(function (c) { c.classList.remove("active"); });
        chip.classList.add("active");

        var f = chip.getAttribute("data-filter");
        cards.forEach(function (card) {
            card.style.display =
                (f === "all" || card.getAttribute("data-status") === f) ? "flex" : "none";
        });
    });
});
</script>

</body>
</html>
