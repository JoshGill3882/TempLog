import { onCall } from "firebase-functions/v2/https";
import createSubscription from "../../../services/stripe/subscriptions/createSubscription";

export default onCall(async (request) => {
    try {
        // Get the data from the "request" object
        const data = request.data;
        
        // Get the correct price code based on subscription type given
        const priceCode = (data.subscriptionType == "Monthly")
         ? process.env.STRIPE_MONTHLY_PAYMENT_CODE // Monthly payments code 
         : process.env.STRIPE_ANNUAL_PAYMENT_CODE; // Annual payments code

        return await createSubscription(data.customerId, priceCode!)
    } catch (error) {
        // On an error, log the error to the console and return the static string "error"
        console.error(error);
        return "error"
    }
});
