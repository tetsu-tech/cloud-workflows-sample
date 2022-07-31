# ここを設定する
PROJECT_ID=
REGION=

cat ./workflow-template.yaml | sed -e "s/{{REGION}}/$REGION/g" | sed -e "s/{{PROJECT_ID}}/$PROJECT_ID/g" > ./workflow.yaml
