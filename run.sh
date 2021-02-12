#!bin/bash
projectname="math75"
slaclURL=""
date
./gradlew run -Pargs=/home/ubuntu/d4j/${projectname}
date
curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"webhookbot\", \"text\": \"実行が終了しましたよ！！！！\", \"icon_emoji\": \":ghost:\"}" ${slaclURL}