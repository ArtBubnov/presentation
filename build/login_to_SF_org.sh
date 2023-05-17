echo -e "--- Salesforce org login script executions start ---\n\n\n"

echo -e "\nStep 1. Define global variables for the current pipeline"
TARGET_BRANCH_NAME=$GITHUB_REF_NAME
echo "Step 1 execution is finished"
echo "Step 1 execution result:"
echo "Target branch is:"
echo $TARGET_BRANCH_NAME





echo "login test"

#echo "TEST"
#echo $GITHUB_REF_NAME



echo -e "\n\n\n--- Salesforce org login script executions end ---"