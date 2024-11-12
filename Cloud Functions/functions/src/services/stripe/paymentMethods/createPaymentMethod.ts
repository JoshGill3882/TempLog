import { stripe } from "../../../config";
import attachPaymentMethod from "./attachPaymentMethod";

export default async function(customerId: string, cardNumber: string, expMonth: number, expYear: number, cvc: string): Promise<string> {
    try {
        // Create a new payment method
        const newPaymentMethod = await stripe.paymentMethods.create({
            type: "card",
            card: {
                number: cardNumber,
                exp_month: expMonth,
                exp_year: expYear,
                cvc: cvc
            }
        });

        // Attach it to the customer
        await attachPaymentMethod(newPaymentMethod.id, customerId);

        return newPaymentMethod.id;
    } catch (error) {
        console.error(error);
        return "error";
    }
}