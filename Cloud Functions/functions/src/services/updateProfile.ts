import { adminAuth } from '../config';

export default async function(userId: string, email: string, password: string, displayName: string): Promise<string> {
    try{
        await adminAuth.updateUser(
        userId,
        {
            email: email,
            password: (password.length === 0) ? undefined : password,
            displayName: displayName
        }
    );

        return "success";
    } catch (error) {
        console.error(error);
        return "error";
    }
}
