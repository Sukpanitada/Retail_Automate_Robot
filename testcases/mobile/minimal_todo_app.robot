*** Settings ***
Library           AppiumLibrary
Resource          ../../resources/keywords/import.resource
Suite Setup       Open Minimal Todo App
Suite Teardown    Close Minimal Todo App
Test Teardown     Go Back To Main


*** Test Cases ***
TC001 Verify App Launch Shows Empty State
    Verify Empty State

TC002 Add New Todo And Verify In List
    Add Todo    Buy milk    Pickup from store near office
    Verify Empty State Is Hidden

TC003 Edit Existing Todo
    Add Todo    Go jogging
    Edit Todo    Go jogging    Go jogging in the park

TC004 Delete Todo By Swipe And Undo
    Add Todo    Call dentist
    Delete Todo And Undo    Call dentist

TC005 Add Todo With Reminder And Check Time Shown
    Add Todo With Reminder    Read The Martian
    Verify Reminder Time Is Shown

TC006 Open Settings And Toggle Night Mode
    Open Settings And Toggle Night Mode
