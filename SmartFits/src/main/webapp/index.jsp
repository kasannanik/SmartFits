<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>
<%
    // Check login session
    HttpSession sessionObj = request.getSession(false);
    User loggedUser = null;
    if (sessionObj != null) {
        loggedUser = (User) sessionObj.getAttribute("user");
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>SmartFits – Your Fitness, Reimagined</title>
  <style>
    body {
      margin: 0;
      font-family: "Segoe UI", Roboto, sans-serif;
      background: #0c0c0c;
      color: #e8e8e8;
      overflow-x: hidden;
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 60px;
      background: rgba(10,10,10,0.95);
      border-bottom: 1px solid rgba(255,255,255,0.05);
      position: fixed;
      top: 0;
      width: 100%;
      z-index: 100;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 12px;
      text-decoration: none;
    }

    .logo-mark {
      background: linear-gradient(135deg,#ff7a00,#ff3b00);
      color: #fff;
      width: 38px;
      height: 38px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      font-size: 16px;
      letter-spacing: -0.02em;
    }

    .logo span {
      font-weight: 700;
      font-size: 18px;
      color: #fff;
    }

    nav a {
      color: #ddd;
      margin-left: 24px;
      text-decoration: none;
      font-weight: 500;
      transition: color 0.3s;
    }
    nav a:hover { color: #ff8c3a; }

    /* hero */
    .hero {
      height: 100vh;
      background-image:
        linear-gradient(to right, rgba(0,0,0,0.75) 30%, rgba(0,0,0,0.3) 70%),
        url('${pageContext.request.contextPath}/hero.png');
      background-size: cover;
      background-position: center;
      display: flex;
      align-items: center;
      justify-content: flex-start;
      padding: 0 60px;
      box-sizing: border-box;
    }

    .hero-text {
      max-width: 520px;
    }

    .hero h1 {
      color: #fff;
      font-size: 52px;
      font-weight: 800;
      line-height: 1.2;
      margin: 0 0 16px 0;
    }

    .hero p {
      color: #d0d0d0;
      font-size: 18px;
      line-height: 1.5;
      margin-bottom: 36px;
    }

    .cta {
      display: flex;
      gap: 18px;
      flex-wrap: wrap;
    }

    .btn {
      background: linear-gradient(90deg,#ff7a00,#ff3b00);
      color: #fff;
      border: none;
      padding: 14px 34px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      box-shadow: 0 6px 20px rgba(255,90,0,0.25);
      transition: transform 0.2s;
    }
    .btn:hover { transform: translateY(-2px); }

    .btn-alt {
      background: transparent;
      border: 1px solid rgba(255,255,255,0.25);
      color: #ddd;
      padding: 14px 34px;
      border-radius: 8px;
      font-weight: 600;
      font-size: 16px;
      cursor: pointer;
      transition: background 0.3s;
    }
    .btn-alt:hover {
      background: rgba(255,255,255,0.08);
    }

    /* section after hero */
    .features {
      padding: 100px 60px;
      background: #121212;
      text-align: center;
    }

    .features h2 {
      color: #fff;
      font-size: 34px;
      margin-bottom: 10px;
    }

    .features p {
      color: #bbb;
      font-size: 17px;
      margin-bottom: 50px;
    }

    .cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 24px;
    }

    .card {
      background: #1b1b1b;
      padding: 28px;
      border-radius: 12px;
      border: 1px solid rgba(255,120,30,0.07);
      text-align: left;
      box-shadow: 0 6px 20px rgba(0,0,0,0.4);
      transition: transform .25s;
    }

    .card:hover { transform: translateY(-6px); }

    .card h3 {
      color: #fff;
      margin-top: 0;
    }

    .card p {
      color: #a5a5a5;
      line-height: 1.6;
    }

    footer {
      background: #0e0e0e;
      color: #777;
      padding: 40px;
      text-align: center;
      font-size: 14px;
      border-top: 1px solid rgba(255,255,255,0.05);
    }
  </style>
</head>
<body>
  <header>
    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
      <div class="logo-mark">SF</div>
      <span>SmartFits</span>
    </a>

    <nav>
      <% if (loggedUser == null) { %>
        <a href="${pageContext.request.contextPath}/signin">Sign In</a>
        <a href="${pageContext.request.contextPath}/signup">Sign Up</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/workout">Workouts</a>
        <a href="${pageContext.request.contextPath}/goal">Goals</a>
        <a href="${pageContext.request.contextPath}/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/signin">Logout</a>
      <% } %>
    </nav>
  </header>

  <section class="hero">
    <div class="hero-text">
      <h1>Your Fitness,<br>Reimagined</h1>
      <p>Track workouts, monitor calories, and stay motivated with a modern fitness dashboard designed for clarity and style.</p>
      <div class="cta">
        <% if (loggedUser == null) { %>
          <a href="${pageContext.request.contextPath}/signup"><button class="btn">Get Started</button></a>
          <a href="${pageContext.request.contextPath}/signin"><button class="btn-alt">Sign In</button></a>
        <% } else { %>
          <a href="${pageContext.request.contextPath}/dashboard"><button class="btn">Go to Dashboard</button></a>
          <a href="${pageContext.request.contextPath}/goal"><button class="btn-alt">View Goals</button></a>
        <% } %>
      </div>
    </div>
  </section>

  <section class="features">
    <h2>What SmartFits Offers</h2>
    <p>Everything you need to keep your training focused, measurable, and motivating.</p>
    <div class="cards">
      <div class="card">
        <h3>Workout History</h3>
        <p>Log and review your workouts easily. Edit, filter, and visualize your data in real time.</p>
      </div>
      <div class="card">
        <h3>Goal Tracking</h3>
        <p>Set personal fitness targets, mark achievements, and celebrate milestones.</p>
      </div>
      <div class="card">
        <h3>Dashboard Insights</h3>
        <p>See your calorie burn, duration trends, and activity types through clean charts.</p>
      </div>
      <div class="card">
        <h3>Profile Management</h3>
        <p>Update your personal details, password, and preferences securely anytime.</p>
      </div>
    </div>
  </section>

  <footer>
    &copy; 2025 SmartFits. Designed with passion and purpose.
  </footer>
</body>
</html>
