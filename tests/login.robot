*** Settings ***
Resource    ../base.resource
Test Tags    LOGIN
Test Setup    Run Keywords    Load Environment Variables Dynamically    AND    
...    Check Environment Test Setup    ${TESTPLAN}    ${SUITE_TEST}
Test Teardown    Check Environment Test Teardown    ${TESTPLAN}    ${SUITE_TEST}

*** Test Cases ***
Test Case [47836] - Test Success Login
    ${RESPONSE}    Login successfully    RETURN=${True}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}