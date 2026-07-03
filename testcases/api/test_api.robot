*** Settings ***
Resource        ../../resources/keywords/import.resource
Suite Setup     Import Variables    ${EXECDIR}/resources/data/${ENV}/users_api_data.yaml
Test Setup     Create API Session
Test Teardown  Delete All Sessions

*** Test Cases ***
TC001: Get user profile success
    [Documentation]    To verify get user profile api will return correct data when trying to get profile of existing user
	${response}=    Get User Profile By Id And Verify Expected Status Code    ${EXISTING_USER}[id]    200
	Verify User Profile Data Success    ${response}    ${EXISTING_USER}[id]    ${EXISTING_USER}[email]    ${EXISTING_USER}[first_name]    ${EXISTING_USER}[last_name]    ${EXISTING_USER}[avatar]

TC002: Get user profile but user not found
    [Documentation]    To verify get user profile api will return 404 not found when trying to get exist profile of not existing user
	${response}=    Get User Profile By Id And Verify Expected Status Code    ${NOT_EXISTING_USER}[id]   404
	Verify User Profile Not Found    ${response}
