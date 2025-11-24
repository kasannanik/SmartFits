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
<title>Workouts - SmartFits</title>
<style>
  body { margin:0; background:#121212; color:#eaeaea; font-family:'Segoe UI',sans-serif; }
  header { display:flex; justify-content:space-between; align-items:center; padding:18px 60px; background:#0d0d0d; border-bottom:1px solid rgba(255,120,30,0.15); }
  .logo { display:flex; align-items:center; gap:10px; }
  .logo-mark { width:38px; height:38px; background:linear-gradient(135deg,#ff7a00,#ff3b00); border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:700; color:#fff; }
  .logo span { font-weight:700; color:#fff; }
  nav a { color:#ddd; text-decoration:none; margin-left:20px; transition:color .2s; }
  nav a:hover { color:#ff7a00; }

  .container { padding:40px 60px; }
  h1 { color:#fff; margin-bottom:25px; }

  .form-section {
    display: flex;
    gap: 30px;
    flex-wrap: wrap;
  }

  form {
    flex: 1;
    background:#1b1b1b;
    padding:24px;
    border-radius:12px;
    border:1px solid rgba(255,120,30,0.1);
    box-sizing: border-box;
  }

  label { display:block; margin-top:12px; font-weight:500; }
  input, select {
    width:100%;
    padding:10px;
    border:none;
    border-radius:8px;
    margin-top:6px;
    background:#121212;
    color:#fff;
    border:1px solid rgba(255,120,30,0.15);
  }

  .btn {
    background:linear-gradient(90deg,#ff7a00,#ff3b00);
    border:none;
    color:#fff;
    padding:10px 16px;
    border-radius:8px;
    margin-top:16px;
    cursor:pointer;
    font-weight:600;
    transition:transform .2s;
  }
  .btn:hover { background:linear-gradient(90deg,#ff8c1a,#ff4a00); transform:translateY(-2px); }

  table {
    width:100%;
    border-collapse:collapse;
    background:#1b1b1b;
    border-radius:12px;
    overflow:hidden;
    border:1px solid rgba(255,120,30,0.1);
    margin-top:40px;
  }
  th, td { padding:12px; border-bottom:1px solid rgba(255,255,255,0.05); text-align:left; }
  th { background:#181818; color:#ff9c54; }
  tr:hover { background:rgba(255,120,30,0.07); }

  td.actions {
    display: flex;
    gap: 8px;
    align-items: center;
    justify-content: flex-start;
  }

  td form { display:inline; margin:0; }

  td button {
    border:none;
    padding:6px 12px;
    border-radius:6px;
    cursor:pointer;
    font-size:13px;
  }
  .edit-btn { background:#ff7a00; color:#fff; }
  .delete-btn { background:transparent; border:1px solid rgba(255,120,30,0.5); color:#ff9c54; }
</style>

<script>
  // fills edit form fields with selected workout data
  function editWorkout(id, type, duration, distance, calories, date, notes) {
    document.getElementById("edit_id").value = id;
    document.getElementById("edit_type").value = type;
    document.getElementById("edit_duration").value = duration;
    document.getElementById("edit_distance").value = distance;
    document.getElementById("edit_calories").value = calories;
    document.getElementById("edit_date").value = date;
    document.getElementById("edit_notes").value = notes;
    window.scrollTo({top: 0, behavior: 'smooth'});
  }
</script>
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
  <h1>Workout Manager</h1>

  <div class="form-section">
    <!-- Add Form -->
    <form method="post" action="workout">
      <input type="hidden" name="action" value="add">
      <h3>Add New Workout</h3>
      <label>Activity Type</label>
      <select name="activity_type">
        <option>Running</option>
        <option>Walking</option>
        <option>Cycling</option>
        <option>Gym Workout</option>
      </select>
      <label>Duration (minutes)</label>
      <input type="number" name="duration_minutes" required>
      <label>Distance (km)</label>
      <input type="number" step="0.01" name="distance_km">
      <label>Calories Burned</label>
      <input type="number" name="calories">
      <label>Date</label>
      <input type="date" name="workout_date" required>
      <label>Notes</label>
      <input type="text" name="notes">
      <button class="btn" type="submit">Add Workout</button>
    </form>

    <!-- Edit Form -->
    <form method="post" action="workout">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="workout_id" id="edit_id">
      <h3>Edit Workout</h3>
      <label>Activity Type</label>
      <select name="activity_type" id="edit_type">
        <option>Running</option>
        <option>Walking</option>
        <option>Cycling</option>
        <option>Gym Workout</option>
      </select>
      <label>Duration (minutes)</label>
      <input type="number" id="edit_duration" name="duration_minutes" required>
      <label>Distance (km)</label>
      <input type="number" step="0.01" id="edit_distance" name="distance_km">
      <label>Calories Burned</label>
      <input type="number" id="edit_calories" name="calories">
      <label>Date</label>
      <input type="date" id="edit_date" name="workout_date" required>
      <label>Notes</label>
      <input type="text" id="edit_notes" name="notes">
      <button class="btn" type="submit">Update Workout</button>
    </form>
  </div>

  <!-- Workout Table -->
  <table>
    <tr>
      <th>Type</th><th>Duration</th><th>Distance</th><th>Calories</th><th>Date</th><th>Notes</th><th>Actions</th>
    </tr>
    <c:forEach var="w" items="${workouts}">
      <tr>
        <td>${w.activityType}</td>
        <td>${w.durationMinutes}</td>
        <td>${w.distanceKm}</td>
        <td>${w.calories}</td>
        <td>${w.workoutDate}</td>
        <td>${w.notes}</td>
        <td class="actions">
          <button type="button" class="edit-btn"
            onclick="editWorkout('${w.workoutId}','${w.activityType}','${w.durationMinutes}','${w.distanceKm}','${w.calories}','${w.workoutDate}','${w.notes}')">Edit</button>

          <form method="post" action="workout">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="workout_id" value="${w.workoutId}">
            <button type="submit" class="delete-btn">Delete</button>
          </form>
        </td>
      </tr>
    </c:forEach>
  </table>
</div>
</body>
</html>
