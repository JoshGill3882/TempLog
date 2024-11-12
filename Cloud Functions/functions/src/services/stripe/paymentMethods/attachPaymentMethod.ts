import { stripe } from "../../../config";

export default async function(paymentMethodId: string, customerId: string) {
    try {
        // Attach the given payment method to the given customer
        await stripe.paymentMethods.attach(
            paymentMethodId,
            { customer: customerId }
        );

        return "success";
    } catch (error) {
        // On an error, catch it, log it, and return a static "error" string
        console.error(error);
        return "error";
    }
}
