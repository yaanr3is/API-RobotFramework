*** Settings ***
Resource    ../base.resource

*** Keywords ***
Remove Unfilled Placeholders
    [Arguments]    ${text}
    ${cleaned}=    Evaluate    re.sub(r'[?&]\\w+=\\{PARAM_[^}]+\\}', '', '''${text}''')    re
    RETURN    ${cleaned}


Convert List Of Pairs To Dictionary
    [Arguments]    @{param_pairs}
    &{PARAMS}=    Create Dictionary
    FOR    ${pair}    IN    @{param_pairs}
        ${kv}=    Split String    ${pair}    =
        Set To Dictionary    ${PARAMS}    ${kv[0]}=${kv[1]}
    END
    RETURN    &{PARAMS}

Build Parameter With Substitutions
    [Arguments]    ${template}    &{params}
    ${result}=    Set Variable    ${template}

    FOR    ${key}    ${value}    IN    &{params}
        ${result}=    Replace String    ${result}    {${key}}    ${value}
    END
    
    ${limpo}=    Remove Unfilled Placeholders    ${result}
    
    ${limpo}=    Replace String Using Regexp    ${limpo}    ^(&|&amp;)    ?
    
    RETURN    ${limpo}

Check Environment Test Setup
    [Arguments]    ${TEST_PLAN}    ${SUITE}
    IF    "${API_ENVIRONMENT}" != "DEV"
        Set Test Case ID as in progress    ${TEST_PLAN}    ${SUITE}    
    END

Set Test Case ID as in progress
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}
    ${TITLE}=    Set Variable    ${TEST NAME}
    ${MATCHES}=    Get Regexp Matches    ${TITLE}    \\[(.*?)\\]
    ${ID}=    Set Variable    ${MATCHES[0]}  
    ${ID}=    Replace String    ${ID}    [    ${EMPTY} 
    ${ID}=    Replace String    ${ID}    ]    ${EMPTY} 
    ${IS_AUTOMATED}    Check If Scenario Automated    ${ID}

    IF    "${IS_AUTOMATED}" != "Automatizado"
        Skip    Cenário consta como não automatizado no azure.
    END

    ${POINT_ID}    Get PointId    ${TESTPLAN_ID}    ${SUITE_ID}    ${ID}
    IF    "${POINT_ID}" == "${EMPTY}"
        Fail    Não foi encontrado o Test Case com base no ID.
    END

    Set Suite Variable    ${POINT_ID}
    ${ENDPOINT}    Set Variable    test/runs?api-version=7.1
    ${HEADER}    Header TestPlan Generic
    ${PAYLOAD}   Set Status InProgress Payload    ${TESTPLAN_ID}      ${POINT_ID}
    ${RESP}    Make_Post_Request_TestPlan    ${HEADER}    ${ENDPOINT}    ${PAYLOAD}
    Status Should Be    200    ${RESP}
    Sleep    3s

Get PointId
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}    ${TESTCASE_ID}
    ${ENDPOINT}    Set Variable    test/plans/${TESTPLAN_ID}/suites/${SUITE_ID}/points?testCaseId=${TESTCASE_ID}&api-version=7.1
    ${HEADER}    Header TestPlan Generic
    ${RESP}    Make_Get_Request_TestPlan    ${HEADER}    ${ENDPOINT}
    ${VALUE_LIST}    Set Variable    ${RESP.json()['value']}
    ${POINT_ID}    Set Variable    ${EMPTY}
    ${LIST_SIZE}    Evaluate    len(${VALUE_LIST})
    IF    ${LIST_SIZE} > 0
        ${POINT_ID}    Set Variable    ${VALUE_LIST[0]['id']} 
    END
    RETURN    ${POINT_ID}

Check If Scenario Automated
    [Arguments]    ${TESTCASE_ID}
    ${ENDPOINT}    Set Variable    wit/workitems/${TESTCASE_ID}?api-version=7.0
    ${HEADER}    Header TestPlan Generic
    ${RESP}    Make_Get_Request_TestPlan    ${HEADER}    ${ENDPOINT}
    ${JSON}=    Convert To Dictionary    ${RESP.json()}
    ${AUTOMATION}=    Set Variable If    "${JSON['fields'].get('Custom.f8db601c-3411-4a9c-8a3e-9017a04003ae', '')}" == ""    ${EMPTY}    ${JSON['fields'].get('Custom.f8db601c-3411-4a9c-8a3e-9017a04003ae')}
    RETURN    ${AUTOMATION}
    
Change Test Case ID to Approved
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID_TEST}
    ${ENDPOINT}    Set Variable    testplan/Plans/${TESTPLAN_ID}/Suites/${SUITE_ID}/TestPoint?includePointDetails=true&returnIdentityRef=true&api-version=7.1-preview.2
    ${HEADER}    Header TestPlan Generic
    ${PAYLOAD}   Set Status Approved Payload    ${POINT_ID_TEST}
    ${RESP}    Make_Patch_Request_TestPlan    ${HEADER}    ${ENDPOINT}    ${PAYLOAD}
    Status Should Be    200    ${RESP}

Change Test Case ID to Failed
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID_TEST}
    ${ENDPOINT}    Set Variable    testplan/Plans/${TESTPLAN_ID}/Suites/${SUITE_ID}/TestPoint?includePointDetails=true&returnIdentityRef=true&api-version=7.1-preview.2
    ${HEADER}    Header TestPlan Generic
    ${PAYLOAD}   Set Status Failed Payload    ${POINT_ID_TEST}
    ${RESP}    Make_Patch_Request_TestPlan    ${HEADER}    ${ENDPOINT}    ${PAYLOAD}
    Status Should Be    200    ${RESP}

