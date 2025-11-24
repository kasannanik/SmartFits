package model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Goal {
    private int goalId;
    private int userId;
    private String goalTitle;
    private String goalType;
    private Double goalValue;
    private boolean achieved;
    private LocalDate achievedDate;
    private LocalDateTime createdAt;

    public Goal() {}

    // getters & setters
    public int getGoalId() { return goalId; }
    public void setGoalId(int goalId) { this.goalId = goalId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getGoalTitle() { return goalTitle; }
    public void setGoalTitle(String goalTitle) { this.goalTitle = goalTitle; }
    public String getGoalType() { return goalType; }
    public void setGoalType(String goalType) { this.goalType = goalType; }
    public Double getGoalValue() { return goalValue; }
    public void setGoalValue(Double goalValue) { this.goalValue = goalValue; }
    public boolean isAchieved() { return achieved; }
    public void setAchieved(boolean achieved) { this.achieved = achieved; }
    public LocalDate getAchievedDate() { return achievedDate; }
    public void setAchievedDate(LocalDate achievedDate) { this.achievedDate = achievedDate; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
