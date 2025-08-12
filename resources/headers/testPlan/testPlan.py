import os
from dotenv import load_dotenv

load_dotenv()

def header_testPlan_generic():
      return {
        'Content-Type': 'application/json',
        'Authorization': f'{os.getenv("FAT")}'
    }
