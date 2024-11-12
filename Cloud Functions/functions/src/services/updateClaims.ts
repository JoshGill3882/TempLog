import { adminAuth } from '../config';

export default async function(userId: string, businessCode: string, admin: boolean): Promise<string> {
    try{
        await adminAuth.setCustomUserClaims(
            userId,
            {
                "businessCode": businessCode,
                "admin": admin
            }
        );

        return "success";
    } catch (error) {
        console.error(error);
        return "error";
    }
}
