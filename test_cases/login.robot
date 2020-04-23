*** Settings ***
Documentation   This is a test suite to test login functionality on the page.
Metadata        Version 1.0
Metadata        Author  Bartosz Białecki

Resource        ../resources/resource.robot

Test Setup     Go to the login page
Test Teardown  Close All Browsers
Test Template  Login with invalid credentials should fail

*** Test Cases ***                  USER                PASSWORD                ERROR
Empty username                      ${EMPTY}            ${VALID_PASSWORD}       ${EMPTY_EMAIL_TEXT}
Empty password                      ${VALID_USERNAME}   ${EMPTY}                ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Username and password are empty     ${EMPTY}            ${EMPTY}                ${EMPTY_EMAIL_TEXT}
Invalid username                    invalid             ${VALID_PASSWORD}       ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Invalid password                    ${VALID_USERNAME}   invalid                 ${WRONG_USERNAME_OR_PASSWORD_TEXT}
Invalid username and password       invalid             invalid                 ${WRONG_USERNAME_OR_PASSWORD_TEXT}

Valid username and password         [Template]          Login with valid credentials should succeed
                                    ${VALID_USERNAME}   ${VALID_PASSWORD}

*** Keywords ***
Login with invalid credentials should fail
    [Arguments]  ${username}  ${password}  ${expected_error}
    Enter user login credentials  ${username}  ${password}
    Login should fail with ${expected_error}

Login with valid credentials should succeed
    [Arguments]  ${username}  ${password}
    Enter user login credentials  ${username}  ${password}
 	Login should succeed
    Logout user

Login should succeed
    Page Should Contain  ${VALID_USERNAME}

Login should fail with ${error_message}
    Element Attribute Value Should Be  ${LOGIN_ERROR_TOOLTIP}  ${LOGIN_ERROR_TOOLTIP_TEXT}  ${error_message}