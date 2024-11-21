*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://fakestoreapi.com
${ID}    7

*** Test Cases ***
Get all products
    Create Session    API    ${BASE_URL}    verify=true
    ${res}    GET On Session    API    /products
    Status Should Be    200

Add new product
    Create Session    API    ${BASE_URL}    verify=true
    ${payload}=        Create Dictionary    title=test product    price=13.5    description=lorem ipsum set    image=https://i.pravatar.cc    category=electronics    
    ${res}    POST On Session    API    /products    data=${payload}
    Status Should Be    200
    ${res_body}=  Convert To Dictionary    ${res.json()}
    Dictionary Should Contain Key    ${res_body}    id

Add new product with invalid value
    Create Session    API    ${BASE_URL}    verify=true
    ${payload}=        Create Dictionary    title=test product
    ${res}    POST On Session    API    /products    data=${payload}
    Status Should Be    400

Update product - Success
    Create Session    API    ${BASE_URL}    verify=true
    ${payload}=        Create Dictionary    title=new title
    ${res}    PUT On Session    API    /products/${ID}    data=${payload}
    Status Should Be    200
    ${res_body}=  Convert To Dictionary    ${res.json()}
    Should Contain     ${res_body['title']}    new title

Update product with invalid id
    Create Session    API    ${BASE_URL}    verify=true
    ${payload}=        Create Dictionary    title=new title
    ${res}    PUT On Session    API    /products/9999    data=${payload}
    Status Should Be    404
    
Delete product - Success
    Create Session    API    ${BASE_URL}    verify=true
    ${res}    DELETE On Session    API    /products/${ID}
    Status Should Be    200
    ${res_body}=  Convert To Dictionary    ${res.json()}
    Dictionary Should Contain Key    ${res_body}    id

Delete product with invalid id
    Create Session    API    ${BASE_URL}    verify=true
    ${res}    DELETE On Session    API    /products/9999
    Status Should Be    404

Get all categories
    Create Session    API    ${BASE_URL}    verify=true
    ${res}    GET On Session    API    /products/categories
    Status Should Be    200
    Should Contain     ${res.json()}    electronics    jewelery    men's clothing    women's clothing

Sort results
    Create Session    API    ${BASE_URL}    verify=true
    ${params}=   Create Dictionary    sort=desc
    ${res}    GET On Session    API    /products    params=${params}
    Status Should Be    200
    ${products_id}=       Evaluate    [item["id"] for item in ${res.json()}]    json
    ${sorted_id}=  Evaluate    sorted(${products_id}, reverse=True)  
    Should Be Equal    ${products_id}    ${sorted_id}

 