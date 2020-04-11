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
${COOKIES_DIALOG_OK_BUTTON}         css=.cookies-close
${ACCOUNT_LINK}                     css=.nav-button-grid.login
${LOGIN_LINK}                       //a[contains(text(), 'Zaloguj się')]

${USERNAME_INPUT}                   id:st_form-user-email
${PASSWORD_INPUT}                   id:st_form-user-password
${LOGIN_BUTTON}                     css=.act_button.login

${LOGGED_IN_USER_EMAIL}             css=.user_mail
${LOGOUT_LINK}                      //a[contains(text(), 'Wyloguj się')]
${LOGIN_ERROR_TOOLTIP}              //div[@class='error_tooltip']/img
${LOGIN_ERROR_TOOLTIP_TEXT}         data-tooltip
${EMPTY_EMAIL_TEXT}                 Brak adresu email.
${WRONG_USERNAME_OR_PASSWORD_TEXT}  Zły login lub hasło.

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
 	[Arguments]	${username}
 	Input Text	${USERNAME_INPUT}	${username}

Input Password
 	[Arguments]	${password}
 	Input Text	${PASSWORD_INPUT}	${password}	

Submit Credentials
 	Click Element   ${LOGIN_BUTTON}

Logout User
    Click Element   css=.login
    #Click Element   ${LOGOUT_LINK}
    Click Link      xpath=//a[@href="https://www.aptekagemini.pl/user/logoutUser"]

# Close Privacy Policy Dialog If Appeared
# 	${present}=	Run Keyword And Return Status	Page Should Contain	Cenimy Twoją prywatność
# 	Run Keyword If	${present}	Close Privacy Policy Dialog
	
# Close Privacy Policy Dialog
# 	Click Element	//button[contains(text(), 'AKCEPTUJĘ')]
# 	Sleep	3s

# Go To Email Page
# 	Click Link	xpath=//a[@href="https://poczta.wp.pl"]