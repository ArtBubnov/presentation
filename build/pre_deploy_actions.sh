
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
echo -e "\nTarget Salesforce org for metadata is:"
echo $CASE_LOG
echo -e "\nSalesforce org alias is:"
echo $SALESFORCE_TARGET_ORG_ALIAS
echo -e "\n--- Step 2 execution is finished ---"




echo -e "\n\n\n--- Step 3. Logic execution to define the list of files to be deployed to the Salesforce org ---"
case $TARGET_BRANCH_NAME in
    "dev")
        echo -e "\nFind the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "qa")
        echo -e "\nFind the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "staging")
        echo -e "\nFind the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "uat")
        echo -e "\nFind the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "uat_phase1")
        echo -e "\nFind the difference between organizations"
        DIFF_BRANCH="origin/"$TARGET_BRANCH_NAME

        echo -e "\nDiff logic execution result:"
        GET_DIFF=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/phase1)
        echo $GET_DIFF
        FILES_TO_DEPLOY=$(git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/phase1 | tr '\n' ',' | sed 's/\(.*\),/\1 /')
        ;;
    "prod")
        echo -e "\nFind the difference between organizations"
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
echo -e "\nFiles to deploy"
echo $FILES_TO_DEPLOY
echo -e "\n--- Step 3 execution is finished ---"




echo -e "\n\n\n--- Step 4. Logic execution to define the list of apex tests to be executed during deployment to the Salesforce org ---"
#get to classes directory to define the list of tests to be executed
cd force-app/main/default/classes/tests

#add all the files in the folder into array
mapfile -t classes_files_array < <( ls )

#define which of the files are tests
COUNT=0
ARRAY_LEN=${#classes_files_array[@]}
LIST_OF_FILES_TO_TEST=""
LOOP_LEN=$( expr $ARRAY_LEN - 1)

while [ $COUNT -le $LOOP_LEN ]
do
    if [[ ${classes_files_array[$COUNT]} == *"Test.cls"* ]];
    then

        if [[ ${classes_files_array[$COUNT]} == *"cls-meta.xml"* ]];
        then
            LIST_OF_XML_FILES=$LIST_OF_XML_FILES{classes_files_array[$COUNT]}","
        else
            LEN_OF_FILE_NAME=${#classes_files_array[$COUNT]}
            NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_FILE_NAME - 4 )
            FILE_NAME_TRUNC=$((echo ${classes_files_array[$COUNT]}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )
            LIST_OF_FILES_TO_TEST=$LIST_OF_FILES_TO_TEST$FILE_NAME_TRUNC","
        fi

    fi 
    COUNT=$(( $COUNT +1))
done

LEN_OF_LIST_OF_FILES_TO_TEST=${#LIST_OF_FILES_TO_TEST}
NUMBER_OF_SYMBOLS_TO_TRUNCATE=$( expr $LEN_OF_LIST_OF_FILES_TO_TEST - 1 )
LIST_OF_FILES_TO_TEST_TRUNC=$((echo ${LIST_OF_FILES_TO_TEST}) | cut -c 1-$NUMBER_OF_SYMBOLS_TO_TRUNCATE )


echo -e "\nStep 4 execution result:"
echo -e "\nList of apex tests to be executed:"
echo $LIST_OF_FILES_TO_TEST_TRUNC
echo -e "\n--- Step 4 execution is finished ---"
cd /home/runner/work/presentation/presentation




echo -e "\n\n\n--- Step 5. Test deploy to the Salesforce org ---\n"
echo "Depends on the target branch a spesific SFDX command should be picked"


case $TARGET_BRANCH_NAME in
    "dev")
        echo "--- PLACEHOLDER ---.Deployment to DEV SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "qa")
        echo "--- PLACEHOLDER ---.Deployment to QA SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "staging")
        echo "--- PLACEHOLDER ---.Deployment to STAGING SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "uat")
        echo "--- PLACEHOLDER ---.Deployment to UAT SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    "prod")
        echo "--- PLACEHOLDER ---.Deployment to PROD SF ENV has started"
        #TBD SHOULD BE UNCOMMENTED
        #sfdx force:source:deploy -p "$FILES_TO_DEPLOY" -c -l RunSpecifiedTests -r "$LIST_OF_FILES_TO_TEST_TRUNC" -u ${SALESFORCE_TARGET_ORG_ALIAS} --loglevel WARN
        ;;
    *)
        echo "Not valid"
        ;;
esac
echo -e "\n--- Step 5 execution is finished ---"


echo -e "\n\n\nStep 6. Specify the lisf of metadata"



files_array=("force-app/main/default/classes/batches/Batch_00.cls" "force-app/main/default/classes/batches/test1/Batch_01.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/Batch_02.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/Batch_03.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/Batch_04.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/Batch_05.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/test6/Batch_06.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/test6/test7/Batch_07.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/test6/test7/test8/Batch_08.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/test6/test7/test8/test9/Batch_09.cls-meta.xml" "force-app/main/default/classes/batches/test1/test2/test3/test4/test5/test6/test7/test8/test9/test10/Batch_10.cls-meta.xml")


#mapfile -t files_array < <( git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default )

ARRAY_LEN=${#files_array[@]}
echo $ARRAY_LEN
echo "Array is"
echo ${files_array[*]}
echo "--------------"
echo ${files_array[0]}
echo "--------------"
echo ${files_array[1]}
echo "--------------"
echo ${files_array[2]}
echo "--------------"
echo ${files_array[3]}
echo "--------------"
echo ${files_array[4]}
echo "--------------"
echo ${files_array[5]}
echo "--------------"
echo ${files_array[6]}
echo "--------------"
echo ${files_array[7]}
echo "--------------"
echo ${files_array[8]}
echo "--------------"
echo ${files_array[9]}

TEST="force-app/main/default/classes/batches/Batch_00.cls"
echo $TEST
TEST2=$(echo $TEST)
echo "TEST2"
echo $TEST2



echo "***********************************************************************************************"
echo "***********************************************************************************************"
echo "***********************************************************************************************"
echo "---------------------------  === LIST OF FILES ===  -------------------------------------------"
echo "---------------------------  === START OF THE LIST ===  ---------------------------------------"
echo "                                                                                              |"
echo "                                                                                              |"
echo "                                                                                              |"
echo -e "                                                                                              |\n\n\n"



COUNT=0
ARRAY_LEN=${#files_array[@]}
LOOP_LEN=$( expr $ARRAY_LEN - 1)

while [ $COUNT -le $LOOP_LEN ]
do
    folder=$(echo ${files_array[$COUNT]} | cut -d\/ -f4)
    file=$(echo ${files_array[$COUNT]} | cut -d\/ -f5)
    echo -e "$folder: $file"
    echo -e "\n"
    COUNT=$(( $COUNT +1))
done



echo -e "\n\n\n                                                                                              |"
echo "                                                                                              |"
echo "                                                                                              |"
echo "                                                                                              |"
echo "---------------------------  === END OF THE LIST ===  -----------------------------------------"
echo "***********************************************************************************************"
echo "***********************************************************************************************"
echo "***********************************************************************************************"





#mapfile -t files_array < <( git diff --name-only --diff-filter=ACMR ${DIFF_BRANCH} force-app/main/default )