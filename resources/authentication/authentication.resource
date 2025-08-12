*** Settings ***
Resource    ../../base.resource
Resource    ../requests/requests.resource

*** Keywords ***
Make Login Platform Request
    [Arguments]    ${RETURN}
    ${HEADER}=    Header Authentication
    ${PAYLOAD}=   Payload Login Authentication
    ${RESPONSE}=    Make Post Request    ENDPOINT=${LOGIN.ENDPOINT.ENDPOINT_LOGIN}    HEADER=${HEADER}    PAYLOAD=${PAYLOAD}
    ${TOKEN}    Set Variable    ${RESPONSE.json()}[authorization]
    Set Suite Variable    ${TOKEN}
    Set Test Variable     ${REQUEST}    ${PAYLOAD}
    Set Test Variable     ${RESPONSE}
    IF    "${RETURN}" != "False" 
        RETURN    ${RESPONSE}
    END