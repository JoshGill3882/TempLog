import { onCall } from 'firebase-functions/v2/https';
import updateClaims from '../services/updateClaims';
import updateIDList from '../services/updateIDList';

export default onCall(async (request) => {
    try {
        const data = request.data;

        const adminFlag: boolean = (data.admin == "true" ? true : false)

        const updateClaimsResponse: string = await updateClaims(data.userId, data.businessCode, adminFlag);
        if (updateClaimsResponse == "error") { return "error"; }

        const updateEmailListResponse: string = await updateIDList(data.userId, adminFlag);
        if (updateEmailListResponse == "error") { return "error"; }

        return "success";
    } catch (error) {
        console.error(error);
        return "error";
    }
});
