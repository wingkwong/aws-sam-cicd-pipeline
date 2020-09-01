## Building the pipeline

With a continous delivery pipeline using AWS Code Pipeline, we can automate the build, package, and deploy commands. Other services will be used such as CodeCommit, CloudFormation and the AWS CDK.

The general flow would be like

```
Developer -- pushes changes --> Git Repository -- build --> deploy --> AWS
```


## Setting up CodeCommit 

Let's create a CodeCommit repository 

```
aws codecommit create-repository --repository-name sam-app
```

You should see the following output

```json
{
    "repositoryMetadata": {
        "accountId": "XXXXXXXXXXXX",
        "repositoryId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
        "repositoryName": "sam-app",
        "lastModifiedDate": "2020-08-26T18:26:36.257000+08:00",
        "creationDate": "2020-08-26T18:26:36.257000+08:00",
        "cloneUrlHttp": "https://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/sam-app",
        "cloneUrlSsh": "ssh://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/sam-app",
        "Arn": "arn:aws:codecommit:ap-southeast-1:XXXXXXXXXXXX:sam-app"
    }
}
```

To configurate git credentials

```
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git config --global user.name "wingkwong"
git config --global user.email "wingkwong.code@gmail.com"
```

Go to the root directory of your SAM project and run 

```
cd ./sam-app
git init
git add .
git commit -m "Initial commit"
```

Setup Git origin 

```
git remote add origin <REPLACE_WITH_HTTP_CLONE_URL>
```

Push the code to origin

```
git push -u origin master
```

You should see 

```
Counting objects: 17, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (13/13), done.
Writing objects: 100% (17/17), 4.86 MiB | 1.55 MiB/s, done.
Total 17 (delta 0), reused 0 (delta 0)
To https://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/sam-app
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

## Setting up CodePipline

We will use Amazon CDK to provision the pipeline. 

### Install CDK

```
npm install -g aws-cdk
```

### Initialize the project

```
cdk init --language typescript
```

### To bulid and deploy

```
npm run build
cdk deploy
```

You should see ``PipelineStack`` has been created

Go to AWS Console ->  Developer Tools -> CodePipeline -> Pipelines

![image](https://user-images.githubusercontent.com/35857179/91635192-ffd59400-ea28-11ea-96ae-406de4650a89.png)


## Clean up

```
cdk destroy PipelineStack 
```

```
Are you sure you want to delete: PipelineStack (y/n)? y
PipelineStack: destroying...
11:21:26 PM | DELETE_IN_PROGRESS   | AWS::CloudFormation::Stack  | PipelineStack
11:22:34 PM | DELETE_IN_PROGRESS   | AWS::IAM::Role              | Pipeline/Dev/Creat...PipelineActionRole
11:22:34 PM | DELETE_IN_PROGRESS   | AWS::IAM::Role              | Pipeline/Build/Bui...PipelineActionRole
11:22:34 PM | DELETE_IN_PROGRESS   | AWS::IAM::Role              | Build/Role

 ✅  PipelineStack: destroyed
 ```