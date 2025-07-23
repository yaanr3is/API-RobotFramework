*** Settings ***
Resource    ../../base.resource

*** Keywords ***
Login successfully
    [Arguments]    ${RETURN}=${True}
    ${RESPONSE}    Make Login Platform Request    ${RETURN}
    RETURN    ${RESPONSE}