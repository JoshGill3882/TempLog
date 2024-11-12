import { stripe } from "../../../config";

export default async function(name: string, email: string): Promise<string> {
    try {
        // Create the customer from the Stripe API
        const customer = await stripe.customers.create({
            name: name,
            email: email
        });

        // Return the new Customer's ID on a success
        return customer.id;
    } catch (error) {
        console.error(error);
        return "error";
    }
}