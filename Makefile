# ここを設定する
SERVICE_ACCOUNT=workflows-sa
SERVICE_NAME=floor
PROJECT_ID=
REGION=asia-northeast1
WORKFLOW_NAME=

config:
	gcloud config set project ${PROJECT_ID}
	gcloud config set run/region ${REGION}
	gcloud config set workflows/location ${REGION}

create-sa:
	# ServiceAccountを作成
	gcloud iam service-accounts create ${SERVICE_ACCOUNT}
	# CloudRunを呼び出せるように呼び出し元権限をつける
	gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role "roles/run.invoker"

# randomgen (Cloud Functions)
deploy-randomgen:
	cd randomgen && \
	gcloud functions deploy randomgen \
		--runtime python37 \
		--trigger-http \
		--region ${REGION} \
		--allow-unauthenticated

run-randomgen:
	curl $(gcloud functions describe randomgen --format='value(httpsTrigger.url)')

# multiply (Cloud Functions)
deploy-multiply:
	cd multiply && \
	gcloud functions deploy multiply \
		--runtime python37 \
		--trigger-http \
		--region ${REGION} \
		--allow-unauthenticated

run-multiply:
	curl $(gcloud functions describe multiply --format='value(httpsTrigger.url)') \
		-X POST \
		-H "content-type: application/json" \
		-d '{"input": 5}'

# floor (CloudRun)
build-floor:
	cd floor && gcloud builds submit --tag gcr.io/${PROJECT_ID}/${SERVICE_NAME}

deploy-floor:
	cd floor && gcloud run deploy ${SERVICE_NAME} \
		--image gcr.io/${PROJECT_ID}/${SERVICE_NAME} \
		--platform managed \
		--no-allow-unauthenticated

# workflow
build-workflow:
	cd workflows && \
	./replace.sh

deploy-workflow:
	cd workflows && \
	gcloud workflows deploy ${WORKFLOW_NAME} \
		--source=workflow.yaml \
		--service-account=${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com

run-workflow:
	cd workflows && \
	gcloud workflows run ${WORKFLOW_NAME}

# 作成したリソースの削除
delete-all:
	gcloud run services delete ${SERVICE_NAME}
	gcloud workflows delete ${WORKFLOW_NAME}
	gcloud iam service-accounts delete ${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com
	gcloud functions delete randomgen
	gcloud functions delete multiply
