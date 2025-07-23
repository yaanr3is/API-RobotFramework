*** Settings ***
Library           String
Library           Collections
Library           BuiltIn

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