
echo -e "--- Predeploy actions script executions start ---\n\n\n"




echo "--- Step 1. Define global variables for the current pipeline ---"
SOURCE_BRANCH_NAME=$GITHUB_EVENT_PULL_REQUEST_HEAD_REF
TARGET_BRANCH_NAME=$GITHUB_EVENT_PULL_REQUEST_BASE_REF
echo "Global variables display:"
echo "Event type is:"
echo "Pull request"
echo "Source branch name is:"
echo $SOURCE_BRANCH_NAME
echo "Target branch name is:"
echo $TARGET_BRANCH_NAME
echo "--- Step 1 execution is finished ---"
         # echo "Pull request source branch is:"
         # echo ${{ github.event.pull_request.head.ref }}
         # echo "Pull request target branch is:"
         # echo ${{ github.event.pull_request.base.ref }}