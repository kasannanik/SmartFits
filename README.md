# Smart Fits - AI-Powered Fitness Tracker

Smart Fits is a full-stack Java EE web application designed to help users manage workouts, track fitness goals, and analyze performance metrics. It features a Machine Learning component that predicts activity types based on workout data.

##  Features
* **User Management:** Secure registration and session management[cite: 73, 112].
* **Workout Logging:** CRUD operations for logging duration, distance, and calories[cite: 119].
* **Goal Tracking:** Set and monitor fitness goals (Duration, Calories)[cite: 126].
* **Analytics Dashboard:** Interactive charts using Chart.js for workout trends[cite: 135].
* **AI Integration:** Activity prediction using the WEKA Naive Bayes classifier[cite: 162].

## 🛠️ Tech Stack
* **Frontend:** JSP, HTML5, CSS3, JavaScript, Chart.js.
* **Backend:** Java EE (Servlets, JSP, JDBC), MVC Architecture[cite: 81].
* **Database:** MySQL 8.
* **Machine Learning:** WEKA 3.8 API, Python (Faker library for dataset generation).
* **IDE:** NetBeans.

##  Database Setup
1.  Import the `database_schema.sql` file into MySQL.
2.  The database includes tables for `app_user`, `workout`, and `goal`[cite: 84].

##  Machine Learning Model
The project uses a Naive Bayes model (`activity_model_nb.model`) trained on a dataset of 100 records to classify activities (Running, Cycling, Walking, Gym Workout) with 100% accuracy on the test set[cite: 170].
