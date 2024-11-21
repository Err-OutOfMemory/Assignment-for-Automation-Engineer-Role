*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${saucedemo}    https://www.saucedemo.com/
${username}    standard_user
${password}    secret_sauce
${btnlogin}    //*[@id="login-button"]
${checkoutbtn}    //*[@id="checkout"]
${continuebtn}    //*[@id="continue"]
${finbtn}    //*[@id="finish"]
${fname}    secret
${lname}    sauce
${zip}    00000

*** Keywords ***
Open Web Saucedemo
    Open Browser    ${saucedemo}    chrome 

Verify login page
    Title Should Be    Swag Labs

Input Username Password
    [Arguments]    ${username}    ${password}
    Element Should Be Visible    //*[@id="user-name"]
    Element Should Be Visible    //*[@id="password"]
    Input Text       //*[@id="user-name"]       ${username}
    Input Text       //*[@id="password"]      ${password}

Input name and last name
    [Arguments]    ${name}    ${lastname}    ${zip}
    Element Should Contain        xpath=//*[@id="header_container"]//span[@class='title']    Checkout: Your Information
    Input Text       //*[@id="first-name"]     ${name}
    Input Text       //*[@id="last-name"]     ${lastname}
    Input Text       //*[@id="postal-code"]      ${zip}

*** Test Cases ***
Open browser and navigate to Saucedemo
    Open Web Saucedemo
    Verify login page

Login
    Input Username Password    ${username}    ${password}
    Click Element    ${btnlogin}
    Element Should Be Visible    //*[@id="shopping_cart_container"]

Add product to cart
    Click Button    //*[@id="add-to-cart-sauce-labs-backpack"]
    Element Should Be Visible   //*[@id="remove-sauce-labs-backpack"]
    Click Button    //*[@id="add-to-cart-sauce-labs-bike-light"]
    Element Should Be Visible    //*[@id="remove-sauce-labs-bike-light"]

Go to cart
    Click Element    //*[@id="shopping_cart_container"]/a
    Element Should Contain        xpath=//div[@class="inventory_item_name"]    Sauce Labs Backpack    Sauce Labs Bike Light

Checkout
    Click Button    ${checkoutbtn}
    Input name and last name    ${fname}    ${lname}    ${zip}
    Click Button    ${continuebtn}
    Wait Until Element Contains        xpath=//*[@id="header_container"]//span[@class='title']    Checkout: Overview
    Element Should Be Visible    //*[@id="checkout_summary_container"]//div[@class="summary_total_label"]
    Click Button    ${finbtn}
    Element Should Contain    xpath=//*[@id="checkout_complete_container"]/h2    Thank you for your order!
    Close Browser