<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Sign In - SmartFits</title>
  <style>
    body {
      margin:0;
      font-family:'Segoe UI',sans-serif;
      background:linear-gradient(135deg,#161616,#0f0f0f);
      color:#eaeaea;
      display:flex; align-items:center; justify-content:center;
      height:100vh;
    }

    .box {
      background: #1c1c1c;
      padding: 40px 36px;
      border-radius: 14px;
      width: 380px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.6);
      border:1px solid rgba(255,120,30,0.1);
      text-align:center;
    }

    h2 { color:#fff; margin:0 0 10px 0; }
    p { color:#aaa; font-size:14px; margin-bottom:20px; }

    .input-container {
      position:relative;
      margin:8px 0;
    }

    .input {
      width:100%;
      background:#111;
      border:1px solid rgba(255,255,255,0.05);
      border-radius:10px;
      padding:10px 12px;
      color:#ddd;
      box-sizing:border-box;
    }

    .toggle-password {
      position:absolute;
      right:12px;
      top:50%;
      transform:translateY(-50%);
      cursor:pointer;
      color:#ccc;
    }

    .toggle-password:hover {
      color:#ff7a00;
    }

    .btn {
      width:100%;
      background:linear-gradient(90deg,#ff7a00,#ff3b00);
      border:none;
      border-radius:10px;
      color:#fff;
      font-weight:600;
      padding:12px;
      margin-top:12px;
      cursor:pointer;
      font-size:15px;
    }

    .alt {
      display:block;
      margin-top:12px;
      color:#ff9b55;
      text-decoration:none;
      font-size:14px;
    }
  </style>
</head>
<body>
  <div class="box">
    <h2>Welcome Back</h2>
    <p>Sign in to continue your journey.</p>

    <c:if test="${not empty errorMessage}">
      <div style="color:#ffb3a3; margin-bottom:10px;">${errorMessage}</div>
    </c:if>

    <form method="post" action="signin">
      <input class="input" type="text" name="username" placeholder="Username" required>
      <div class="input-container">
        <input class="input" type="password" id="signin-password" name="password" placeholder="Password" required>
        <span class="toggle-password" onclick="togglePassword('signin-password', this)">👁️</span>
      </div>
      <button class="btn" type="submit">Sign In</button>
    </form>

    <a class="alt" href="signup.jsp">Create account</a>
  </div>

  <script>
    function togglePassword(id, icon) {
      const field = document.getElementById(id);
      if (field.type === "password") {
        field.type = "text";
        icon.textContent = "🙈";
      } else {
        field.type = "password";
        icon.textContent = "👁️";
      }
    }
  </script>
</body>
</html>
