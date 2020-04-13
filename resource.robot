*** Settings ***
Documentation   This is a resource file with all reusable keywords and variables used by other test suites.

Library		SeleniumLibrary

*** Variables ***
${BROWSER}	                        Chrome
${URL}		                        https://www.aptekagemini.pl/

${PAGE_TITLE}                       Apteka Internetowa – Apteka Gemini

${VALID_USERNAME}	                tajiye2268@hubopss.com
${VALID_PASSWORD}	                test1234

${COOKIES_DIALOG}                   id:cookies-modal
${COOKIES_DIALOG_OK_BUTTON}         css:.cookies-close
${ACCOUNT_LINK}                     css:.nav-button-grid.login
${LOGIN_LINK}                       //a[contains(text(), 'Zaloguj się')]

${USERNAME_INPUT}                   id:st_form-user-email
${PASSWORD_INPUT}                   id:st_form-user-password
${LOGIN_BUTTON}                     css:.act_button.login

${LOGGED_IN_USER_EMAIL}             css:.user_mail
${ACCOUNT_DIALOG}                   css:.login
${LOGOUT_LINK}                      //div[@class='reg']/a[@href="https://www.aptekagemini.pl/user/logoutUser"]
${LOGIN_ERROR_TOOLTIP}              //div[@class='error_tooltip']/img
${LOGIN_ERROR_TOOLTIP_TEXT}         data-tooltip
${EMPTY_EMAIL_TEXT}                 Brak adresu email.
${WRONG_USERNAME_OR_PASSWORD_TEXT}  Zły login lub hasło.

${CREATE_ACCOUNT_LINK}              //a[@href='/user/createAccount']
${USER_ALREADY_EXISTS_TEXT}         Taki użytkownik już istnieje. 
${USER_EMAIL_INPUT}                 id:st_form-user-email
${USER_PASSWORD_INTPU}              id:st_form-user-password1
${USER_PASSWORD_MATCH_INPUT}        id:st_form-user-password2
${PRIVACY_CHECKBOX}                 id:st_form-user-privacy
${SIGN_UP_BUTTON}                   //div[@id='st_button-user-account']/button
${PASSWORD_TOO_SHORT_TEXT}          Podane hasło jest za krótkie min. 6 znaków.
${NO_PASSWORD_TEXT}                 Brak hasła.
${PASSWORDS_NOT_MATCH}              Hasła nie są takie same.
${ACCEPT_PRIVACY_TEXT}              Zaakceptuj regulamin

*** Keywords ***
Open Browser To Page
    Open Browser	                ${URL}	${BROWSER}
 	Title Should Be                 ${PAGE_TITLE}
    Close Cookies Info Dialog

Go To Login Page
    Wait Until Element Is Visible   ${ACCOUNT_LINK}
    Click Element                   ${ACCOUNT_LINK}
    Wait Until Element Is Visible   ${LOGIN_LINK}
    Click Element                   ${LOGIN_LINK}

Open Browser To Login Page
    Open Browser To Page
    Sleep                           5
    Go To Login Page

Close Cookies Info Dialog
    Wait Until Element Is Visible   ${COOKIES_DIALOG}
    Click Element                   ${COOKIES_DIALOG_OK_BUTTON}

Input Username
 	[Arguments]	    ${username}
 	Input Text	    ${USERNAME_INPUT}	${username}

Input User Password
 	[Arguments]	    ${password}
 	Input Password  ${PASSWORD_INPUT}	${password}	

Submit Credentials
 	Click Element   ${LOGIN_BUTTON}

Logout User
    Mouse Over                      ${ACCOUNT_DIALOG}
    Wait Until Element Is Visible   ${LOGOUT_LINK}
    Click Element                   ${LOGOUT_LINK}

# Close Privacy Policy Dialog If Appeared
# 	${present}=	Run Keyword And Return Status	Page Should Contain	Cenimy Twoją prywatność
# 	Run Keyword If	${present}	Close Privacy Policy Dialog
	
# Close Privacy Policy Dialog
# 	Click Element	//button[contains(text(), 'AKCEPTUJĘ')]
# 	Sleep	3s

# Go To Email Page
# 	Click Link	xpath=//a[@href="https://poczta.wp.pl"]