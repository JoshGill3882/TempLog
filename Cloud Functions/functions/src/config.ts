import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";
import Stripe from "stripe";

const firebaseConfig = {
    apiKey: 'FIREBASE API KEY',
    authDomain: "FIREBASE AUTH DOMAIN",
    appId: 'FIREBASE APP ID',
    messagingSenderId: 'FIREBASE MESSAGING SENDER ID',
    projectId: 'FIREBASE PROJECT ID',
    storageBucket: 'FIREBASE STORAGE BUCKET',
};

// Initialize Firebase - Admin
const adminApp = initializeApp(firebaseConfig);
export const adminAuth = getAuth(adminApp);
export const adminFirestore = getFirestore(adminApp);

export const stripe = new Stripe(process.env.STRIPE_API_KEY!);
