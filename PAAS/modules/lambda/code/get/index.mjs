// Dépendances: @aws-sdk/client-dynamodb, @aws-sdk/lib-dynamodb
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, ScanCommand, GetCommand } from "@aws-sdk/lib-dynamodb";

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
      if (event.pathParameters && event.pathParameters.id) {
         // Récupérer un élément spécifique
         const result = await dynamo.send(
            new GetCommand({
               TableName: tableName,
               Key: {
                  id: event.pathParameters.id,
               },
            })
         );
         body = result.Item;
      } else {
         // Récupérer tous les éléments
         const result = await dynamo.send(new ScanCommand({ TableName: tableName }));
         body = result.Items;
      }
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