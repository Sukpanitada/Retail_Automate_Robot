*** Settings ***
Resource        ../../resources/keywords/import.resource
Suite Setup     Import Variables    ${EXECDIR}/resources/data/${ENV}/users_login_data.yaml
Test Setup      Navigate To Login Page    ${LOGIN_URL}
Test Teardown   Close Browser

*** Test Cases ***
TC_WEB_001 Login Success
    [Documentation]    To verify that a user can login successfully with a correct username and password.
    Input Login Credentials    ${VALID_USER}[username]    ${VALID_USER}[password]
    Verify Login Success Message
    Click Logout Button
    Verify Logout Success Message

TC_WEB_002 Login Failed - Password Incorrect
    [Documentation]    To verify that a user cannot login when using a correct username but wrong password.
    Input Login Credentials    ${INVALID_PASSWORD_USER}[username]    ${INVALID_PASSWORD_USER}[password]
    Verify Login Error Message    Your password is invalid!

TC_WEB_003 Login Failed - Username Not Found
    [Documentation]    To verify that a user cannot login when using a username that does not exist.
    Input Login Credentials    ${INVALID_USERNAME_USER}[username]    ${INVALID_USERNAME_USER}[password]
    Verify Login Error Message    Your username is invalid!
