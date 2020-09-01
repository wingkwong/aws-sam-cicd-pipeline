
## Initialize The Hello World SAM project

- Run ``sam init``
- Type 1 to select AWS Quick Start Templates
- Choose ``go1.x`` for runtime
- Leave default ``sam-app`` for project name
- Type 1 to select the Hello World Example
- Verify if ``sam-app`` have been created

When deploying this project, it will create an API Gateway, a Lambda function and a IAM Role. They are defined in ``template.yaml``.

```yaml
HelloWorldAPI:
    Description: "API Gateway endpoint URL for Prod environment for First Function"
    Value: !Sub "https://${ServerlessRestApi}.execute-api.${AWS::Region}.amazonaws.com/Prod/hello/"
HelloWorldFunction:
    Description: "First Lambda Function ARN"
    Value: !GetAtt HelloWorldFunction.Arn
HelloWorldFunctionIamRole:
    Description: "Implicit IAM Role created for Hello World function"
    Value: !GetAtt HelloWorldFunctionRole.Arn
```

The Lambda function simply prints out ``Hello World``. 

```go
func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
    return events.APIGatewayProxyResponse{
        Body:       "Hello World!",
        StatusCode: 200,
    }, nil
}
```

## Run SAM Application Locally

SAM allows your to run your serverless application locally for your development and testing by running the following command. The default local port number is ``3000``. If you are running your app on Cloud9 workspace, you need to override it with ``--port`` as Cloud 9 only support 8080, 8081 or 8082 in the local browser.

```
sam local start-api --port 8080
```

You should see

```
Mounting HelloWorldFunction at http://127.0.0.1:8080/hello [GET]
You can now browse to the above endpoints to invoke your functions. You do not need to restart/reload SAM CLI while working on your functions, changes will be reflected instantly/automatically. You only need to restart SAM CLI if you update your AWS SAM template
* Running on http://127.0.0.1:8080/ (Press CTRL+C to quit)
```

Let's verify it

```
curl http://127.0.0.1:8080/hello 
```

You should see

```
Hello World
```

## Deploy to AWS

Run ``sam build`` to build the project.

```
sam build
```

A hidden directory has been created by SAM 

