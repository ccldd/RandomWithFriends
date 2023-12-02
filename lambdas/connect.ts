import { APIGatewayProxyWebsocketHandlerV2 } from "aws-lambda"

export const handler: APIGatewayProxyWebsocketHandlerV2 = async (
  event,
  context,
) => {
  console.log("EVENT: \n" + JSON.stringify(event, null, 2))
  return context.logStreamName
}
