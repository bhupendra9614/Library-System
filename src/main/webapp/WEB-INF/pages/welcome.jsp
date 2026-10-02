<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="data:,">
<title>Library Management System</title>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { font-family: "Segoe UI", Arial, sans-serif; background: #f7faff; color: #172033; overflow-x: hidden; }

/* MOUSE FOLLOW LIGHT */
.cursor-light { position: fixed; left: -500px; top: -500px; width: 320px; height: 320px; border-radius: 50%; pointer-events: none;
    background: radial-gradient(circle, rgba(37,99,235,0.12), rgba(37,99,235,0.04) 40%, transparent 70%);
    transform: translate(-50%, -50%); z-index: 0; }

/* NAVBAR */
.navbar { height: 72px; width: 100%; background: rgba(255,255,255,0.92); backdrop-filter: blur(12px); display: flex; align-items: center;
    justify-content: space-between; padding: 0 7%; position: relative; z-index: 10; border-bottom: 1px solid #e7edf7; }
.logo { display: flex; align-items: center; gap: 12px; font-size: 20px; font-weight: 700; color: #14213d; }
.logo-icon { width: 40px; height: 40px; border-radius: 11px; display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #2563eb, #4f46e5); color: white; font-size: 20px; box-shadow: 0 8px 20px rgba(37,99,235,0.25); }
.nav-status { font-size: 13px; color: #64748b; display: flex; align-items: center; gap: 8px; }
.status-dot { width: 8px; height: 8px; background: #22c55e; border-radius: 50%; animation: pulse 1.8s infinite; }
@keyframes pulse {
    0%   { box-shadow: 0 0 0 0 rgba(34,197,94,0.4); }
    70%  { box-shadow: 0 0 0 8px rgba(34,197,94,0); }
    100% { box-shadow: 0 0 0 0 rgba(34,197,94,0); }
}

/* NAV USER */
.nav-user { display: flex; align-items: center; gap: 12px; font-size: 13px; color: #475569; }
.nav-user .who { display: flex; align-items: center; gap: 6px; font-weight: 600; }
.nav-user .role { background: #eaf1ff; color: #2563eb; font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 20px; }
.logout-btn { background: #fff; color: #dc2626; border: 1.5px solid #fca5a5; padding: 7px 14px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: 0.2s; }
.logout-btn:hover { background: #dc2626; color: #fff; }

/* HERO */
.hero { min-height: 520px; display: flex; align-items: center; justify-content: space-between; padding: 65px 9% 50px; position: relative; overflow: hidden; }
.hero-content { max-width: 590px; position: relative; z-index: 2; }
.small-title { display: inline-block; padding: 7px 14px; border-radius: 30px; background: #eaf1ff; color: #2563eb; font-size: 12px;
    font-weight: 700; letter-spacing: 1.2px; margin-bottom: 20px; animation: fadeDown 0.8s ease; }
.hero h1 { font-size: clamp(42px, 5vw, 68px); line-height: 1.08; color: #14213d; margin-bottom: 20px; animation: fadeUp 0.8s ease; }
.hero h1 span { color: #2563eb; }
.hero p { max-width: 540px; font-size: 16px; line-height: 1.8; color: #64748b; margin-bottom: 30px; animation: fadeUp 1s ease; }

.explore-btn { display: inline-flex; align-items: center; gap: 10px; text-decoration: none; padding: 14px 23px; border-radius: 10px;
    background: #2563eb; color: white; font-size: 14px; font-weight: 600; box-shadow: 0 10px 25px rgba(37,99,235,0.22); transition: all 0.3s ease; }
.explore-btn:hover { transform: translateY(-4px); box-shadow: 0 16px 30px rgba(37,99,235,0.30); background: #1d4ed8; }
.explore-btn:focus-visible { outline: 3px solid #93c5fd; outline-offset: 3px; }
.arrow { transition: transform 0.3s ease; }
.explore-btn:hover .arrow { transform: translateX(5px); }

/* HERO BOOK */
.hero-visual { width: 390px; height: 390px; display: flex; align-items: center; justify-content: center; position: relative; z-index: 1; }
.circle-bg { position: absolute; width: 330px; height: 330px; border-radius: 50%; background: linear-gradient(135deg, #eaf1ff, #dbeafe); animation: rotateCircle 15s linear infinite; }
.book { width: 210px; height: 270px; background: linear-gradient(145deg, #2563eb, #4338ca); border-radius: 8px 18px 18px 8px; position: relative; z-index: 2;
    box-shadow: 20px 25px 45px rgba(37,99,235,0.25); transform: perspective(800px) rotateY(-18deg); animation: floatingBook 4s ease-in-out infinite; }
.book::before { content: ""; position: absolute; left: 18px; top: 25px; width: 4px; height: 220px; background: rgba(255,255,255,0.35); border-radius: 10px; }
.book::after { content: "LIBRARY"; position: absolute; left: 43px; top: 100px; color: white; font-size: 22px; font-weight: 700; letter-spacing: 2px; transform: rotate(90deg); }
.book-page { position: absolute; right: -12px; top: 10px; width: 18px; height: 250px; background: #fff; border-radius: 0 8px 8px 0; }
@keyframes floatingBook {
    0%, 100% { transform: perspective(800px) rotateY(-18deg) translateY(0); }
    50%      { transform: perspective(800px) rotateY(-18deg) translateY(-15px); }
}
@keyframes rotateCircle { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

/* OPTIONS */
.options-section { padding: 20px 7% 80px; position: relative; z-index: 3; }
.options-title { text-align: center; margin-bottom: 28px; }
.options-title h2 { font-size: 25px; color: #172033; }
.options-title p { margin-top: 7px; color: #64748b; font-size: 14px; }
.options { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; max-width: 1200px; margin: auto; }
.option-card { text-decoration: none; color: inherit; min-height: 190px; background: rgba(255,255,255,0.95); border: 1px solid #e4eaf3; border-radius: 18px;
    padding: 27px 24px; position: relative; overflow: hidden; cursor: pointer;
    transition: transform 0.35s ease, box-shadow 0.35s ease, border-color 0.35s ease, background 0.35s ease; }
.option-card::before { content: ""; position: absolute; width: 180px; height: 180px; border-radius: 50%; background: rgba(37,99,235,0.08); top: -100px; right: -100px; transition: all 0.5s ease; }
.option-card::after { content: ""; position: absolute; height: 3px; width: 0; left: 0; bottom: 0; background: linear-gradient(90deg, #2563eb, #6366f1); transition: width 0.4s ease; }
.option-card:hover { transform: translateY(-12px) scale(1.02); border-color: #9bbcff; box-shadow: 0 20px 45px rgba(37,99,235,0.16); background: white; }
.option-card:hover::before { width: 330px; height: 330px; }
.option-card:hover::after { width: 100%; }
.card-icon { width: 55px; height: 55px; border-radius: 15px; background: #edf3ff; color: #2563eb; display: flex; align-items: center; justify-content: center;
    font-size: 24px; margin-bottom: 20px; position: relative; z-index: 2; transition: transform 0.4s ease, background 0.4s ease, color 0.4s ease; }
.option-card:hover .card-icon { transform: translateY(-4px) rotate(-5deg) scale(1.12); background: #2563eb; color: white; box-shadow: 0 10px 22px rgba(37,99,235,0.25); }
.option-card h3 { font-size: 18px; margin-bottom: 8px; color: #172033; position: relative; z-index: 2; transition: color 0.3s ease; }
.option-card:hover h3 { color: #2563eb; }
.option-card p { font-size: 13px; line-height: 1.6; color: #718096; position: relative; z-index: 2; }
.card-arrow { position: absolute; right: 22px; bottom: 20px; color: #94a3b8; font-size: 18px; transition: transform 0.3s ease, color 0.3s ease; }
.option-card:hover .card-arrow { transform: translateX(7px); color: #2563eb; }

/* FOOTER */
.footer { text-align: center; padding: 25px; border-top: 1px solid #e5eaf2; color: #94a3b8; font-size: 12px; background: white; }

@keyframes fadeUp { from { opacity: 0; transform: translateY(25px); } to { opacity: 1; transform: translateY(0); } }
@keyframes fadeDown { from { opacity: 0; transform: translateY(-15px); } to { opacity: 1; transform: translateY(0); } }

/* RESPONSIVE */
@media (max-width: 1000px) {
    .hero { padding-left: 6%; padding-right: 6%; }
    .options { grid-template-columns: repeat(2, 1fr); }
    .hero-visual { width: 300px; }
}
@media (max-width: 750px) {
    .hero { flex-direction: column; text-align: center; padding-top: 50px; }
    .hero p { margin-left: auto; margin-right: auto; }
    .hero-visual { margin-top: 30px; transform: scale(0.8); }
    .options { grid-template-columns: 1fr; }
    .nav-status { display: none; }
}
@media (prefers-reduced-motion: reduce) {
    .book, .circle-bg, .status-dot { animation: none; }
}
</style>
</head>

<body>

<div class="cursor-light" id="cursorLight"></div>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="logo">
        <div class="logo-icon">&#128218;</div>
        Library Management
    </div>
    <div class="nav-status">
        <span class="status-dot"></span>
        System Online
    </div>

    <div class="nav-user">
        <span class="who">
            &#128100; <sec:authentication property="name"/>
            <sec:authorize access="hasRole('ADMIN')"><span class="role">ADMIN</span></sec:authorize>
            <sec:authorize access="!hasRole('ADMIN')"><span class="role">MEMBER</span></sec:authorize>
        </span>
        <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <span class="small-title">LIBRARY MANAGEMENT SYSTEM</span>

        <h1>Manage Your <span>Library</span> Smarter.</h1>

        <p>
            A simple and powerful library management system designed to
            manage books, search records and maintain your library efficiently.
        </p>

        <a class="explore-btn" href="${pageContext.request.contextPath}/explore">
            Explore Books <span class="arrow">&rarr;</span>
        </a>
    </div>

    <div class="hero-visual">
        <div class="circle-bg"></div>
        <div class="book">
            <div class="book-page"></div>
        </div>
    </div>
</section>

<!-- MAIN OPTIONS -->
<section class="options-section">
    <div class="options-title">
        <h2>Library Controls</h2>
        <p>Select an option to continue</p>
    </div>

    <div class="options">

        <a href="${pageContext.request.contextPath}/issues/my" class="option-card">
            <div class="card-icon">&#128214;</div>
            <h3>My Books</h3>
            <p>See your issued books, due dates and late fines. Return books here.</p>
            <span class="card-arrow">&rarr;</span>
        </a>

        <a href="${pageContext.request.contextPath}/explore" class="option-card">
            <div class="card-icon">&#129517;</div>
            <h3>Explore Books</h3>
            <p>Browse shelves by category and issue the book you like.</p>
            <span class="card-arrow">&rarr;</span>
        </a>

        <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/books/add" class="option-card">
            <div class="card-icon">&#10133;</div>
            <h3>Add Book</h3>
            <p>Add a new book and store its information in the database.</p>
            <span class="card-arrow">&rarr;</span>
        </a>
        </sec:authorize>

        <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/issues/all" class="option-card">
            <div class="card-icon">&#128203;</div>
            <h3>All Issues</h3>
            <p>View every issued and returned book with member and fine details.</p>
            <span class="card-arrow">&rarr;</span>
        </a>
        </sec:authorize>

        <a href="${pageContext.request.contextPath}/books/search" class="option-card">
            <div class="card-icon">&#128269;</div>
            <h3>Search Books</h3>
            <p>Quickly find books by title or author using library records.</p>
            <span class="card-arrow">&rarr;</span>
        </a>

        <sec:authorize access="hasRole('ADMIN')">
        <a href="${pageContext.request.contextPath}/books/manage" class="option-card">
            <div class="card-icon">&#9881;&#65039;</div>
            <h3>Manage Books</h3>
            <p>Edit, update and manage existing library records.</p>
            <span class="card-arrow">&rarr;</span>
        </a>
        </sec:authorize>

    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    Java &bull; Spring Boot &bull; Spring MVC &bull; JPA &bull; Oracle
</footer>

<script>
var cursorLight = document.getElementById("cursorLight");
document.addEventListener("mousemove", function (e) {
    cursorLight.style.left = e.clientX + "px";
    cursorLight.style.top = e.clientY + "px";
});
</script>

</body>
</html>