![image](https://user-images.githubusercontent.com/35857179/91292239-d0285100-e7c8-11ea-9618-526ae0a2cb3b.png)


Run ``sam deploy`` to deploy your application. SAM will createa a CloudFormation stack and you can have a guided interactive mode by specifying ``--guided`` parameter. 

```
sam deploy --guided
```

Configuring SAM deploy

```
Looking for samconfig.toml :  Not found

Setting default arguments for 'sam deploy'
=========================================
Stack Name [sam-app]: 
AWS Region [us-east-1]: ap-southeast-1
#Shows you resources changes to be deployed and require a 'Y' to initiate deploy
Confirm changes before deploy [y/N]: y
#SAM needs permission to be able to create roles to connect to the resources in your template
Allow SAM CLI IAM role creation [Y/n]: Y
HelloWorldFunction may not have authorization defined, Is this okay? [y/N]: Y
Save arguments to samconfig.toml [Y/n]: Y

Looking for resources needed for deployment: Not found.
Creating the required resources...

Successfully created!

Managed S3 bucket: aws-sam-cli-managed-default-samclisourcebucket-542w25h26du5
A different default S3 bucket can be set in samconfig.toml

Saved arguments to config file
Running 'sam deploy' for future deployments will use the parameters saved above.
The above parameters can be changed by modifying samconfig.toml
Learn more about samconfig.toml syntax at 
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-config.html

Uploading to sam-app/9a42d6084bb2aaa2f7eaf7b2201e115a  5094701 / 5094701.0  (100.00%)
```

Deploying with following values

```
Stack name                 : sam-app
Region                     : ap-southeast-1
Confirm changeset          : True
Deployment s3 bucket       : aws-sam-cli-managed-default-samclisourcebucket-542w25h26du5
Capabilities               : ["CAPABILITY_IAM"]
Parameter overrides        : {}
```

Initiating deployment

```
HelloWorldFunction may not have authorization defined.
Uploading to sam-app/21a49766581b625811536c904121d4ba.template  1154 / 1154.0  (100.00%)

Waiting for changeset to be created..

CloudFormation stack changeset
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Operation                                                 LogicalResourceId                                         ResourceType                                            
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+ Add                                                     HelloWorldFunctionCatchAllPermissionProd                  AWS::Lambda::Permission                                 
+ Add                                                     HelloWorldFunctionRole                                    AWS::IAM::Role                                          
+ Add                                                     HelloWorldFunction                                        AWS::Lambda::Function                                   
+ Add                                                     ServerlessRestApiDeployment47fc2d5f9d                     AWS::ApiGateway::Deployment                             
+ Add                                                     ServerlessRestApiProdStage                                AWS::ApiGateway::Stage                                  
+ Add                                                     ServerlessRestApi                                         AWS::ApiGateway::RestApi                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Changeset created successfully. arn:aws:cloudformation:ap-southeast-1:XXXXXXXXXXX:changeSet/samcli-deploy1598436540/ea868c52-9c9a-4d27-a008-ef6157f65b9b
```

Previewing CloudFormation changeset before deployment

```
Deploy this changeset? [y/N]: y

2020-08-26 18:09:42 - Waiting for stack create/update to complete

CloudFormation events from changeset
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ResourceStatus                              ResourceType                                LogicalResourceId                           ResourceStatusReason                      
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE_IN_PROGRESS                          AWS::IAM::Role                              HelloWorldFunctionRole                      -                                         
CREATE_IN_PROGRESS                          AWS::IAM::Role                              HelloWorldFunctionRole                      Resource creation Initiated               
CREATE_COMPLETE                             AWS::IAM::Role                              HelloWorldFunctionRole                      -                                         
CREATE_IN_PROGRESS                          AWS::Lambda::Function                       HelloWorldFunction                          -                                         
CREATE_IN_PROGRESS                          AWS::Lambda::Function                       HelloWorldFunction                          Resource creation Initiated               
CREATE_COMPLETE                             AWS::Lambda::Function                       HelloWorldFunction                          -                                         
CREATE_IN_PROGRESS                          AWS::ApiGateway::RestApi                    ServerlessRestApi                           -                                         
CREATE_IN_PROGRESS                          AWS::ApiGateway::RestApi                    ServerlessRestApi                           Resource creation Initiated               
CREATE_COMPLETE                             AWS::ApiGateway::RestApi                    ServerlessRestApi                           -                                         
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     HelloWorldFunctionCatchAllPermissionProd    Resource creation Initiated               
CREATE_IN_PROGRESS                          AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment47fc2d5f9d       -                                         
CREATE_IN_PROGRESS                          AWS::Lambda::Permission                     HelloWorldFunctionCatchAllPermissionProd    -                                         
CREATE_IN_PROGRESS                          AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment47fc2d5f9d       Resource creation Initiated               
CREATE_COMPLETE                             AWS::ApiGateway::Deployment                 ServerlessRestApiDeployment47fc2d5f9d       -                                         
CREATE_IN_PROGRESS                          AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  -                                         
CREATE_IN_PROGRESS                          AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  Resource creation Initiated               
CREATE_COMPLETE                             AWS::ApiGateway::Stage                      ServerlessRestApiProdStage                  -                                         
CREATE_COMPLETE                             AWS::Lambda::Permission                     HelloWorldFunctionCatchAllPermissionProd    -                                         
CREATE_COMPLETE                             AWS::CloudFormation::Stack                  sam-app                                     -                                         
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CloudFormation outputs from deployed stack
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Outputs                                                                                                                                                                     
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Key                 HelloWorldFunctionIamRole                                                                                                                               
Description         Implicit IAM Role created for Hello World function                                                                                                      
Value               arn:aws:iam::XXXXXXXXXXX:role/sam-app-HelloWorldFunctionRole-CXSDBGUHPMFS                                                                              

Key                 HelloWorldAPI                                                                                                                                           
Description         API Gateway endpoint URL for Prod environment for First Function                                                                                        
Value               https://yh1q5tcsqg.execute-api.ap-southeast-1.amazonaws.com/Prod/hello/                                                                                 

Key                 HelloWorldFunction                                                                                                                                      
Description         First Lambda Function ARN                                                                                                                               
Value               arn:aws:lambda:ap-southeast-1:XXXXXXXXXXX:function:sam-app-HelloWorldFunction-13LO5HE0Y7BKS                                                            
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Successfully created/updated stack - sam-app in ap-southeast-1
```

![image](https://user-images.githubusercontent.com/35857179/91291849-3c568500-e7c8-11ea-911c-a89772e7e86a.png)


To verifiy it, click the HelloWorldApi Value in sam-app Output.

![image](https://user-images.githubusercontent.com/35857179/91868928-dd04e300-eca7-11ea-81e8-277d345ad5a4.png)

