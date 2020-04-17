*** Settings ***
Documentation   This is a test suite to test search functionality on the page.

Resource        ../resources/resource.robot

Suite Setup     Open Browser To Page
Suite Teardown  Close Browser

*** Test Cases ***
Search Products
    Enter Search Text
    ${products}=    Get List Of All Products At ${SEARCH_PRODUCTS_LIST}
    FOR     ${product}      IN      @{products}
        ${link}=                Get From Dictionary     ${product}      link
        Click Link              ${link}
        Sleep   2
        Page Should Contain     ${SEARCH_TEXT}
        Go Back
        Sleep   2
    END

Filter Found Products By Price
    Enter Search Text
    ${max_price}=       Set Variable        ${25}
    ${inputs}=          Get WebElements     ${PRICE_RANGES_INPUTS}
    Input Text          ${inputs}[1]        ${max_price}
    Click Element       ${PRICE_RANGES_BUTTON}
    Sleep   2
    ${products}=    Get List Of All Products At ${SEARCH_PRODUCTS_LIST}
    FOR     ${product}      IN      @{products}
        ${price}=       Get From Dictionary     ${product}      price
        Should Be True  ${price} <= ${max_price}
    END

*** Keywords ***
Enter Search Text
    Input Text      ${SEARCH_INPUT}     ${SEARCH_TEXT}
    Press Keys      ${SEARCH_INPUT}     ENTER
    Sleep           2