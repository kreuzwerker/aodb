#!/bin/sh
if [[ "${AODB_TARGET}" == "JIRA" ]]
then
  prefix="JIRA-backup"
elif [[ "${AODB_TARGET}" == "Confluence" ]]
then
  prefix="Confluence-backup"
else
  echo "Unknown target '${AODB_TARGET}'"
  exit 1
fi

BACKUP_FILE="$prefix-`date +'%Y%m%d'`.zip"
URL="https://${AODB_HOST}/webdav/backupmanager"

FILE_SIZE=$(curl -s --head -u "${AODB_USER}:${AODB_PASS}" "${URL}/${BACKUP_FILE}" | grep -i '^Content-Length:' | awk '{ print $2 }' | tr -d [[:space:]])

mkdir -p download
cd download

while [[ ! -f "${BACKUP_FILE}" || $(ls -al "${BACKUP_FILE}" | awk '{ print $5 }') -lt ${FILE_SIZE} ]]; do
  curl -k -u "${AODB_USER}:${AODB_PASS}" -C - -o "${BACKUP_FILE}" "${URL}/${BACKUP_FILE}";
  sleep 5;
done;

curl --request DELETE -u "${AODB_USER}:${AODB_PASS}" "${URL}/${BACKUP_FILE}"