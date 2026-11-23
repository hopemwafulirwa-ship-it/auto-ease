Feature: User Profile Editing and Role Switching

  Scenario: Authenticated customer edits profile details and sees updated profile
    Given I am logged in as a customer on the profile screen
    When I tap the edit profile button
    And I update my full name to {'Jane Updated'} and phone to {'+1 555-999-8888'}
    And I tap the save changes button
    Then I should return to the profile screen showing {'Jane Updated'} and {'+1 555-999-8888'}

  Scenario: Authenticated customer switches role to Mechanic and is redirected to Mechanic Dashboard
    Given I am logged in as a customer on the profile screen
    When I switch my active role to {'Mechanic'}
    Then I should be redirected to the mechanic dashboard
