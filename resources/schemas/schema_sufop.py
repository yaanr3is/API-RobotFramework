def schema_sufop_consult_limit():
    return {
  "type": "object",
  "properties": {
    "cpfCnpj": {
      "type": "string"
    },
    "valor": {
      "type": "number"
    },
    "statusSolicitacao": {
      "type": "integer"
    },
    "idProduto": {
      "type": "integer"
    },
    "idPoc": {
      "type": "integer"
    },
    "id": {
      "type": "integer"
    }
  },
  "required": [
    "cpfCnpj",
    "valor",
    "statusSolicitacao",
    "idProduto",
    "idPoc",
    "id"
  ],
  "additionalProperties": False,
}


def schema_sufop_simulate_limit():
    return {
    "type": "object",
    "properties": {
      "codigoSimulacao": {
        "type": "integer"
      },
      "valorPrincipal": {
        "type": "number"
      },
      "valorLiberacao": {
        "type": "number"
      },
      "valorTotalJuros": {
        "type": "number"
      },
      "valorTotalMora": {
        "type": "number"
      },
      "valorTotalAPagar": {
        "type": "number"
      },
      "valorIof": {
        "type": "number"
      },
      "valorComissao": {
        "type": "number"
      },
      "valorTarifas": {
        "type": "number"
      },
      "taxaAMes": {
        "type": "number"
      },
      "taxaAAno": {
        "type": "number"
      },
      "indexador": {
        "type": "string"
      },
      "cet_mes": {
        "type": "number"
      },
      "cet_ano": {
        "type": "number"
      },
      "parcelas": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "nroParcela": {
              "type": "integer"
            },
            "dataVencimentoParcela": {
              "type": "string"
            },
            "valorPrincipalParcela": {
              "type": "number"
            },
            "jurosParcela": {
              "type": "number"
            },
            "saldoDevedorParcela": {
              "type": "number"
            },
            "valorTotalParcela": {
              "type": "number"
            }
          },
          "required": [
            "nroParcela",
            "dataVencimentoParcela",
            "valorPrincipalParcela",
            "jurosParcela",
            "saldoDevedorParcela",
            "valorTotalParcela"
          ],
          "additionalProperties": False,
        }
      },
      "tac": {
        "type": "number"
      }
    },
    "required": [
      "codigoSimulacao",
      "valorPrincipal",
      "valorLiberacao",
      "valorTotalJuros",
      "valorTotalMora",
      "valorTotalAPagar",
      "valorIof",
      "valorComissao",
      "valorTarifas",
      "taxaAMes",
      "taxaAAno",
      "indexador",
      "cet_mes",
      "cet_ano",
      "parcelas",
      "tac"
    ],
    "additionalProperties": False,
  }

def schema_sufop_request_limit():
    return {
        "type": "boolean"
    }

def schema_sufop_hire_limit():
    return {
      "type": "object",
      "properties": {
        "numeroContrato": {
          "type": "integer"
        },
        "contratoAssinatura": {
          "type": "string"
        },
        "assinaturaInterna": {
          "type": "boolean"
        },
        "dataLiberacaoContrato": {
          "type": "string"
        },
        "indexador": {
          "type": "string"
        }
      },
      "required": [
        "numeroContrato",
        "contratoAssinatura",
        "assinaturaInterna",
        "dataLiberacaoContrato",
        "indexador",
      ],
      "additionalProperties": False
    }