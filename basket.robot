*** Settings ***
Documentation   This is a test suite to test adding products to the basket.

Library         Collections
Library         String

Resource        resource.robot

Test Setup     Open Browser To Page
Test Teardown  Close Browser

*** Test Cases ***
Add 2 Products From Main Page
    Add 2 Products To Basket
    ${quantity}=        Get Text    ${BASKET_QUANTITY}
    Should Be Equal     ${quantity}     2
    
Add 2 Same Products From Main Page
    Click Element Using Javascript By Xpath     ${ADD_TO_BASKET_BUTTON}
    Sleep   2
    Click Element Using Javascript By Xpath     ${ADD_TO_BASKET_BUTTON}
    Sleep   2
    Open Basket
    Sleep   2
    Textfield Value Should Be   ${BASKET_PRODUCT_QUANTITY}     2

Add 3 Products From Main Page
    Set Selenium Timeout        30
    Add 3 Products To Basket
    Element Should Be Visible   ${LOGIN_SUGGESTION_DIALOG}

Add Correct Products To Basket
    ${products_list}=           Get List Of 2 Products At ${MAIN_PAGE_PRODUCTS}
    ${expected_total_price}=    Set Variable    ${0}
    FOR     ${product}          IN          @{products_list}
        ${price}=                   Get From Dictionary     ${product}      price
        ${expected_total_price}=    Evaluate                ${expected_total_price} + ${price}
        ${add_to_basket_element}=   Get From Dictionary     ${product}      add_to_basket_element
        Execute Javascript          ARGUMENTS               ${add_to_basket_element}    JAVASCRIPT  arguments[0].click();
        Sleep   2
    END
    Open Basket
    Sleep   2
    ${total_amount_string}=     Get Text                        ${BASKET_FIRST_STEP_TOTAL_PRICE}
    ${total_amount_string}=     Replace String                  ${total_amount_string}      ,   .
    ${total_amount_string}=     Replace String Using Regexp     ${total_amount_string}      [^0-9.]     ${EMPTY}
    ${total_amount}=            Convert To Number               ${total_amount_string}
    Should Be Equal             ${total_amount}                 ${expected_total_price}
    FOR     ${product}          IN          @{products_list}
        ${name}=                Get From Dictionary     ${product}      name
        Page Should Contain     ${name}
    END

Payment Flow
    Set Selenium Timeout            30
    Add 3 Products To Basket
    Sleep   2
    Wait Until Element Is Visible   ${LOGIN_SUGGESTION_DIALOG}
    Click Element                   ${LOGIN_SUGGESTION_DIALOG_LOGIN}
    Enter Credentials               ${VALID_USERNAME}       ${VALID_PASSWORD}
    Click Element                   ${BASKET_PAYMENT_BUTTON}
    Sleep   2
    Click Element                   ${BASKET_PAYMENT_BUTTON}
    Sleep   2
    ${pc}=  Get Element Count       ${BASKET_PRODUCTS_QUANTITY_COLUMN}
    ${quantity}=    Set Variable    ${0}
    FOR     ${index}     IN RANGE    2   ${pc+2}
        ${cell}=    Get Table Cell  ${BASKET_PRODUCTS_TABLE}   ${index}    4
        ${quantity}=    Evaluate    ${quantity}+${cell}
    END
    Should Be Equal                 ${quantity}     ${3}
    Page Should Contain Element     ${BASKET_CONFIRM_BUTTON}
    Go To Basket First Step
    Delete All Basket Products
    Logout User

*** Keywords ***
Add ${count} Products to Basket
    Execute Javascript      var buttons = window.document.getElementsByClassName('st_button-basket-submit-enabled');
    ...                     for (var index = 0; index < ${count}; index++) {
    ...                         buttons[index].click();
    ...                         await new Promise(r => setTimeout(r, 2000));
    ...                     }

Open Basket
    ${basket}=                      Get WebElement  ${BASKET_LINK}
    Wait Until Element Is Visible   ${basket}
    Mouse Down                      ${basket}
    Mouse Up                        ${basket}

Go To Basket First Step
    Click Element Using Javascript By Xpath     ${BASKET_FIRST_STEP}
    Sleep   2

Delete All Basket Products
    Click Link      ${BASKET_DELETE_PRODUCTS}
    Sleep   2