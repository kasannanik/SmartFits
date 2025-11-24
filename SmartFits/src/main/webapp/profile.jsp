<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  // check if user logged in
  HttpSession s = request.getSession(false);
  User u = null;
  if (s != null) u = (User) s.getAttribute("user");
  if (u == null) {
    response.sendRedirect(request.getContextPath() + "/signin");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Profile - SmartFits</title>
  <style>
    body {
      margin: 0;
      background: #121212;
      color: #eaeaea;
      font-family: 'Segoe UI', sans-serif;
    }

    /* header */
    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 60px;
      background: #0d0d0d;
      border-bottom: 1px solid rgba(255,120,30,0.15);
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
    }

    .logo-mark {
      width: 38px;
      height: 38px;
      background: linear-gradient(135deg,#ff7a00,#ff3b00);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 700;
      color: #fff;
    }

    .logo span {
      font-weight: 700;
      color: #fff;
      font-size: 18px;
    }

    nav a {
      color: #ddd;
      text-decoration: none;
      margin-left: 20px;
      transition: color .2s;
    }
    nav a:hover { color: #ff7a00; }

    .container {
      padding: 40px 60px;
      max-width: 700px;
      margin: auto;
    }

    h1 {
      color: #fff;
      margin-bottom: 30px;
      text-align: center;
    }

    form {
      background: #1b1b1b;
      padding: 30px;
      border-radius: 12px;
      border: 1px solid rgba(255,120,30,0.1);
      margin-bottom: 40px;
      box-shadow: 0 6px 20px rgba(0,0,0,0.3);
    }

    label {
      display: block;
      margin-top: 12px;
      font-weight: 500;
      color: #f0f0f0;
    }

    input {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 8px;
      margin-top: 6px;
      background: #121212;
      color: #fff;
      border: 1px solid rgba(255,120,30,0.15);
      box-sizing: border-box;
      transition: border 0.3s;
    }
    input:focus {
      outline: none;
      border: 1px solid #ff7a00;
    }

    .btn {
      background: linear-gradient(90deg,#ff7a00,#ff3b00);
      border: none;
      color: #fff;
      padding: 12px 18px;
      border-radius: 8px;
      margin-top: 20px;
      cursor: pointer;
      font-weight: 600;
      width: 100%;
      transition: transform 0.2s, background 0.3s;
    }
    .btn:hover {
      background: linear-gradient(90deg,#ff8c1a,#ff4a00);
      transform: translateY(-2px);
    }

    .divider {
      border-top: 1px solid rgba(255,255,255,0.1);
      margin: 40px 0;
    }

    h2 {
      color: #ff9044;
      font-size: 20px;
      margin-bottom: 10px;
    }

    .success {
      background: rgba(0,255,100,0.1);
      padding: 10px;
      border-radius: 6px;
      color: #00ff88;
      margin-bottom: 12px;
      text-align: center;
    }

    .error {
      background: rgba(255,60,0,0.1);
      padding: 10px;
      border-radius: 6px;
      color: #ff6c3c;
      margin-bottom: 12px;
      text-align: center;
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
    <% if (u == null) { %>
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

<div class="container">
  <h1>Profile Settings</h1>

  <!-- feedback messages -->
  <c:if test="${not empty successMessage}">
    <div class="success">${successMessage}</div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="error">${errorMessage}</div>
  </c:if>

  <!-- update personal info -->
  <form method="post" action="profile">
    <input type="hidden" name="action" value="updateProfile">
    <h2>Personal Details</h2>

    <label>Full Name</label>
    <input type="text" name="name" value="<%= u.getName() %>" required>

    <label>Username</label>
    <input type="text" name="username" value="<%= u.getUsername() %>" readonly>

    <label>Email</label>
    <input type="email" name="email" value="<%= u.getEmail() != null ? u.getEmail() : "" %>">

    <button class="btn" type="submit">Save Changes</button>
  </form>

  <div class="divider"></div>

  <!-- change password -->
  <form method="post" action="profile">
    <input type="hidden" name="action" value="changePassword">
    <h2>Change Password</h2>

    <label>Current Password</label>
    <input type="password" name="currentPassword" required>

    <label>New Password</label>
    <input type="password" name="newPassword" required>

    <label>Confirm New Password</label>
    <input type="password" name="confirmPassword" required>

    <button class="btn" type="submit">Update Password</button>
  </form>
</div>

</body>
</html>
