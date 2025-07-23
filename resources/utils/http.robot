*** Settings ***
Resource    ../../base.resource

*** Keywords ***
Validate Http Response
    [Arguments]    
    ...                ${response}
    ...                ${expectedStatus}

    Log                Validating response: expected=${expectedStatus}, received=${response.status_code}

    Should Be Equal As Numbers    ${response.status_code}    ${expectedStatus}  

Delete Data limite From Database
    ${query}    Set Variable    DELETE FROM [limite].SolicitacaoLimiteSufop WHERE CpfCnpj = '11440621000102'
    Execute SQL String    ${query}
    Log    "Registros deletados com sucesso!"