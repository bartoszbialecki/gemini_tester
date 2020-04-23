*** Settings ***
Documentation   This is a test suite to test search functionality on the page.
Metadata        Version 1.0
Metadata        Author  Bartosz Białecki

Resource        ../resources/resource.robot

Test Setup      Go to the main page
Test Teardown   Close All Browsers

*** Test Cases ***
Search products on the page
    [Tags]  critical
    Enter search text in the search field and accept
    Check if found products contain searched text

Filter found products by page
    [Tags]  smoke
    Enter search text in the search field and accept
    Enter price ranges from min price to max price
    Accept price ranges filter
    Check if prices of found products are correct

*** Keywords ***
Enter search text in the search field and accept
    Input Text  ${SEARCH_INPUT}  ${SEARCH_TEXT}
    Press Keys  ${SEARCH_INPUT}  ENTER
    Sleep  2

Get list of all found products on the search page
    ${products}=  Get list of all products at ${SEARCH_PRODUCTS_LIST}
    [Return]  ${products}

Check if found products contain searched text
    ${products}=  Get list of all found products on the search page
    FOR  ${product}  IN  @{products}
        Go to the ${product} details page
        Searched product should appear on the page
        Go Back
        Sleep  2
    END

Check if prices of found products are correct
    ${min_price}=  Min price
    ${max_price}=  Max price
    ${products}=  Get list of all found products on the search page
    FOR  ${product}  IN  @{products}
        ${price}=  Get price of ${product}
        Should Be True  ${min_price} <= ${price} <= ${max_price}
    END

Go to the ${product} details page
    ${link}=  Get link of ${product}
    Click Link  ${link}
    Sleep  2

Enter price ranges from ${min_price} to ${max_price}
    ${inputs}=  Get WebElements  ${PRICE_RANGES_INPUTS}
    ${min}=  Run Keyword  ${min_price}
    ${max}=  Run Keyword  ${max_price}
    Input Text  ${inputs}[0]  ${min}
    Input Text  ${inputs}[1]  ${max}

Accept price ranges filter
    Click Element  ${PRICE_RANGES_BUTTON}
    Sleep  2

Searched product
    [Return]  ${SEARCH_TEXT}

Min price
    [Return]  ${15}

Max price
    [Return]  ${25}