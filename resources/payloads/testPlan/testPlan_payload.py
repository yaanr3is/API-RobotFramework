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

def attach_image_last_run(image_base64, file_name):
    return {
        "attachmentType": "GeneralAttachment",
        "comment": "Executor: Automação",
        "fileName": file_name,
        "contentType": "image/png",
        "stream": image_base64
    }