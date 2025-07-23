*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections
Library           json
Library           OperatingSystem
Library           DateTime
Library           BuiltIn
Variables         disable_warnings.py
Library           yaml

### Custom Libraries
Library           env/load.py

Resource    keywords/common_keywords.resource

#Services
Resource    resources/services/index.resource

#Header
Resource    resources/headers/index.resource

#Response
Resource    resources/responses/validate_response_status_code.resource
Library     resources/responses/validate_response_schemas.py

#payload
Resource    resources/payloads/index.resource

#schemas
Resource    resources/schemas/index.resource

#authentication
Resource    resources/authentication/authentication.resource

#Variables
Variables   variables.yaml

### Custom Resources
Resource          resources/utils/http.robot

*** Variables ***

${BASE_URL}             %{BASE_URL=${EMPTY}}

### DATABASE CONNECTION PARAMS
${DB_PLATFORM_HOST}          %{DB_PLATFORM_HOST=${EMPTY}}
${DB_PLATFORM_PORT}          %{DB_PLATFORM_PORT=${EMPTY}}
${DB_PLATFORM_USER}          %{DB_PLATFORM_USER=${EMPTY}}
${DB_PLATFORM_PASSWORD}      %{DB_PLATFORM_PASSWORD=${EMPTY}}
${DB_PLATFORM_DBNAME}        %{DB_PLATFORM_DBNAME=${EMPTY}}
${DB_PLATFORM_ALIAS}         platform_asa
${DB_DRIVER}                 ODBC Driver 18 for SQL Server
${API_ENVIRONMENT}           %{API_ENVIRONMENT=${EMPTY}}
${YAML_FILE}                 env/${API_ENVIRONMENT}.yaml
${TESTPLAN}                  %{TESTPLAN=${EMPTY}}
${SUITE_EMPRESTIMO}          %{SUITE_EMPRESTIMO=${EMPTY}}



*** Variables ***
${YAML_FILE}    env/${API_ENVIRONMENT}.yaml

*** Keywords ***
Load Environment Variables Dynamically
    [Documentation]    Carrega todas as variáveis do YAML dinamicamente no formato ${CATEGORIA.SUBCHAVE}
    ...                Exemplo: ${LOGIN.BASE_URL}, ${API.TIMEOUT}, etc.

    # 1. Carrega o arquivo YAML de forma segura
    ${yaml_data}=    Load YAML File Safely    ${YAML_FILE}
    
    # 2. Valida e obtém os dados do ambiente
    ${env_data}=    Get Environment Data    ${yaml_data}    ${API_ENVIRONMENT}
    
    # 3. Processa e cria todas as variáveis dinamicamente
    Create Variables From Dict    ${env_data}

Load YAML File Safely
    [Arguments]    ${file_path}
    [Documentation]    Carrega o arquivo YAML com tratamento de erros
    TRY
        ${data}=    Evaluate    yaml.safe_load(open('${file_path}', 'r', encoding='utf-8'))    modules=yaml
        RETURN    ${data}
    EXCEPT    FileNotFoundError
        Fail    msg=Arquivo YAML não encontrado: ${file_path}
    EXCEPT    yaml.YAMLError as error
        Fail    msg=Erro ao analisar YAML: ${error}
    END

Get Environment Data
    [Arguments]    ${yaml_data}    ${environment}
    [Documentation]    Obtém os dados do ambiente especificado com validação
    Run Keyword If    not $yaml_data or $yaml_data is None
    ...    Fail    msg=Os dados do YAML estão vazios ou inválidos
    
    Run Keyword If    '${environment}' not in $yaml_data
    ...    Fail    msg=Ambiente '${environment}' não encontrado no YAML. Ambientes disponíveis: ${yaml_data.keys()}
    
    RETURN    ${yaml_data["${environment}"]}

Create Variables From Dict
    [Arguments]    ${data}    ${prefix}=${EMPTY}
    
    ${keys}=    Get Dictionary Keys    ${data}
    
    FOR    ${key}    IN    @{keys}
        ${value}=    Get From Dictionary    ${data}    ${key}
        ${full_key}=    Set Variable    ${prefix}${key}
        
        # Verifica se é dicionário usando Evaluate
        ${is_dict}=    Evaluate    isinstance($value, dict)
        
        IF    ${is_dict}
            Create Variables From Dict    ${value}    ${full_key}.
        ELSE
            Set Suite Variable    \${${full_key}}    ${value}
            Log    Variável definida: \${${full_key}} = ${value}    level=DEBUG
        END
    END