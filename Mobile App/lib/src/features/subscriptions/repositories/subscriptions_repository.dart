import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/subscriptions/data/subscription_info.dart';

class SubscriptionsRepository {
  final database = DefaultFirebaseOptions.database;
  final functions = DefaultFirebaseOptions.functions;

  // Gets information on the user's current Subscription
  Future<SubscriptionInfo> getSubscriptionInfo(String businessCode) async {
    final businessInfoDoc = await database
      .collection(businessCode)
      .doc("Business Info")
      .get();

    Map<String, dynamic>? data = businessInfoDoc.data();

    // If the user doesn't have any subscription data currently (new business), set them to the free tier
    if (data!["Subscription Info"]["Tier"] == null) {
      await updateSubscriptionInfo(businessCode, "", "", "Free");

      final businessInfoDoc = await database
          .collection(businessCode)
          .doc("Business Info")
          .get();

      data = businessInfoDoc.data();
    }

    return SubscriptionInfo(
        customerId: data!["Subscription Info"]["Customer Id"],
        tier: data["Subscription Info"]["Tier"],
        subscriptionId: data["Subscription Info"]["Subscription Id"]
    );
  }

  // Updates the user's subscription information in the Database
  updateSubscriptionInfo(String businessCode, String customerId, String subscriptionId, String newTier) async {
    await database
      .collection(businessCode)
      .doc("Business Info")
      .set({
        "Subscription Info" : {
          "Customer Id": customerId,
          "Subscription Id": subscriptionId,
          "Tier": newTier
        }
      }, SetOptions(merge: true));
  }

  // Creates a customer and returns their ID
  Future<String> createCustomer(String email, String name) async {
    final createCustomerFunction = functions.httpsCallable("createCustomer");
    final response = await createCustomerFunction.call({
      "email": email,
      "name": name
    });

    return response.data as String;
  }

  // Creates a payment method and returns it's ID
  createPaymentMethod(String customerId, String cardNumber, int expMonth, int expYear, String cvc) async {
    final createPaymentMethodFunction = functions.httpsCallable("createPaymentMethod");
    await createPaymentMethodFunction.call({
      "customerId": customerId,
      "cardNumber": cardNumber,
      "expMonth": expYear,
      "expYear": expYear,
      "cvc": cvc
    });
  }

  // Creates a subscription and returns it's ID
  Future<String> createSubscription(String customerId, String subscriptionType) async {
    final createSubscriptionFunction = functions.httpsCallable("createSubscription");
    final response = await createSubscriptionFunction.call({
      "customerId": customerId,
      "subscriptionType": subscriptionType
    });

    return response.data as String;
  }

  // Cancels a subscription
  cancelSubscription(String subscriptionId) async {
    final cancelSubscriptionFunction = functions.httpsCallable("cancelSubscription");
    final response = await cancelSubscriptionFunction.call({
      "subscriptionId": subscriptionId
    });
    return response.data as String;
  }
}
