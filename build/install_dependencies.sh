echo -e "--- SFDX CLI installation script executions start ---\n\n\n"


echo -e"\n--- Step 1. Installing Salesforce CLI ---"
sudo npm install -global sfdx-cli
echo -e "--- Step 1 execution is finished ---\n"


echo -e "--- Step 2. Salesforce CLI version check ---\n"
sudo npm install sfdx --version

echo -e "\n\n\n--- SFDX CLI installation script executions end ---"