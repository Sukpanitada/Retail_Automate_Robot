*** Variables ***
${platform_name}        Android
${device_name}          emulator-5554
${automation_name}      UiAutomator2
${app_package}          com.avjindersinghsekhon.minimaltodo
${app_activity}         com.example.avjindersinghsekhon.toodle.MainActivity
${app_path}             /Users/sukpanitadacharoensup/Minimal-Todo/app/app-release.apk

# Locators
${main_fab}                  id=com.avjindersinghsekhon.minimaltodo:id/addToDoItemFAB
${empty_state}               id=com.avjindersinghsekhon.minimaltodo:id/toDoEmptyView
${todo_title_input}          id=com.avjindersinghsekhon.minimaltodo:id/userToDoEditText
${todo_description_input}     id=com.avjindersinghsekhon.minimaltodo:id/userToDoDescription
${reminder_switch}           id=com.avjindersinghsekhon.minimaltodo:id/toDoHasDateSwitchCompat
${date_field}                id=com.avjindersinghsekhon.minimaltodo:id/newTodoDateEditText
${time_field}                id=com.avjindersinghsekhon.minimaltodo:id/newTodoTimeEditText
${save_button}               id=com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton
${save_btn}                  id=com.avjindersinghsekhon.minimaltodo:id/makeToDoFloatingActionButton
${settings_menu_item}        xpath=//*[@text='Settings']
${settings_menu}             xpath=//*[@text='Settings']
${settings_night_mode}       xpath=//*[@text='Night Mode']
${night_mode_text}           xpath=//*[@text='Night Mode']
${list_item_time}            id=com.avjindersinghsekhon.minimaltodo:id/todoListItemTimeTextView
${dialog_ok}                 xpath=//*[@text='OK']
${snackbar_undo}             xpath=//*[@text='UNDO']

*** Keywords ***
Open Minimal Todo App
    AppiumLibrary.Open Application    ${APPIUM_SERVER_URL}    platformName=${platform_name}    deviceName=${device_name}    automationName=${automation_name}    app=${app_path}    appPackage=${app_package}    appActivity=${app_activity}    fullReset=${TRUE}    noReset=${FALSE}    autoGrantPermissions=${TRUE}    noSign=${TRUE}
    ${dialog_visible}=    Run Keyword And Return Status    AppiumLibrary.Page Should Contain Element    xpath=//*[@text='OK']
    Run Keyword If    ${dialog_visible}    AppiumLibrary.Click Element    xpath=//*[@text='OK']
    AppiumLibrary.Wait Until Page Contains Element    ${main_fab}    30s

Close Minimal Todo App
    Run Keyword And Ignore Error    Close Application

Go Back To Main
    ${on_main}=    Run Keyword And Return Status
    ...    AppiumLibrary.Page Should Contain Element    ${main_fab}
    Run Keyword If    not ${on_main}    AppiumLibrary.Go Back
    AppiumLibrary.Wait Until Page Contains Element    ${main_fab}    15s

Open Add Todo Screen
    AppiumLibrary.Click Element    ${main_fab}
    AppiumLibrary.Wait Until Element Is Visible    ${todo_title_input}    15s

Add Todo
    [Arguments]    ${title}    ${desc}=${EMPTY}
    Open Add Todo Screen
    AppiumLibrary.Input Text    ${todo_title_input}    ${title}
    ${desc_visible}=    Run Keyword And Return Status
    ...    AppiumLibrary.Page Should Contain Element    ${todo_description_input}
    Run Keyword If    '${desc}' != '${EMPTY}' and ${desc_visible}
    ...    AppiumLibrary.Input Text    ${todo_description_input}    ${desc}
    AppiumLibrary.Click Element    ${save_button}
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text='${title}']    15s

Open Overflow Menu
    Press Key Code    82

Edit Todo
    [Arguments]    ${old_title}    ${new_title}
    AppiumLibrary.Click Element    xpath=//*[@text='${old_title}']
    AppiumLibrary.Wait Until Page Contains Element    ${todo_title_input}    15s
    AppiumLibrary.Clear Text    ${todo_title_input}
    AppiumLibrary.Input Text    ${todo_title_input}    ${new_title}
    AppiumLibrary.Click Element    ${save_button}
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text='${new_title}']    15s

Delete Todo And Undo
    [Arguments]    ${title}
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text='${title}']    10s
    ${loc}=    AppiumLibrary.Get Element Location    xpath=//*[@text='${title}']
    AppiumLibrary.Swipe    start_x=700    start_y=${loc}[y]    end_x=30    end_y=${loc}[y]    duration=1000
    AppiumLibrary.Wait Until Page Contains Element    ${snackbar_undo}    8s
    AppiumLibrary.Click Element    ${snackbar_undo}
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text='${title}']    10s

Add Todo With Reminder
    [Arguments]    ${title}
    Open Add Todo Screen
    AppiumLibrary.Input Text    ${todo_title_input}    ${title}
    AppiumLibrary.Click Element    ${reminder_switch}
    AppiumLibrary.Wait Until Page Contains Element    ${date_field}    10s
    AppiumLibrary.Click Element    ${save_button}
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text='${title}']    15s


Open Settings And Toggle Night Mode
    Open Overflow Menu
    AppiumLibrary.Wait Until Page Contains Element    ${settings_menu_item}    10s
    AppiumLibrary.Click Element    ${settings_menu_item}
    AppiumLibrary.Wait Until Page Contains Element    ${settings_night_mode}    10s
    AppiumLibrary.Click Element    ${settings_night_mode}
    AppiumLibrary.Go Back
    AppiumLibrary.Wait Until Page Contains Element    ${main_fab}    15s

Verify Empty State
    AppiumLibrary.Wait Until Page Contains Element    ${empty_state}    15s
    AppiumLibrary.Wait Until Page Contains Element    xpath=//*[@text="You don't have any todos"]    15s
    AppiumLibrary.Page Should Contain Element    ${main_fab}

Verify Empty State Is Hidden
    AppiumLibrary.Page Should Not Contain Element    ${empty_state}

Verify Reminder Time Is Shown
    AppiumLibrary.Wait Until Page Contains Element    ${list_item_time}    10s

