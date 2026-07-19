Feature: Register
    As a user
    I want to create an account
    So that I can access the app services

    Scenario: Successful registration
        Given the app is running
        And I am on the register screen
        When I enter "John Doe" into the name field
        And I enter "test@example.com" into the email field
        And I enter "password123" into the password field
        And I enter "password123" into the confirm password field
        And I tap the "Sign Up" button
        Then I should see the home screen
