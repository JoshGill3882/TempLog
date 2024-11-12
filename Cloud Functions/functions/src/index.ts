import updateClaims from './functionCode/updateClaims';
import updateProfile from './functionCode/updateProfile';

import createCustomer from './functionCode/stripe/customers/createCustomer';
import createPaymentMethod from './functionCode/stripe/paymentMethods/createPaymentMethod';
import createSubscription from './functionCode/stripe/subscriptions/createSubscription';
import cancelSubscription from './functionCode/stripe/subscriptions/cancelSubscription';

// Function exports
// Firebase Auth
exports.updateClaims = updateClaims;
exports.updateProfile = updateProfile;
// Stripe
exports.createCustomer = createCustomer;
exports.createPaymentMethod = createPaymentMethod;
exports.createSubscription = createSubscription;
exports.cancelSubscription = cancelSubscription;
