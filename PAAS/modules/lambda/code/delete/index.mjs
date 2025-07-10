const DYNAMODB_TABLE_NAME = process.env.DYNAMODB_TABLE_NAME; // Add this to your environment variables

// exports.handler = async (event) => {
//    console.log("IN LAMBDA DELETE!!")

//    return {
//       "isBase64Encoded": true,
//       "statusCode": 200,
//       "headers": {},
//       "multiValueHeaders": {},
//       "body": ""
//    }
// };
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, DeleteCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const dynamo = DynamoDBDocumentClient.from(client);
const tableName = process.env.DYNAMODB_TABLE_NAME;

export const handler = async (event) => {
   let body;
   let statusCode = 200;
   const headers = {
      "Content-Type": "application/json",
   };

   try {
      await dynamo.send(
         new DeleteCommand({
            TableName: tableName,
            Key: {
               id: event.pathParameters.id,
            },
         })
      );

      body = `Deleted item ${event.pathParameters.id}`;
   } catch (err) {
      statusCode = 400;
      body = err.message;
   }

   return {
      statusCode,
      body: JSON.stringify(body),
      headers,
   };
};