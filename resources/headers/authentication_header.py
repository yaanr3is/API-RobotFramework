import base64
import urllib.parse

def header_authentication():
    return {
        "Accept": "application/json",
        "Content-Type": "application/json"
    }