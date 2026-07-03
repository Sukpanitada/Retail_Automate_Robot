*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
Create API Session
    ${headers}=    Create Dictionary    x-api-key=${X_API_KEY}
    Create Session    api_session    ${API_BASE_URL}    headers=${headers}

Get User Profile By Id And Verify Expected Status Code
    [Arguments]    ${user_id}    ${expected_status}
    ${response}=    GET On Session    api_session    ${USERS_ENDPOINT}${user_id}    expected_status=${expected_status}
    RETURN    ${response}

Verify User Profile Data Success
    [Arguments]    ${response}    ${expected_id}    ${expected_email}    ${expected_first_name}    ${expected_last_name}    ${expected_avatar}
    ${body}=    Evaluate    $response.json()
    ${data}=    Get From Dictionary    ${body}    data
    ${avatar}=    Get From Dictionary    ${data}    avatar
    Should Be Equal As Integers    ${data}[id]    ${expected_id}
    Should Be Equal As Strings    ${data}[email]    ${expected_email}
    Should Be Equal As Strings    ${data}[first_name]    ${expected_first_name}
    Should Be Equal As Strings    ${data}[last_name]    ${expected_last_name}
    Should Be Equal As Strings    ${data}[avatar]    ${expected_avatar}

Verify User Profile Not Found
    [Arguments]    ${response}
    ${body}=    Evaluate    $response.json()
    Should Be Empty    ${body}
