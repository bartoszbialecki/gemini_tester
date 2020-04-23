*** Settings ***
Documentation   This is a test suite to test signup functionality on the page.
Metadata        Version 1.0
Metadata        Author  Bartosz Białecki

Resource        ../resources/resource.robot

Default Tags    smoke

Test Setup      Go to the sign up page
Test Teardown   Close All Browsers

*** Variables ***
${SHORT_PASSWORD}   123
${OTHER_PASSWORD}   other_password

*** Test Cases ***
Sign up user with existing email
    Enter user sign up data and submit
    User already exists error message should appear on the page

Sign up user with empty email
    Enter user sign up data and submit  email=${EMPTY}
    Sign up with empty email should not be allowed

Sign up with short password
     Enter user sign up data and submit  password=${SHORT_PASSWORD}
     Password too short error message should appear on the page

Sign up with empty password
    Enter user sign up data and submit  password=${EMPTY}
    No password error message should appear on the page

Sign up with different passwords
    Enter user sign up data and submit  password_match=${OTHER_PASSWORD}
    Passwords not match error message should appear on the page

Sign up without accepting policy
    Enter user sign up data and submit  select_checkbox=False
    Accept policy error message should appear on the page

*** Keywords ***
Go to the sign up page
    Go to the main page
    Wait Until Element Is Visible  ${ACCOUNT_LINK}
    Click Element  ${ACCOUNT_LINK}
    Wait Until Element Is Visible  ${CREATE_ACCOUNT_LINK}
    Click Link  ${CREATE_ACCOUNT_LINK}

Enter user sign up data and submit
    [Arguments]  ${email}=${VALID_USERNAME}  ${password}=${VALID_PASSWORD}  ${password_match}=${password}  ${select_checkbox}=True
    Input Text  ${USER_EMAIL_INPUT}  ${email}
    Input Password  ${USER_PASSWORD_INTPU}  ${password}
    Input Password  ${USER_PASSWORD_MATCH_INPUT}  ${password_match}
    Run Keyword If  ${select_checkbox}  Select Checkbox  ${PRIVACY_CHECKBOX}
    Run Keyword Unless  ${select_checkbox}  Unselect Checkbox  ${PRIVACY_CHECKBOX}    
    Click Element  ${SIGN_UP_BUTTON}
    Sleep  3

Sign up with empty email should not be allowed
    ${required}=  Get Element Attribute  ${USER_EMAIL_INPUT}  required
    Should Be Equal  ${required}  true

User already exists error message
    [Return]  ${USER_ALREADY_EXISTS_TEXT}

Password too short error message
    [Return]  ${PASSWORD_TOO_SHORT_TEXT}

No password error message
    [Return]  ${NO_PASSWORD_TEXT}

Passwords not match error message
    [Return]  ${PASSWORDS_NOT_MATCH}

Accept policy error message
    [Return]  ${ACCEPT_PRIVACY_TEXT}