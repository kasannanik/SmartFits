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
  <title>Dashboard - SmartFits</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      margin: 0;
      font-family: "Segoe UI", sans-serif;
      background: #121212;
      color: #eaeaea;
    }

    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 60px;
      background: #0d0d0d;
      border-bottom: 1px solid rgba(255,120,30,0.15);
    }

    .logo { display:flex; align-items:center; gap:10px; }
    .logo-mark {
      width:38px; height:38px;
      background: linear-gradient(135deg,#ff7a00,#ff3b00);
      color:#fff;
      display:flex; align-items:center; justify-content:center;
      font-weight:700;
      border-radius:8px;
    }
    .logo span { font-weight:700; color:#fff; font-size:18px; }

    nav a {
      color: #ddd;
      text-decoration: none;
      margin-left: 20px;
      transition: color .2s;
    }
    nav a:hover { color: #ff7a00; }

    .container {
      padding: 40px 60px;
    }

    h1 { color:#fff; margin-bottom: 28px; }

    .stats {
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(220px,1fr));
      gap: 24px;
    }

    .card {
      background: #1b1b1b;
      padding: 24px;
      border-radius: 12px;
      border:1px solid rgba(255,120,30,0.1);
      text-align: center;
    }

    .card h3 {
      color: #ff954d;
      font-size: 18px;
      margin-bottom: 8px;
    }

    .card p {
      font-size: 28px;
      font-weight: 700;
      margin: 0;
      color: #fff;
    }

    .charts {
      margin-top: 50px;
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(350px,1fr));
      gap: 40px;
    }

    .chart-card {
      background: #1b1b1b;
      border:1px solid rgba(255,120,30,0.1);
      border-radius: 12px;
      padding: 24px;
    }

    .chart-card h3 {
      color: #ff954d;
      text-align: center;
      margin-bottom: 18px;
    }

    canvas {
      width: 100% !important;
      height: 320px !important;
    }

    .recent {
      margin-top: 40px;
      background: #1b1b1b;
      border-radius: 12px;
      border:1px solid rgba(255,120,30,0.1);
      padding: 24px;
    }

    table {
      width:100%;
      border-collapse:collapse;
      color:#ccc;
    }
    th, td { padding:12px; text-align:left; border-bottom:1px solid rgba(255,255,255,0.05); }
    th { color:#ff954d; }
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
    <h1>Dashboard Overview</h1>

    <div class="stats">
      <div class="card">
        <h3>Total Workouts</h3>
        <p>${totalWorkouts}</p>
      </div>
      <div class="card">
        <h3>Total Duration</h3>
        <p>${totalDuration} min</p>
      </div>
      <div class="card">
        <h3>Total Calories</h3>
        <p>${totalCalories}</p>
      </div>
      <div class="card">
  <h3>Goals Achieved</h3>
  <p>${goalsAchieved} / ${totalGoals}</p>
</div>

    </div>

    <!-- Chart Section -->
    <div class="charts">
      <div class="chart-card">
        <h3>Calories vs Duration (Line)</h3>
        <canvas id="lineChart"></canvas>
      </div>

      <div class="chart-card">
        <h3>Workout Type Distribution (Pie)</h3>
        <canvas id="pieChart"></canvas>
      </div>

      <div class="chart-card">
        <h3>Workout Intensity Radar</h3>
        <canvas id="radarChart"></canvas>
      </div>
    </div>

    <!-- Recent Workouts -->
    <div class="recent">
      <h3 style="color:#ff954d;">Recent Workouts</h3>
      <table>
        <tr><th>Type</th><th>Duration</th><th>Calories</th><th>Date</th></tr>
        <c:forEach var="w" items="${workoutsRecent}">
          <tr>
            <td>${w.activityType}</td>
            <td>${w.durationMinutes} min</td>
            <td>${w.calories}</td>
            <td>${w.workoutDate}</td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </div>

  <script>
    // JSP data arrays
    const labels = [
      <c:forEach var="w" items="${workoutsRecent}" varStatus="s">
        "${w.workoutDate}"<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];
    const calories = [
      <c:forEach var="w" items="${workoutsRecent}" varStatus="s">
        ${w.calories == null ? 0 : w.calories}<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];
    const durations = [
      <c:forEach var="w" items="${workoutsRecent}" varStatus="s">
        ${w.durationMinutes}<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];
    const types = [
      <c:forEach var="w" items="${workoutsRecent}" varStatus="s">
        "${w.activityType}"<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];

    // 🔶 Line Chart: Calories & Duration
    const ctx1 = document.getElementById('lineChart').getContext('2d');
    new Chart(ctx1, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Calories Burned',
            data: calories,
            borderColor: '#ff7a00',
            backgroundColor: 'rgba(255,122,0,0.2)',
            tension: 0.4,
            fill: true,
            pointRadius: 5,
            pointBackgroundColor: '#ff7a00'
          },
          {
            label: 'Duration (min)',
            data: durations,
            borderColor: '#ff3b00',
            backgroundColor: 'rgba(255,59,0,0.2)',
            tension: 0.4,
            fill: true,
            pointRadius: 5,
            pointBackgroundColor: '#ff3b00'
          }
        ]
      },
      options: {
        plugins: {
          legend: { labels: { color: '#fff' } },
          tooltip: {
            backgroundColor: '#1b1b1b',
            titleColor: '#ff7a00',
            bodyColor: '#fff'
          }
        },
        scales: {
          x: { ticks: { color: '#ccc' }, grid: { color: 'rgba(255,255,255,0.05)' } },
          y: { ticks: { color: '#ccc' }, grid: { color: 'rgba(255,255,255,0.05)' } }
        }
      }
    });

    // 🟠 Pie Chart: Calories by Type
    const ctx2 = document.getElementById('pieChart').getContext('2d');
    const typeCalories = {};
    types.forEach((t, i) => { typeCalories[t] = (typeCalories[t] || 0) + calories[i]; });

    new Chart(ctx2, {
      type: 'pie',
      data: {
        labels: Object.keys(typeCalories),
        datasets: [{
          data: Object.values(typeCalories),
          backgroundColor: ['#ff7a00','#ff3b00','#ff9c54','#ffb380','#ffa64d'],
          borderColor: '#121212',
          borderWidth: 2
        }]
      },
      options: {
        plugins: {
          legend: { labels: { color: '#fff' } }
        }
      }
    });

    // ❤️ Radar Chart: Average Duration & Calories
    const uniqueTypes = [...new Set(types)];
    const avgCalories = uniqueTypes.map(t => {
      let count = 0, sum = 0;
      types.forEach((x,i) => { if (x===t){ sum+=calories[i]; count++; }});
      return count? sum/count:0;
    });
    const avgDuration = uniqueTypes.map(t => {
      let count = 0, sum = 0;
      types.forEach((x,i) => { if (x===t){ sum+=durations[i]; count++; }});
      return count? sum/count:0;
    });

    const ctx3 = document.getElementById('radarChart').getContext('2d');
    new Chart(ctx3, {
      type: 'radar',
      data: {
        labels: uniqueTypes,
        datasets: [
          {
            label: 'Avg Calories',
            data: avgCalories,
            borderColor: '#ff7a00',
            backgroundColor: 'rgba(255,122,0,0.3)',
            fill: true
          },
          {
            label: 'Avg Duration',
            data: avgDuration,
            borderColor: '#ff3b00',
            backgroundColor: 'rgba(255,59,0,0.3)',
            fill: true
          }
        ]
      },
      options: {
        plugins: {
          legend: { labels: { color: '#fff' } }
        },
        scales: {
          r: {
            angleLines: { color: 'rgba(255,255,255,0.1)' },
            grid: { color: 'rgba(255,255,255,0.1)' },
            pointLabels: { color: '#fff' },
            ticks: { color: '#fff' }
          }
        }
      }
    });
  </script>
</body>
</html>
