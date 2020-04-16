*** Settings ***
Documentation   This is a test suite to test login functionality on the page.

Resource        ../resources/resource.robot

Suite Setup     Open Browser To Login Page
Suite Teardown  Close Browser
Test Template   Login With Invalid Credentials Should Fail

*** Test Cases ***              USER                PASSWORD                ERROR
Empty Username                  ${EMPTY}            ${VALID_PASSWORD}       ${EMPTY_EMAIL_TEXT}
Empty Password                  ${VALID_USERNAME}   ${EMPTY}                ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Username And Password Empty     ${EMPTY}            ${EMPTY}                ${EMPTY_EMAIL_TEXT}
Invalid Username                invalid             ${VALID_PASSWORD}       ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Invalid Password                ${VALID_USERNAME}   invalid                 ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Invalid Username And Password   invalid             invalid                 ${WRONG_USERNAME_OR_PASSWORD_TEXT}

Valid Username And Password     [Template]          Login With Valid Credentials Should Succeed
                                ${VALID_USERNAME}   ${VALID_PASSWORD}

*** Keywords ***
Login With Invalid Credentials Should Fail
    [Arguments]                         ${username}     ${password}     ${expected_error}
    Enter Credentials                   ${username}     ${password}
    Login Should Fail                   ${expected_error}

Login With Valid Credentials Should Succeed
    [Arguments]                         ${username}     ${password}
    Enter Credentials                   ${username}     ${password}
 	Login Should Succeed
    Logout User

Login Should Succeed
    Page Should Contain                 ${VALID_USERNAME}

Login Should Fail
    [Arguments]                         ${expected_error}
    Element Attribute Value Should Be   ${LOGIN_ERROR_TOOLTIP}      ${LOGIN_ERROR_TOOLTIP_TEXT}    ${expected_error}