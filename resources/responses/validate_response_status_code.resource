*** Keywords ***
Validate_Response_Status
    [Arguments]    ${RESPONSE}    ${EXPECTED_STATUS}
    ${EXPECTED_STATUS}    Convert To Integer    ${EXPECTED_STATUS}
    Should Be Equal    ${RESPONSE.status_code}    ${EXPECTED_STATUS}
