def user_registration_payload(name="Fulano da Silva", email="beltrano@qa.com.br", password="teste", administrator="true"):
    return {
        "nome": f"{name}",
        "email": f"{email}",
        "password": f"{password}",
        "administrador": f"{administrator}"
    }