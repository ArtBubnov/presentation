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



echo -e "\n\n\n--- Step 2.1. Get correct git data ---\n"
echo $(git config --global user.email $GIT_CONFIG_USER_EMAIL)
echo $(git config --global user.name $GIT_CONFIG_USER_NAME)
echo $(git config --global user.password $GIT_CONFIG_USER_PASSWORD)
echo $(git config pull.rebase false)
echo $(git config advice.detachedHead false)

git checkout "origin/"$SOURCE_BRANCH_NAME
#git checkout $SOURCE_BRANCH_NAME
git pull origin $TARGET_BRANCH_NAME --no-commit && git commit -m "Merge" || true

echo -e "\n--- Step 2.1 execution is finished ---"