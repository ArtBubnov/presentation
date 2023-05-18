
echo -e "--- Predeploy actions script executions start ---\n\n\n"




echo -e "--- Step 1. Define global variables for the current pipeline ---\n"

SOURCE_BRANCH_NAME=$GITHUB_HEAD_REF
TARGET_BRANCH_NAME=$GITHUB_BASE_REF
echo -e "Global variables display:\n"
echo "Event type is:"
echo -e "Pull request\n"
echo "Source branch name is:"
echo $SOURCE_BRANCH_NAME
echo -e "\nTarget branch name is:"
echo $TARGET_BRANCH_NAME

echo -e "\n--- Step 1 execution is finished ---"




echo -e "\n\n\n--- Step 2. Define case for the current pipeline ---\n"
echo "Depends on the result of case definition the following will be determined:"
echo "A - Target Salesforce org for metadata"
echo -e "B - Salesforce org alias\n"
case $TARGET_BRANCH_NAME in
    "dev")
        CASE_LOG="dev"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_dev_sandbox.org"
        ;;
    "qa")
        CASE_LOG="qa"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_qa_sandbox.org"
        ;;
    "staging")
        CASE_LOG="staging"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_staging.org"
        ;;
    "uat")
        CASE_LOG="uat"
        SALESFORCE_TARGET_ORG_ALIAS_UAT="salesforce_uat.org"
        ;;
    "prod")
        CASE_LOG="prod"
        SALESFORCE_TARGET_ORG_ALIAS="salesforce_prod.org"
        ;;
    *)
        echo "Not valid"
        ;;
esac

echo "Step 2 execution result:"
echo "Target Salesforce org for metadata is:"
echo $CASE_LOG
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_TARGET_ORG_ALIAS
echo -e "\n--- Step 2 execution is finished ---"



echo -e "\n\n\n--- Step 2.1. Get correct git data ---"
echo $(git config --global user.email $GIT_CONFIG_USER_EMAIL)
echo $(git config --global user.name $GIT_CONFIG_USER_NAME)
echo $(git config --global user.password $GIT_CONFIG_USER_PASSWORD)
echo $(git config pull.rebase false)
echo $(git config advice.detachedHead false)

git checkout "origin/"$SOURCE_BRANCH_NAME
git pull origin $TARGET_BRANCH_NAME --no-commit && git commit -m "Merge" || true

echo "--- Step 2.1 execution is finished ---"




echo -e "\n\n\n--- Step 3. Logic execution to define the list of files to be deployed to the Salesforce org ---"
case $TARGET_BRANCH_NAME in
    "dev")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "qa")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "staging")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "uat")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "uat_phase1")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/phase1)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/phase1 | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "prod")
        echo -e "Find the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    *)
        echo "Not valid"
        ;;
esac

echo -e "\nStep 3 execution is finished"
echo "Step 3 execution result:"
echo "Files to deploy"
echo $FILES_TO_DEPLOY