
echo -e "--- Predeploy actions script executions start ---\n\n\n"




echo -e "--- Step 1. Define global variables for the current pipeline ---\n"
SOURCE_BRANCH_NAME=$GITHUB_HEAD_REF
TARGET_BRANCH_NAME=$GITHUB_BASE_REF
echo "Global variables display:"
echo "Event type is:"
echo "Pull request"
echo "Source branch name is:"
echo $SOURCE_BRANCH_NAME
echo "Target branch name is:"
echo $TARGET_BRANCH_NAME
echo -e "\n--- Step 1 execution is finished ---"