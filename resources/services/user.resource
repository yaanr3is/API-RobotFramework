*** Settings ***
Resource    ../../base.resource

*** Keywords ***
List All Users
    ${HEADER}=    Header Generic
    ${RESPONSE}=    Make Get Request    ENDPOINT=${USER.ENDPOINT.ENDPOINT_USERS}    HEADER=${HEADER}
    RETURN    ${RESPONSE}

List Users By Id
    [Arguments]    @{PARAMETER}
    ${PARAMS}=    Convert List Of Pairs To Dictionary    @{PARAMETER}
    ${TEMPLATE}=    Set Variable    ${USER.PARAMETER.PARAMETER_FILTER}
    ${FINAL_PARAM}=    Build Parameter With Substitutions    ${TEMPLATE}    &{PARAMS}
    ${HEADER}=    Header Generic
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}
    ${RESPONSE}=    Make Get Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${FINAL_PARAM}
    RETURN    ${RESPONSE}

List Users By Name
    [Arguments]    @{PARAMETER}
    ${PARAMS}=    Convert List Of Pairs To Dictionary    @{PARAMETER}
    ${TEMPLATE}=    Set Variable    ${USER.PARAMETER.PARAMETER_FILTER}
    ${FINAL_PARAM}=    Build Parameter With Substitutions    ${TEMPLATE}    &{PARAMS}
    ${HEADER}=    Header Generic
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}
    ${RESPONSE}=    Make Get Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${FINAL_PARAM}
    RETURN    ${RESPONSE}

List Users By Email
    [Arguments]    @{PARAMETER}
    ${PARAMS}=    Convert List Of Pairs To Dictionary    @{PARAMETER}
    ${TEMPLATE}=    Set Variable    ${USER.PARAMETER.PARAMETER_FILTER}
    ${FINAL_PARAM}=    Build Parameter With Substitutions    ${template}    &{params}
    ${HEADER}=    Header Generic
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}
    ${RESPONSE}=    Make Get Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${FINAL_PARAM}
    RETURN    ${RESPONSE}

List Users By Email And Password
    [Arguments]    @{PARAMETER}
    ${PARAMS}=    Convert List Of Pairs To Dictionary    @{PARAMETER}
    ${TEMPLATE}=    Set Variable    ${USER.PARAMETER.PARAMETER_FILTER}
    ${FINAL_PARAM}=    Build Parameter With Substitutions    ${TEMPLATE}    &{PARAMS}
    ${HEADER}=    Header Generic
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}
    ${RESPONSE}=    Make Get Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${FINAL_PARAM}
    RETURN    ${RESPONSE}

List Users By Administrator
    [Arguments]    @{PARAMETER}
    ${PARAMS}=    Convert List Of Pairs To Dictionary    @{PARAMETER}
    ${TEMPLATE}=    Set Variable    ${USER.PARAMETER.PARAMETER_FILTER}
    ${FINAL_PARAM}=    Build Parameter With Substitutions    ${TEMPLATE}    &{PARAMS}
    ${HEADER}=    Header Generic
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}
    ${RESPONSE}=    Make Get Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}    PARAMETER=${FINAL_PARAM}
    RETURN    ${RESPONSE}

Register user successfully
    ${TIMESTAMP}=    Evaluate    int(__import__('time').time())
    ${RAND}=         Evaluate    ''.join(__import__('random').choices(__import__('string').ascii_lowercase + __import__('string').digits, k=6))
    ${EMAIL}=        Set Variable    user_${RAND}_${TIMESTAMP}@example.com
    ${HEADER}=    Header Generic
    ${PAYLOAD}    User Registration Payload    email=${EMAIL}
    ${RESPONSE}=    Make Post Request    ENDPOINT=${USER.ENDPOINT.ENDPOINT_USERS}    HEADER=${HEADER}    PAYLOAD=${PAYLOAD}
    RETURN    ${RESPONSE}

Delete user successfully
    ${ID_USER}=    Register user successfully
    ${HEADER}=    Header Generic
    ${PAYLOAD}    User Registration Payload
    ${ENDPOINT}=    Set Variable    ${USER.ENDPOINT.ENDPOINT_USERS}/${ID_USER}
    ${RESPONSE}=    Make Delete Request    ENDPOINT=${ENDPOINT}    HEADER=${HEADER}
    RETURN    ${RESPONSE}