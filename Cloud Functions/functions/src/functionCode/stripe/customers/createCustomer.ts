import { onCall } from "firebase-functions/v2/https";
import createCustomer from "../../../services/stripe/customers/createCustomer";

export default onCall(async (request) => {
    try {
        // Get the data from the request object
        const data = request.data;

        return await createCustomer(data.name, data.email);
    } catch (error) {
        // On an error, log the error to the console and return the static string "error"
        console.error(error)
        return "error";
    }
});
