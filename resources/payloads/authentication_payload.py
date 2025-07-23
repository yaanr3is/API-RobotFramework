import urllib.parse
import json

def payload_login_authentication(user="fulano@qa.com", password="teste"):
    return {
        "email": f"{user}",
        "password": f"{password}"
    }