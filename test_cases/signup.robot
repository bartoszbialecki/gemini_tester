*** Settings ***
Documentation   This is a test suite to test signup functionality on the page.

Resource        ../resources/resource.robot

Suite Setup     Go To Sign Up Page
Suite Teardown  Close Browser

*** Test Cases ***
Sign Up With Existing Email
    Enter Sign Up Data
    Sleep   3
    Page Should Contain     ${USER_ALREADY_EXISTS_TEXT}

Sign Up With Empty Email
    Enter Sign Up Data      email=${EMPTY}
    Sleep   3
    ${required}=            Get Element Attribute   ${USER_EMAIL_INPUT}      required
    Should Be Equal         ${required}     true

Sign Up With Short Password
     Enter Sign Up Data     123
     Sleep  3
     Page Should Contain    ${PASSWORD_TOO_SHORT_TEXT}

Sign Up With Empty Password
    Enter Sign Up Data      ${EMPTY}
    Sleep   3
    Page Should Contain     ${NO_PASSWORD_TEXT}

Sign Up With Different Passwords
    Enter Sign Up Data      ${VALID_PASSWORD}   other_password
    Sleep   3
    Page Should Contain     ${PASSWORDS_NOT_MATCH}

Sign Up Without Accepting Policy
    Set Selenium Speed              0.5 seconds
    Enter Sign Up Data      select_checkbox=False
    Sleep   3
    Page Should Contain     ${ACCEPT_PRIVACY_TEXT}

*** Keywords ***
Go To Sign Up Page
    Open Browser To Page
    Wait Until Element Is Visible   ${ACCOUNT_LINK}
    Click Element                   ${ACCOUNT_LINK}
    Wait Until Element Is Visible   ${CREATE_ACCOUNT_LINK}
    Click Link                      ${CREATE_ACCOUNT_LINK}

Enter Sign Up Data
    [Arguments]         ${password}=${VALID_PASSWORD}   ${password_match}=${password}     ${select_checkbox}=True   ${email}=${VALID_USERNAME}
    Input Text          ${USER_EMAIL_INPUT}             ${email}
    Input Password      ${USER_PASSWORD_INTPU}          ${password}
    Input Password      ${USER_PASSWORD_MATCH_INPUT}    ${password_match}
    Run Keyword If      ${select_checkbox}              Select Checkbox     ${PRIVACY_CHECKBOX}
    Run Keyword Unless  ${select_checkbox}              Unselect Checkbox   ${PRIVACY_CHECKBOX}    
    Click Element       ${SIGN_UP_BUTTON}