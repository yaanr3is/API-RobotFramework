import base64
import mimetypes
import os

def set_status_inProgress_payload(testPlanId, pointIdTest):
    return {
        "name": "Execução automatizada via API",
        "plan": {
            "id": testPlanId
        },
        "pointIds": [
            pointIdTest
        ]
    }

def set_status_approved_payload(pointIdTest):
    return [{
        "id": pointIdTest,
        "results": {
            "outcome": 2
        }
    }]

def set_status_failed_payload(pointIdTest):
    return [{
        "id": pointIdTest,
        "results": {
            "outcome": 3
        }
    }]

def attach_file_last_run(file_path):
    with open(file_path, "rb") as f:
        base64_content = base64.b64encode(f.read()).decode("utf-8")
    file_name = os.path.basename(file_path)
    content_type, _ = mimetypes.guess_type(file_path)
    if content_type is None:
        content_type = "application/octet-stream"  # fallback
    
    return {
        "attachmentType": "GeneralAttachment",
        "comment": "Executor: Automação",
        "fileName": file_name,
        "contentType": content_type,
        "stream": base64_content
    }