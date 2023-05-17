#Installs the sfdx cli
echo -e "--- SFDX CLI installation script executions start ---\n\n\n"

echo "Installing Salesforce CLI"
sudo npm install -global sfdx-cli

echo -e "\n\n\nSalesforce CLI version check"
sudo npm install sfdx --version

echo -e "\n\n\n--- SFDX CLI installation script executions end ---"