-- Drop the database if it already exists
DROP DATABASE IF EXISTS smartfits;

-- Create the database
CREATE DATABASE smartfits;

-- Connect to the new database
-- \c smartfits

-- Create users table
CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    username VARCHAR(40) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create workout table
CREATE TABLE workout (
    workout_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    activity_type VARCHAR(30) NOT NULL CHECK (
        activity_type IN ('Running', 'Walking', 'Cycling', 'Gym Workout')
    ),
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes >= 0),
    distance_km NUMERIC(5,2) CHECK (distance_km >= 0),
    calories INTEGER CHECK (calories >= 0),
    workout_date DATE NOT NULL,
    notes VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create goals table
CREATE TABLE goal (
    goal_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE,
    goal_title VARCHAR(50) NOT NULL,
    goal_type VARCHAR(20) NOT NULL CHECK (
        goal_type IN ('Duration', 'Distance', 'Calories', 'Sessions')
    ),
    goal_value NUMERIC(10,2) NOT NULL,
    achieved BOOLEAN DEFAULT FALSE,
    achieved_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
