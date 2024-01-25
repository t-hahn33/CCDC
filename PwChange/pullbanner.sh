#bin/bash

# Download the Script from GitHub
wget https://raw.githubusercontent.com/t-hahn33/CCDC/main/PwChange/banner.sh

# Move the scripts to /etc/profile.d/
sudo mv banner.sh /etc/profile.d/

# Make the script executable
sudo chmod +x /etc/profile.d/banner.sh

echo "Test this after it is done!"
