#!/bin/sh

poetry run robot --outputdir output tests/

[ -n "$TEAMS_WEBHOOK_URL" ] && echo "TEAMS_WEBHOOK_URL defined. Send test report..." && \
poetry run python /app/resources/utils/send_report.py "$TEAMS_WEBHOOK_URL" "$RELEASE_NAME" "$ENVIRONMENT"