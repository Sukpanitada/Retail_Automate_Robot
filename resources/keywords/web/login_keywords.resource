*** Settings ***
Library    SeleniumLibrary    timeout=10    implicit_wait=1.5    run_on_failure=${None}

*** Variables ***
${headless}    ${TRUE}
${CHROME_BROWSER_PATH}    ${EXECDIR}${/}chrome${/}chrome-mac-arm64${/}Google Chrome for Testing.app${/}Contents${/}MacOS${/}Google Chrome for Testing
${CHROME_DRIVER_PATH}     ${EXECDIR}${/}chrome${/}chromedriver-mac-arm64${/}chromedriver
${LOGIN_USERNAME_INPUT}     id=username
${LOGIN_PASSWORD_INPUT}     id=password
${LOGIN_SUBMIT_BTN}         css=button[type='submit']
${LOGIN_SUCCESS_MSG}        css=.flash.success
${LOGIN_ERROR_MSG}          css=.flash.error
${LOGOUT_BTN}               css=a[href='/logout']
${SECURE_AREA_MSG}          css=.flash.success

*** Keywords ***
Set Chrome Options
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    IF    $headless
        Call Method    ${chrome_options}    add_argument    --headless
    END
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Evaluate    setattr($chrome_options, 'binary_location', r'${CHROME_BROWSER_PATH}')
    ${service}=    Evaluate    sys.modules["selenium.webdriver.chrome.service"].Service(executable_path=r"${CHROME_DRIVER_PATH}")
    Create Webdriver    Chrome    options=${chrome_options}    service=${service}

Navigate To Login Page
    [Arguments]    ${url}
    Set Chrome Options
    Go To    ${url}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_INPUT}    timeout=10s

Input Login Credentials
    [Arguments]    ${username}    ${password}
    Input Text    ${LOGIN_USERNAME_INPUT}    ${username}
    Input Text    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click Element    ${LOGIN_SUBMIT_BTN}

Verify Login Success Message
    Wait Until Element Is Visible    ${LOGIN_SUCCESS_MSG}    timeout=10s
    Element Should Contain    ${LOGIN_SUCCESS_MSG}    You logged into a secure area!

Click Logout Button
    Click Element    ${LOGOUT_BTN}

Verify Logout Success Message
    Wait Until Element Is Visible    ${LOGIN_SUCCESS_MSG}    timeout=10s
    Element Should Contain    ${LOGIN_SUCCESS_MSG}    You logged out of the secure area!

Verify Login Error Message
    [Arguments]    ${expected_message}
    Wait Until Element Is Visible    ${LOGIN_ERROR_MSG}    timeout=10s
    Element Should Contain    ${LOGIN_ERROR_MSG}    ${expected_message}
