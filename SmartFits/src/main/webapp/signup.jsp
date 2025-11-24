<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Sign Up - SmartFits</title>
  <style>
    body {
      margin:0;
      font-family:'Segoe UI',sans-serif;
      background: radial-gradient(circle at 40% 40%, #1a1a1a, #0f0f0f);
      display:flex; align-items:center; justify-content:center;
      height:100vh; color:#eaeaea;
    }

    .card {
      background:#1b1b1b;
      border-radius:14px;
      padding:40px 36px;
      width:400px;
      box-shadow:0 10px 30px rgba(0,0,0,0.6);
      border:1px solid rgba(255,120,30,0.08);
    }

    h2 { color:#fff; margin-bottom:6px; }
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
      text-align:center;
    }
  </style>
</head>
<body>
  <div class="card">
    <h2>Create Account</h2>
    <p>Join SmartFits and take control of your workouts.</p>

    <c:if test="${not empty errorMessage}">
      <div style="color:#ffb3a3;margin-bottom:10px;">${errorMessage}</div>
    </c:if>

    <form method="post" action="signup">
      <input class="input" type="text" name="name" placeholder="Full name" required>
      <input class="input" type="text" name="username" placeholder="Username" required>
      <input class="input" type="email" name="email" placeholder="Email">

      <div class="input-container">
        <input class="input" type="password" id="password" name="password" placeholder="Password" required>
        <span class="toggle-password" onclick="togglePassword('password', this)">👁️</span>
      </div>

      <div class="input-container">
        <input class="input" type="password" id="repassword" name="repassword" placeholder="Confirm Password" required>
        <span class="toggle-password" onclick="togglePassword('repassword', this)">👁️</span>
      </div>

      <button class="btn" type="submit">Sign Up</button>
    </form>

    <a class="alt" href="signin.jsp">Already have an account?</a>
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
