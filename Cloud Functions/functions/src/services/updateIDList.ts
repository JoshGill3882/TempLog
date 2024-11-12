import { FieldValue } from "firebase-admin/firestore";
import { adminFirestore } from "../config";

export default async function(managerID: string, admin: boolean) {
    try {
        await adminFirestore.collection("Templog").doc("Managers").update(
            { "Manager IDs": (admin) ? FieldValue.arrayUnion(managerID) : FieldValue.arrayRemove(managerID)}
        );

        return "success";
    } catch (error) {
        console.error(error);
        return "error";
    }
}
