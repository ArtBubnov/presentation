echo -e "--- Salesforce org login script executions start ---\n\n\n"

echo -e "--- Step 1. Define global variables for the current pipeline ---\n"
TARGET_BRANCH_NAME=$GITHUB_BASE_REF
echo "Step 1 execution result:"
echo "Target branch is:"
echo $TARGET_BRANCH_NAME
echo -e "\n--- Step 1 execution is finished ---"



echo -e "\n\n\n--- Step 2. Define case for the current pipeline ---\n"
echo "Depends on the result of case definition the following will be determined:"
echo "A - Salesforce access key"
echo "B - Salesforce org alias"

case $TARGET_BRANCH_NAME in
    "dev")
        CASE_LOG="dev"
        #ACCESS_KEY_SF=$ACCESS_KEY_SF_DELTAQA_SANDBOX
        SALESFORCE_ORG_ALIAS="salesforce_dev_sandbox.org"
        ;;
    "qa")
        CASE_LOG="qa"
        #ACCESS_KEY_SF=$ACCESS_KEY_SF_DELTAQA_SANDBOX
        SALESFORCE_ORG_ALIAS="salesforce_qa_sandbox.org"
        ;;
    "staging")
        CASE_LOG="staging"
        #ACCESS_KEY_SF=$ACCESS_KEY_SF_STAGING
        SALESFORCE_ORG_ALIAS="salesforce_staging.org"
        ;;
    "uat")
        CASE_LOG="uat"
        #ACCESS_KEY_SF=$ACCESS_KEY_SF_UAT
        SALESFORCE_ORG_ALIAS="salesforce_uat.org"        
        ;;
    "prod")
        CASE_LOG="prod"
        #ACCESS_KEY_SF=$ACCESS_KEY_SF_PROD
        SALESFORCE_ORG_ALIAS="salesforce_prod.org"
        ;;
    *)
        echo "Not valid"
        ;;
esac

echo "Step 2 execution result:"
echo "Case result:"
echo $CASE_LOG
echo "Salesforce org to be used:"
echo $CASE_LOG
echo "Salesforce alias to be used: "
echo $SALESFORCE_ORG_ALIAS
echo -e "\n--- Step 2 execution is finished ----"



echo -e "\n\n\n--- Step 3. Login to the target Salesforce org ---\n"
echo -e "Creating .key file"
echo "--- PLACEHOLDER ---. .key file has been created"
#touch access_pass.key

echo -e "\nAdding access data to .key file"
echo "--- PLACEHOLDER ---. access data added to .key file"
#echo $ACCESS_KEY_SF > access_pass.key

echo -e "\nTry SF login"
echo "--- PLACEHOLDER ---. SF login successful"
#sfdx force:auth:sfdxurl:store -f "access_pass.key" -a ${SALESFORCE_ORG_ALIAS} -d
#rm access_pass.key
echo -e "\n--- Step 3 execution is finished ---"



echo -e "\n\n\n--- Salesforce org login script executions end ---"