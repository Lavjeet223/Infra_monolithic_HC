#! /usr/bin/env bash

# Fail on Errors
set -euo pipefail  # Exit on error, undefined variable, or error in a pipeline command 
                    # -e → exit if any command fails,
                    # -u → exit if you use an undefined variable
                    # -o pipefail → exit if any command in a pipeline fails


# Install Python 
echo "[INFO] Installing Python" # Installing Python and pip package manager
sudo apt update
sudo apt install python3-pip -y # Install pip for Python 3


# Install UnixODBC & Microsoft SQL ODBC Driver
echo "[INFO] Installing UnixODBC" # Install UnixODBC and Microsoft ODBC Driver for SQL Server
sudo apt-get update && sudo apt-get install -y unixodbc unixodbc-dev # Install UnixODBC packages, needed for connecting Python to SQL Server.
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - # Add Microsoft repository key
curl https://packages.microsoft.com/config/debian/10/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null # Add Microsoft SQL Server Linux repository
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17 # Install Microsoft SQL ODBC Driver 17 (needed to connect to Azure SQL from Python)


# Install pm2 process manager for Node.js
echo "[INFO] Installing pm2" # Install pm2 process manager for Node.js
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - # Add NodeSource repository for Node.js 10.x
sudo apt-get install -y nodejs # Install Node.js
sudo npm install pm2 -g # Install pm2 globally


# Setup Backend Application & Start It with PM2
echo "[INFO] Setting up Backend Application for First Time" # Clone the backend application repository, set up environment variables, install dependencies, and start the app using pm2


# Description for below user block line by line
# 1. Switch to devopsadmin user to ensure the application runs under the correct user context.
# 2. Change to the home directory of devopsadmin.
# 3. Clone the backend application repository from GitHub.
# 4. Change to the cloned repository directory.
# 5. Create a .env file containing the database connection string required for the application to connect to the Azure SQL database.
# 6. Install the required Python packages listed in requirements.txt.   

sudo -u devopsadmin bash -c ' 
cd /home/devopsadmin/
git clone https://github.com/devopsinsiders/todoapp-backend-py.git
cd /home/devopsadmin/todoapp-backend-py
echo CONNECTION_STRING="Driver={ODBC Driver 17 for SQL Server};Server=tcp:devopsinssrv1.database.windows.net,1433;Database=todoappdb;Uid=devopsadmin;Pwd=P@ssw01rd@123;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;" > .env
pip install -r requirements.txt
pm2 start app.py
'
