echo -e "--- SFDX CLI installation script executions start ---\n\n\n"


echo -e "--- Step 1. Installing Salesforce CLI execution ---"
sudo npm install -global sfdx-cli
echo -e "\n--- Step 1 execution is finished ---\n\n\n"


echo -e "--- Step 2. Salesforce CLI version check ---\n"
echo "SFDX version is:"
sudo npm install sfdx --version
echo -e "\n--- Step 2 execution is finished ---"

echo -e "\n\n\n--- SFDX CLI installation script executions end ---"