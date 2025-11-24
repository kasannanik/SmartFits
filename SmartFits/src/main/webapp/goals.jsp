<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>
<%
    HttpSession s = request.getSession(false);
    User loggedUser = null;
    if (s != null) loggedUser = (User) s.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Goals - SmartFits</title>
  <style>
    body { margin:0; background:#121212; color:#eaeaea; font-family:'Segoe UI',sans-serif; }
    header { display:flex; justify-content:space-between; align-items:center; padding:18px 60px; background:#0d0d0d; border-bottom:1px solid rgba(255,120,30,0.15); }
    .logo { display:flex; align-items:center; gap:10px; }
    .logo-mark { width:38px; height:38px; background:linear-gradient(135deg,#ff7a00,#ff3b00); border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:700; color:#fff; }
    .logo span { font-weight:700; color:#fff; }
    nav a { color:#ddd; text-decoration:none; margin-left:20px; transition:color .2s; }
    nav a:hover { color:#ff7a00; }
    .container { padding:40px 60px; }
    h1 { color:#fff; }

    form { background:#1b1b1b; padding:24px; border-radius:12px; border:1px solid rgba(255,120,30,0.1); margin-bottom:40px; }
    label { display:block; margin-top:12px; font-weight:500; }
    input, select { width:100%; padding:10px; border:none; border-radius:8px; margin-top:6px; background:#121212; color:#fff; border:1px solid rgba(255,120,30,0.15); }
    .btn { background:linear-gradient(90deg,#ff7a00,#ff3b00); border:none; color:#fff; padding:10px 16px; border-radius:8px; margin-top:16px; cursor:pointer; }

    table { width:100%; border-collapse:collapse; background:#1b1b1b; border-radius:12px; overflow:hidden; border:1px solid rgba(255,120,30,0.1); }
    th, td { padding:12px; border-bottom:1px solid rgba(255,255,255,0.05); text-align:left; }
    th { background:#181818; color:#ff9c54; }
    tr:hover { background:rgba(255,120,30,0.07); }
    td button { background:linear-gradient(90deg,#ff7a00,#ff3b00); border:none; color:#fff; padding:5px 12px; border-radius:6px; cursor:pointer; }
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

  <div class="container">
    <h1>Goals</h1>

    <form method="post" action="goal">
      <input type="hidden" name="action" value="add">
      <label>Goal Title</label>
      <input type="text" name="goal_title" required>
      <label>Goal Type</label>
      <select name="goal_type">
        <option>Duration</option>
        <option>Distance</option>
        <option>Calories</option>
        <option>Sessions</option>
      </select>
      <label>Goal Value</label>
      <input type="number" step="0.01" name="goal_value" required>
      <button class="btn" type="submit">Add Goal</button>
    </form>

    <table>
      <tr>
        <th>Title</th>
        <th>Type</th>
        <th>Value</th>
        <th>Status</th>
        <th>Action</th>
      </tr>
      <c:forEach var="g" items="${goals}">
        <tr>
          <td>${g.goalTitle}</td>
          <td>${g.goalType}</td>
          <td>${g.goalValue}</td>
          <td><c:choose><c:when test="${g.achieved}">✅ Done</c:when><c:otherwise>⏳ Pending</c:otherwise></c:choose></td>
          <td>
            <c:if test="${!g.achieved}">
              <form method="post" action="goal" style="display:inline;">
                <input type="hidden" name="action" value="achieve">
                <input type="hidden" name="goal_id" value="${g.goalId}">
                <button type="submit">Mark Done</button>
              </form>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </table>
  </div>
</body>
</html>
