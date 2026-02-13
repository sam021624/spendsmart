import { logger, setGlobalOptions } from "firebase-functions";
import { onRequest } from "firebase-functions/https";

setGlobalOptions({ maxInstances: 10 });

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});
