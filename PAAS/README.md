# README before deployment

Before deploying the whole application, please follow the next steps.
* ZIP the file ./modules/lambda/code/get/index.js to ./modules/lambda/code/get/get.zip
* ZIP the file ./modules/lambda/code/post/index.js to ./modules/lambda/code/post/post.zip
* ZIP the file ./modules/lambda/code/delete/index.js to ./modules/lambda/code/delete/delete.zip
* In the following module ./modules/s3/code:
    * npm i
    * npm run build
* In the paas/modules/lambda/code/layers
    Create a folder with the name of the layer and add the node_modules folder of the layer exemple :
        for us we created a folder named "nodejs" and added the node_modules folder of the layer for dynamodb with the command: 
        npm i @aws-sdk/lib-dynamodb 
        npm i @aws-sdk/client-dynamodb
    after zip the folder with the name of the layer and upload it to the lambda layer:
        tar -a -c -f sharedLayer.zip nodejs
    for activate the backup dynamodb you must add this script to the main.tf file in the module dynamodb:
    ```terraform
    point_in_time_recovery {
    enabled = true
    }   