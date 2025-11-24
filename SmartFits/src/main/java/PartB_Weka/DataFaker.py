# This script makes a small fake workout dataset for WEKA training.

import random, csv

activities = ["Running", "Walking", "Cycling", "Gym_Workout"]

rows = []
for _ in range(100):
    act = random.choice(activities)

    # keep numbers realistic per activity
    if act == "Running":
        duration = random.randint(20, 60)
        distance = round(random.uniform(3, 10), 2)
        calories = random.randint(200, 500)
    elif act == "Walking":
        duration = random.randint(30, 80)
        distance = round(random.uniform(2, 6), 2)
        calories = random.randint(100, 300)
    elif act == "Cycling":
        duration = random.randint(40, 90)
        distance = round(random.uniform(8, 25), 2)
        calories = random.randint(300, 700)
    else:  # Gym
        duration = random.randint(30, 70)
        distance = 0.0
        calories = random.randint(200, 600)

    rows.append([act, duration, distance, calories])

with open("workout_dataset.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["activity_type", "duration_min", "distance_km", "calories"])
    writer.writerows(rows)

print(" dataset saved -> workout_dataset.csv")