Get Last Run
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID_TEST}
    ${ENDPOINT}=    Set Variable    testplan/Plans/${TESTPLAN_ID}/Suites/${SUITE_ID}/TestPoint/${POINT_ID_TEST}?api-version=7.1-preview.2
    ${HEADER}=      Header TestPlan Generic
    ${RESP}=        Make_Get_Request_TestPlan    ${HEADER}    ${ENDPOINT}
    Log             ${RESP.json()}
    ${TEST_POINTS}=    Get From Dictionary    ${RESP.json()}    value    ${EMPTY}
    
    ${FILTERED_POINTS}=    Create List
    FOR    ${ITEM}    IN    @{TEST_POINTS}
        ${HAS_RESULTS}=    Run Keyword And Return Status    Get From Dictionary    ${ITEM}    results
        ${HAS_RUN_ID}=     Run Keyword And Return Status    Get From Dictionary    ${ITEM['results']}    lastTestRunId
        ${HAS_DATE}=       Run Keyword And Return Status    Get From Dictionary    ${ITEM['results']['lastResultDetails']}    dateCompleted
        IF    ${HAS_RESULTS} and ${HAS_RUN_ID} and ${HAS_DATE}
            Append To List    ${FILTERED_POINTS}    ${ITEM}
        END
    END

    ${SORTABLE_LIST}=    Create List
    FOR    ${ITEM}    IN    @{FILTERED_POINTS}
        ${DATE}=    Get From Dictionary    ${ITEM['results']['lastResultDetails']}    dateCompleted
        ${ENTRY}=    Create List    ${DATE}    ${ITEM}
        Append To List    ${SORTABLE_LIST}    ${ENTRY}
    END

    ${SORTED_LIST}=    Evaluate    sorted(${SORTABLE_LIST}, key=lambda x: x[0], reverse=True)    modules=__main__
    ${LIST_LENGTH}=    Get Length    ${SORTED_LIST}

    IF    ${LIST_LENGTH} > 0
        ${LATEST_ENTRY}=    Get From List    ${SORTED_LIST}    0
        ${LATEST_RUN}=      Get From List    ${LATEST_ENTRY}    1
        ${LATEST_TEST_RUN_ID}=    Get From Dictionary    ${LATEST_RUN['results']}    lastTestRunId
        ${LATEST_RESULT_ID}=      Get From Dictionary    ${LATEST_RUN['results']}    lastResultId
    ELSE
        Log To Console    Nenhuma execução encontrada na resposta.
        ${LATEST_TEST_RUN_ID}=    Set Variable    ${NONE}
        ${LATEST_RESULT_ID}=      Set Variable    ${NONE}
    END

    RETURN    ${LATEST_TEST_RUN_ID}    ${LATEST_RESULT_ID}

Get Base Name
    [Arguments]    ${FILE_PATH}
    ${NAME}=    Evaluate    os.path.basename(r"${FILE_PATH}")    os
    RETURN    ${NAME}

Convert image to Base64
    [Arguments]    ${file_path}
    ${base64_data}=    Evaluate    base64.b64encode(open('${file_path}', "rb").read()).decode("utf-8")    modules=base64
    RETURN    ${base64_data}

Update Test Execution in Testplan and Attach Evidence
    [Arguments]    ${TESTPLAN_ID}    ${SUITE_ID}
    Run Keyword If    '${TEST STATUS}' == 'PASS'    Change Test Case ID to Approved    ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID}
    Run Keyword If    '${TEST STATUS}' == 'FAIL'    Change Test Case ID to Failed      ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID}
    ${VALUES}=    Get Last Run    ${TESTPLAN_ID}    ${SUITE_ID}    ${POINT_ID}
    ${TEST_RUN_ID}=    Get From List    ${VALUES}    0
    ${RESULT_ID}=    Get From List    ${VALUES}    1

    IF    "${API_ENVIRONMENT}" == "HML"
        ${RESULTS_DIR}=    Set Variable    ${EXECDIR}${/}report_hml${/}${TEST NAME}
        Create Directory    ${RESULTS_DIR}
        ${FILENAME}=    Set Variable    ${RESULTS_DIR}${/}evidencia.json
        Create File    ${FILENAME}    {"status": "${TEST STATUS}", "request": "${REQUEST}", "response": "${RESPONSE.json()}"}
        Attach File on Last Run    ${TEST_RUN_ID}    ${RESULT_ID}    ${FILENAME}
    END
        

Attach File on Last Run
    [Arguments]    ${LATEST_TEST_RUN_ID}    ${LATEST_RESULT_ID}    ${FILE_PATH}
    Sleep    1s
    ${ENDPOINT}    Set Variable    test/Runs/${LATEST_TEST_RUN_ID}/Results/${LATEST_RESULT_ID}/Attachments?api-version=7.1
    ${HEADER}    Header TestPlan Generic
    ${PAYLOAD}=    attach_file_last_run    ${FILE_PATH}
    ${RESP}    Make_Post_Request_TestPlan    ${HEADER}    ${ENDPOINT}    ${PAYLOAD}
    Status Should Be    200    ${RESP}

Check Environment Test Teardown
    [Arguments]    ${TEST_PLAN}    ${SUITE}
    IF    "${API_ENVIRONMENT}" != "DEV"
        Update Test Execution in Testplan and Attach Evidence    ${TEST_PLAN}    ${SUITE}
    END
    