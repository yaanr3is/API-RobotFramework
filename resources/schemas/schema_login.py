def schema_login():
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
