Feature: Login
    As a user
    I want to sign in to my account
    So that I can use the app features

    Scenario: Successful login
        Given the app is running
        And I am on the login screen
        When I enter "test@example.com" into the email field
        And I enter "password123" into the password field
        And I tap the "Login" button
        Then I should see the home screen
