*** Settings ***
Documentation   This is a test suite to test adding products to the basket.
Metadata        Version 1.0
Metadata        Author  Bartosz Białecki

Resource        ../resources/resource.robot

Default Tags    smoke

Test Setup      Go to the main page
Test Teardown   Close All Browsers

*** Test Cases ***
Add 2 products from the main page
    Add 2 products to the basket
    Quantity of products next to the basket icon in the header should be equal 2
    
Add 2 same products from the main page
    Add 2 the same products to the basket
    Open the basket
    Quantity of products in the basket should be equal 2

Add 3 products from the main page
    Set Selenium Timeout  30
    Add 3 products to the basket
    Login suggestion dialog should appear

Add correct products to the basket
    [Tags]  critical
    ${products_list}  ${expected_total_price}=  Add 2 products to the basket and compute total price
    Open the basket
    Total price of the products should be equal to ${expected_total_price}
    Correct products should appear on the ${products_list}

Payment flow
    [Tags]  high
    Set Selenium Timeout  30
    Add 3 products to the basket
    Click login button in the login suggestion dialog
    Enter user login credentials  ${VALID_USERNAME}  ${VALID_PASSWORD}
    Click next step button
    Click next step button
    It should be the last step
    Check if quantity of the products on the last step is equal 3
    Go to the basket first step
    Delete all products from the basket
    Logout user

*** Keywords ***
Add ${count:\d+} products to the basket
    Execute Javascript      var buttons = window.document.getElementsByClassName('st_button-basket-submit-enabled');
    ...                     for (var index = 0; index < ${count}; index++) {
    ...                         buttons[index].click();
    ...                         await new Promise(r => setTimeout(r, 2000));
    ...                     }

Add ${count:\d+} the same products to the basket
    FOR  ${i}  IN RANGE  ${count}
        Click element on the page using javascript by xpath  ${ADD_TO_BASKET_BUTTON}
        Sleep  2
    END

Add ${count:\d+} products to the basket and compute total price
    ${products_list}=  Get list of 2 products at ${MAIN_PAGE_PRODUCTS}
    ${expected_total_price}=  Set Variable  ${0}
    FOR  ${product}  IN  @{products_list}
        ${price}=  Get price of ${product}
        ${expected_total_price}=  Evaluate  ${expected_total_price} + ${price}
        ${add_to_basket_element}=  Get add_to_basket_element of ${product}
        Execute Javascript  ARGUMENTS  ${add_to_basket_element}  JAVASCRIPT  arguments[0].click();
        Sleep  2
    END
    [Return]  ${products_list}  ${expected_total_price}

Open the basket
    ${basket}=  Get WebElement  ${BASKET_LINK}
    Wait Until Element Is Visible  ${basket}
    Mouse Down  ${basket}
    Mouse Up  ${basket}
    Sleep  2

Go to the basket first step
    Click element on the page using javascript by xpath  ${BASKET_FIRST_STEP}
    Sleep  2

Delete all products from the basket
    Click Link  ${BASKET_DELETE_PRODUCTS}
    Sleep  2

Quantity of products next to the basket icon in the header should be equal ${count:\d+}
    ${quantity}=  Get Text  ${BASKET_QUANTITY}
    Should Be Equal As Integers  ${quantity}  ${count}

Quantity of products in the basket should be equal ${count:\d+}
    Textfield Value Should Be  ${BASKET_PRODUCT_QUANTITY}  ${count}

Login suggestion dialog should appear
    Element Should Be Visible  ${LOGIN_SUGGESTION_DIALOG}

Total price of the products should be equal to ${price}
    ${total_amount_string}=  Get Text  ${BASKET_FIRST_STEP_TOTAL_PRICE}
    ${total_amount_string}=  Replace String  ${total_amount_string}  ,  .
    ${total_amount_string}=  Replace String Using Regexp  ${total_amount_string}  [^0-9.]  ${EMPTY}
    ${total_amount}=  Convert To Number  ${total_amount_string}
    Should Be Equal As Numbers  ${total_amount}  ${price}

Correct products should appear on the ${products_list}
    FOR  ${product}  IN  @{products_list}
        ${name}=  Get name of ${product}
        Page Should Contain  ${name}
    END

Click login button in the login suggestion dialog
    Wait Until Element Is Visible  ${LOGIN_SUGGESTION_DIALOG}
    Click Element  ${LOGIN_SUGGESTION_DIALOG_LOGIN}

Click next step button
    Click Element  ${BASKET_PAYMENT_BUTTON}
    Sleep  2

Check if quantity of the products on the last step is equal ${count:\d+}
    ${pc}=  Get Element Count  ${BASKET_PRODUCTS_QUANTITY_COLUMN}
    ${quantity}=  Set Variable  ${0}
    FOR  ${index}  IN RANGE  2  ${pc+2}
        ${cell}=  Get Table Cell  ${BASKET_PRODUCTS_TABLE}  ${index}  4
        ${quantity}=  Evaluate  ${quantity}+${cell}
    END
    Should Be Equal As Integers  ${quantity}  ${count}

It should be the last step
    Page Should Contain Element  ${BASKET_CONFIRM_BUTTON}