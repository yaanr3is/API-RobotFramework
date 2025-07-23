def schema_warranty_card_accession():
    return {
    "type": "object",
    "properties": {
        "id": {
            "type": "integer"
        }
    },
    "required": ["id"],
    "additionalProperties": False
    }

def schema_warranty_card_transference():
    return {
    "type": "object",
    "properties": {
        "id": {
            "type": "integer"
        }
    },
    "required": ["id"],
    "additionalProperties": False
    }

def schema_warranty_card_rescue():
    return {
    "type": "object",
    "properties": {
        "id": {
            "type": "integer"
        }
    },
    "required": ["id"],
    "additionalProperties": False
    }