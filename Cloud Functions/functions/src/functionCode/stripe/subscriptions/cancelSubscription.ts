import { onCall } from "firebase-functions/v2/https";
import cancelSubscription from "../../../services/stripe/subscriptions/cancelSubscription";

export default onCall(async (request) => {
    try {
        // Get the data from the "request" object
        const data = request.data;

        return await cancelSubscription(data.subscriptionId);
    } catch (error) {
        console.error(error);
        return "error";
    }
})