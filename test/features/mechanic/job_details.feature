Feature: Mechanic Job Details
    As a mechanic
    I want to view the details of a job
    So that I can know what to do and where to go

    Scenario: Viewing a pending job
        Given the app is running
        And I am on the Job Details screen with a pending job
        Then I should see the customer name
        And I should see the vehicle info
        And I should see the estimated earnings
        And I should see "Pending Acceptance" text

    Scenario: Viewing an accepted job
        Given the app is running
        And I am on the Job Details screen with an accepted job
        Then I should see the "Start Service" button

    Scenario: Viewing an in-progress job
        Given the app is running
        And I am on the Job Details screen with an in-progress job
        Then I should see the "Mark as Complete" button
