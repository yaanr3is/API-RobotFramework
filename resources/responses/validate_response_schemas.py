from jsonschema import validate, ValidationError

def valid_contract(data, schema):
    try:
        validate(instance=data, schema=schema)
        print("✅ JSON válido!")
    except ValidationError as e:
        print(f"❌ JSON inválido: {e.message}")
        raise e
