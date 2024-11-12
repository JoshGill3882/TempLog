import { stripe } from "../../../config";

export default async function(subscriptionId: string): Promise<string> {
    try {
        await stripe.subscriptions.cancel(subscriptionId);

        return "success";
    } catch (error) {
        console.error(error);
        return "error";
    }
}