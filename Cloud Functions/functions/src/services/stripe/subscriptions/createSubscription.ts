import { stripe } from "../../../config";

export default async function(customerId: string, priceCode: string): Promise<string> {
    try {
        // Create the subscription using the Stripe API
        const subscription = await stripe.subscriptions.create({
            customer: customerId,
            items: [
                { price: priceCode }
            ]
        });

        return subscription.id;
    } catch (error) {
        console.error(error);
        return "error";
    }
}
