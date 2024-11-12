import { stripe } from "../../../config";

export default async function(paymentMethodId: string) {
    try {
        // Detach the given payment method to the given customer
        await stripe.paymentMethods.detach(
            paymentMethodId,
        );

        return "success";
    } catch (error) {
        // On an error, catch it, log it, and return a static "error" string
        console.error(error);
        return "error";
    }
}
