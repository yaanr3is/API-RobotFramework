*** Settings ***
Resource    ../../base.resource

*** Keywords ***

Create_Connection
    [Arguments]    ${BASE_URL}=${BASE_URL}
    Create Session    session    ${BASE_URL}

Make Request
    [Arguments]    ${METHOD}    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${HEADER}=${EMPTY}    ${PAYLOAD}=${EMPTY}    ${PARAMETER}=${EMPTY}
    Create_Connection    ${BASE_URL}

    ${FULL_ENDPOINT}=    Run Keyword If    '${PARAMETER}' != '${EMPTY}'    Set Variable    ${ENDPOINT}/${PARAMETER}    ELSE    Set Variable    ${ENDPOINT}

    ${ARGS}=    Create Dictionary    expected_status=any
    Run Keyword If    "${HEADER}" != "${EMPTY}"    Set To Dictionary    ${ARGS}    headers=${HEADER}
    Run Keyword If    "${PAYLOAD}" != "${EMPTY}"    Set To Dictionary    ${ARGS}    json=${PAYLOAD}

    ${RESPONSE}=    Run Keyword    ${METHOD} On Session    session    ${FULL_ENDPOINT}    &{ARGS}

    RETURN    ${RESPONSE}

Make Get Request
    [Arguments]    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${HEADER}=${EMPTY}    ${PARAMETER}=${EMPTY}
    ${response}=    Make Request    GET    BASE_URL=${BASE_URL}    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${PARAMETER}
    RETURN    ${response}

Make Post Request
    [Arguments]    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${HEADER}=${EMPTY}    ${PAYLOAD}=${EMPTY}
    ${response}=    Make Request    POST    ${BASE_URL}    ${ENDPOINT}    ${HEADER}    ${PAYLOAD}
    RETURN    ${response}

Make Put Request
    [Arguments]    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${HEADER}=${EMPTY}    ${PAYLOAD}=${EMPTY}
    ${response}=    Make Request    PUT    ${BASE_URL}    ${ENDPOINT}    ${HEADER}    ${PAYLOAD}
    RETURN    ${response}

Make Patch Request
    [Arguments]    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${PARAMETER}=${EMPTY}    ${HEADER}=${EMPTY}    ${PAYLOAD}=${EMPTY}
    ${response}=    Make Request    PATCH    ${BASE_URL}    ${ENDPOINT}    ${HEADER}    ${PAYLOAD}    ${PARAMETER}
    RETURN    ${response}

Make Delete Request
    [Arguments]    ${BASE_URL}=${BASE_URL}    ${ENDPOINT}=${EMPTY}    ${PARAMETER}=${EMPTY}    ${HEADER}=${EMPTY}
    ${response}=    Make Request    DELETE    ${BASE_URL}    ${ENDPOINT}    ${HEADER}    ${EMPTY}    ${PARAMETER}
    RETURN    ${response}

Make_Get_Request_TestPlan
    [Arguments]    ${HEADER}=${HEADER}    ${ENDPOINT}=${ENDPOINT}
    ${HEADER}=    Header TestPlan Generic
    RequestsLibrary.Create Session    session_testplan    https://dev.azure.com/ASAInvestments/Arquitetura/_apis/
        ${RESPONSE}     GET On Session    session_testplan    ${ENDPOINT}    expected_status=any
        ...             headers=${HEADER}
        ...             expected_status=any
    RETURN    ${RESPONSE}

Make_Post_Request_TestPlan
    [Arguments]    ${HEADER}=${HEADER}    ${ENDPOINT}=${ENDPOINT}    ${PAYLOAD}=${EMPTY}
    ${HEADER}=    Header TestPlan Generic
    RequestsLibrary.Create Session    session_testplan    https://dev.azure.com/ASAInvestments/Arquitetura/_apis/
        ${RESPONSE}     POST On Session    session_testplan    ${ENDPOINT}    expected_status=any
        ...             headers=${HEADER}
        ...             json=${PAYLOAD}
        RETURN    ${RESPONSE}

Make_Patch_Request_TestPlan
    [Arguments]    ${HEADER}=${HEADER}    ${ENDPOINT}=${ENDPOINT}    ${PAYLOAD}=${EMPTY}
    ${HEADER}=    Header TestPlan Generic
    RequestsLibrary.Create Session    session_testplan    https://dev.azure.com/ASAInvestments/Arquitetura/_apis/
        ${RESPONSE}     PATCH On Session    session_testplan    ${ENDPOINT}    expected_status=any
        ...             headers=${HEADER}
        ...             json=${PAYLOAD}
        RETURN    ${RESPONSE}