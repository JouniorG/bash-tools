#!/bin/bash
#
# dnsdumpster.com  sub-domain check by whitec0de
#

OKBLUE='\033[94m'
OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'
TARGET="$1"

echo ""
echo -e "$OKBLUE  ____/ /___  _________/ /_  ______ ___  ____  _____/ /____  _____ _________  ____ ___ $RESET"
echo -e "$OKBLUE / __  / __ \/ ___/ __  / / / / __  __ \/ __ \/ ___/ __/ _ \/ ___// ___/ __ \/ __   __ $RESET"
echo -e "$OKBLUE/ /_/ / / / (__  ) /_/ / /_/ / / / / / / /_/ (__  ) /_/  __/ /  _/ /__/ /_/ / / / / / /$RESET"
echo -e "$OKBLUE\__,_/_/ /_/____/\__,_/\__,_/_/ /_/ /_/ .___/____/\__/\___/_/  (_)___/\____/_/ /_/ /_/ $RESET"
echo -e "$OKBLUE                                     /_/                                               $RESET"
echo -e "$OKBLUE [+] by C0de$RESET"
echo -e "$OKBLUE [-] Usage: dnsdumpster.sh <target>$RESET"
echo -e "$OKBLUE [-] example: dnsdumpster.sh google.com$RESET"
if [[ -z $TARGET ]] || [[ $TARGET = "--help" ]]; then
	echo -e "$OKRED [?] You need <target> parameter $RESET"
	exit
fi

agent="Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.3) Gecko/20100401 Firefox/3.6.3"
url="https://dnsdumpster.com/"
name_domain=$(echo ${TARGET} | awk -F. '{print $1}')
regex_csrf="([a-zA-Z0-9]{32})"
regex_subdomain="<tr><td.*\">([a-zA-Z0-9\-\.]*$name_domain[a-zA-Z0-9\-\.]*)<br>"
regex_subdomain2="[a-zA-Z0-9\.\-]+$name_domain[a-zA-Z0-9\.\-]*"

csrf=$(curl -A "${agent}" $url 2>/dev/null | grep -e 'csrf' | grep -oP ${regex_csrf})
curl -A "${agent}" --cookie "csrftoken=${csrf}" --referer ${url} -X POST ${url} -H "content-type:application/x-www-form-urlencoded" --data "csrfmiddlewaretoken=${csrf}&targetip=${TARGET}" 2>/dev/null | grep -oP $regex_subdomain | grep -oP $regex_subdomain2 | tee "${name_domain}_dnsdumpster.txt"


