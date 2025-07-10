import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

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
      const requestJSON = JSON.parse(event.body);

      await dynamo.send(
         new PutCommand({
            TableName: tableName,
            Item: {
               id: requestJSON.id
            },
         })
      );

      body = `Put item ${requestJSON.id}`;
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