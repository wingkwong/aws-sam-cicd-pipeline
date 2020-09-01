# Create CodeCommit Repository
aws codecommit create-repository --repository-name sam-app

# Configure Git Credentials
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git config --global user.name "<YOUR_USER_NAME>"
git config --global user.email "<YOUR_USER_EMAIL_ADDRESS>"

# Commit local changes
cd ./sam-app
git init
git add .
git commit -m "Initial commit"

# Setup remote and push the code
git remote add origin <REPLACE_WITH_HTTP_CLONE_URL>
git push -u origin master