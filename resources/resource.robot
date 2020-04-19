*** Settings ***
Documentation   This is a resource file with all reusable keywords and variables used by other test suites.

Library		SeleniumLibrary
Library     Collections
Library     String

*** Variables ***
${BROWSER}	                        Chrome
${URL}		                        https://www.aptekagemini.pl/

${PAGE_TITLE}                       Apteka Internetowa – Apteka Gemini

${VALID_USERNAME}	                valid_username
${VALID_PASSWORD}	                valid_password

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
${LOGOUT_TEXT}                      Pomyślnie wylogowano użytkownika:
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

${ADD_TO_BASKET_BUTTON}             //input[@class='st_button-basket-submit-enabled']
${BASKET_QUANTITY}                  //div[@id='basket_show']/small[@class='quantity']
${BASKET_LINK}                      //a[@href='/basket/index']
${BASKET_PRODUCT_QUANTITY}          //td[@class='st_basket-product-num']//input[@class='quantity']
${LOGIN_SUGGESTION_DIALOG}          id:login-suggestion
${LOGIN_SUGGESTION_DIALOG_LOGIN}    id:loginUser
${BASKET_PAYMENT_BUTTON}            css:.dane-zamowienia-button
${BASKET_PRODUCTS_TABLE}            st_order_products
${BASKET_PRODUCTS_QUANTITY_COLUMN}  //td[@class='st_basket-product-num']
${BASKET_CONFIRM_BUTTON}            id:confirm_button
${BASKET_FIRST_STEP}                //div[contains(@class, 'b-step1')]
${BASKET_FIRST_STEP_TOTAL_PRICE}    css:.st_delivery-basket_summaty-amount
${BASKET_DELETE_PRODUCTS}           /basket/clear

${MAIN_PAGE_PRODUCTS}               //div[contains(@class, 'product_scroller')]//div[contains(@class, 'item')]
${PRODUCT_ID}                       data-id

${SEARCH_TEXT}                      Kudzu Root
${SEARCH_INPUT}                     st_search_search
${SEARCH_PRODUCTS_LIST}             //div[@id='list']//div[contains(@class, 'item')]
${PRICE_RANGES_INPUTS}              css:.ais-price-ranges--input
${PRICE_RANGES_BUTTON}              css:.ais-price-ranges--button

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
    Sleep   1

Input Username
 	[Arguments]	    ${username}
 	Input Text	    ${USERNAME_INPUT}	${username}

Input User Password
 	[Arguments]	    ${password}
 	Input Password  ${PASSWORD_INPUT}	${password}	

Submit Credentials
 	Click Element   ${LOGIN_BUTTON}

Enter Credentials
    [Arguments]                         ${username}     ${password}
    Input Username                      ${username}
    Input User Password                 ${password}
    Submit Credentials
    Sleep   2

Logout User
    Mouse Over                      ${ACCOUNT_DIALOG}
    Wait Until Element Is Visible   ${LOGOUT_LINK}
    Click Element                   ${LOGOUT_LINK}
    Sleep   2
    Page Should Contain             ${LOGOUT_TEXT}


Click Element Using Javascript By Xpath
    [Arguments]             ${xpath}
    Execute Javascript      document.evaluate("${xpath}", document.body, null, 9, null).singleNodeValue.click();

Click Element Using Javascript By Id
    [Arguments]             ${id}
    Execute Javascript      document.getElementById('${id}').click();

Get Child Webelements
    [Arguments]     ${element}

    ${children}     Call Method       
    ...                ${element}    
    ...                find_elements
    ...                by=xpath       value=child::*

    [Return]      ${children}

Get List Of ${count} Products At ${products_locator}
    @{products_list}=           Create List
    ${products}=                Get WebElements             ${products_locator}
    ${index}=                   Set Variable                ${0}
    FOR         ${product}      IN      @{products}
        &{item}=                Create Dictionary
        ${item_id}=             Get Element Attribute       ${product}              ${PRODUCT_ID}
        Set To Dictionary       ${item}                     id=${item_id}
        ${name}=                Execute Javascript          ARGUMENTS               ${product}       JAVASCRIPT  return arguments[0].querySelector('.name a').text.trim();
        Set To Dictionary       ${item}                     name=${name}
        ${link}=                Execute Javascript          ARGUMENTS               ${product}       JAVASCRIPT  return arguments[0].querySelector('.name a').href;
        Set To Dictionary       ${item}                     link=${link}
        ${price_string}=        Execute Javascript          ARGUMENTS               ${product}       JAVASCRIPT  return arguments[0].querySelector('.price span').innerHTML;
        ${price_string}=        Replace String              ${price_string}         ,   .
        ${price}=               Convert To Number           ${price_string}
        Set To Dictionary       ${item}                     price=${price}
        ${basket_element}=      Execute Javascript          ARGUMENTS               ${product}       JAVASCRIPT  return arguments[0].querySelector('.st_button-basket-submit-enabled');
        Set To Dictionary       ${item}                     add_to_basket_element=${basket_element}
        Append To List          ${products_list}            ${item}
        ${index}=               Set Variable                ${index + 1}
        Run Keyword If          '${index}' == '${count}'    Exit For Loop
    END
    [Return]                    ${products_list}