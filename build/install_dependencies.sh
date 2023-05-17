echo -e "--- SFDX CLI installation script executions start ---\n\n\n"


echo "--- Step 1. Installing Salesforce CLI execution ---"
sudo npm install -global sfdx-cli
echo -e "--- Step 1 execution is finished ---\n\n\n"


echo -e "--- Step 2. Salesforce CLI version check ---"
echo "SFDX version is:"
sudo npm install sfdx --version
echo -e "--- Step 2 execution is finished ---"

echo -e "\n\n\n--- SFDX CLI installation script executions end ---"