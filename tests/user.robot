*** Settings ***
Resource    ../base.resource
Test Tags    USER
Test Setup    Load Environment Variables Dynamically

*** Test Cases ***
Test Get All Users
    ${RESPONSE}    List All Users
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}

Test Get User By Id
    ${RESPONSE}    List Users By Id    PARAM_ID=0k55oQFkpa4lgw6m
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}

Test Get User By Name
    ${RESPONSE}    List Users By Name    PARAM_NOME=User Number 1570
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}

Test Get User By Email
    ${RESPONSE}    List Users By Email    PARAM_EMAIL=name.1570@qa.com
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}

Test Get User By Email And Password
    ${RESPONSE}    List Users By Email And Password    PARAM_EMAIL=name.1570@qa.com    PARAM_PASSWORD=teste
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}

Test Register user successfully
    ${RESPONSE}    Register user successfully
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.CREATED}

Test Delete user successfully
    ${RESPONSE}    Delete user successfully
    Log    ${RESPONSE.json()}
    Validate Response Status    ${RESPONSE}    ${STATUS_CODE.SUCCESS}