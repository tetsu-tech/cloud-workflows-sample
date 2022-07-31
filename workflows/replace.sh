# ここを設定する
PROJECT_ID=
REGION=
CLOUD_RUN_URL=

cat ./workflow-template.yaml \
| sed -e "s|{{REGION}}|$REGION|g" \
| sed -e "s|{{PROJECT_ID}}|$PROJECT_ID|g" \
| sed -e "s|{{CLOUD_RUN_URL}}|$CLOUD_RUN_URL|g" > ./workflow.yaml
