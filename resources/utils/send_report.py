import xml.etree.ElementTree as ET
import requests
import sys

def generate_report(xml_file="output/output.xml", release_name="Unknown", env_name="Unknown"):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    total_tests, passed_tests, failed_tests = 0, 0, 0

    stat_total = root.find(".//statistics/total/stat")
    if stat_total is not None and stat_total.text == "All Tests":
        passed_tests = int(stat_total.get("pass", 0))
        failed_tests = int(stat_total.get("fail", 0))
        total_tests = passed_tests + failed_tests

    report = []
    report.append("📊 AUTOMATED TEST REPORT 📊")
    report.append("=" * 50)
    report.append(f"🚀 Release: **{release_name}**")
    report.append(f"🛠️ Stage: **{env_name}**")
    report.append("=" * 50)
    report.append(f"🔹 Total Tests Executed: {total_tests}")
    report.append(f"✅ Tests Passed: {passed_tests}")
    report.append(f"❌ Tests Failed: {failed_tests}")
    report.append("=" * 50)

    report.append("\n📌 Test Execution Details:")

    for test in root.findall(".//test"):
        test_name = test.get("name")
        status_elem = test.find("status")
        status = status_elem.get("status") if status_elem is not None else "UNKNOWN"

        if status == "PASS":
            report.append(f"✅ {test_name}")
        else:
            report.append(f"❌ {test_name}")
            # error_message = test.find(".//msg")
            # error_text = error_message.text.strip() if error_message is not None else "No details."
            # report.append(f"   🔴 ERROR: {error_text}")

    return "\n".join(report)

def send_report(webhook_url, report_content):
    payload = {"text": report_content.replace("\n", "\n\n")}
    headers = {"Content-Type": "application/json"}
    response = requests.post(webhook_url, json=payload, headers=headers)
    if response.status_code == 200:
        print("✅ Report successfully sent to Teams!")
    else:
        print(f"❌ Failed to send report. Status code: {response.status_code}, Response: {response.text}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("❌ Usage: python script.py <TEAMS_WEBHOOK_URL> <RELEASE_NAME> <ENVIRONMENT>")
        sys.exit(1)
    
    TEAMS_WEBHOOK_URL = sys.argv[1]
    RELEASE_NAME = sys.argv[2]
    ENVIRONMENT = sys.argv[3]

    report_content = generate_report(release_name=RELEASE_NAME, env_name=ENVIRONMENT)    
    send_report(TEAMS_WEBHOOK_URL, report_content)
