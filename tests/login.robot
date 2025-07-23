*** Settings ***
Resource    ../base.resource
Test Tags    LOGIN
Test Setup    Load Environment Variables Dynamically

*** Test Cases ***
Test Success Login
    ${RESPONSE}    Login successfully    RETURN=${True}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}