import { onCall } from 'firebase-functions/v2/https';
import updateProfile from '../services/updateProfile';

export default onCall(async (request) => {
    try {
        const data = request.data;

        if (request.auth!.uid != data.userId) { return "error"; }

        return await updateProfile(data.userId, data.email, data.password, data.displayName);
    } catch (error) {
        console.error(error);
        return "error";
    }
});
