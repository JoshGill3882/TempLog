import { onCall } from "firebase-functions/v2/https";
import { stripe } from "../../../config";
import detachPaymentMethod from "../../../services/stripe/paymentMethods/detachPaymentMethod";
import createPaymentMethod from "../../../services/stripe/paymentMethods/createPaymentMethod";

export default onCall(async (request) => {
    try {
        const data = request.data;

        // Get the given customer's payment methods
        const customerCurrentMethods = await stripe.customers.listPaymentMethods(data.customerId)

        // If the customer already has 1 or more existing payment methods, detach them
        if (customerCurrentMethods.data.length > 0) {
            customerCurrentMethods.data.forEach(async (paymentMethod) => await detachPaymentMethod(paymentMethod.id))
        }

        return await createPaymentMethod(data.customerId, data.cardNumber, data.expMonth, data.expYear, data.cvc)
    } catch (error) {
        // On an error, catch it, log it, and return a static "error" message
        console.error(error);
        return "error";
    }
})