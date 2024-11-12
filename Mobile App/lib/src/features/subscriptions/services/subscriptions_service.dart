import 'package:firebase_auth/firebase_auth.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/features/subscriptions/data/restrictions.dart';
import 'package:templog/src/features/subscriptions/data/subscription_info.dart';
import 'package:templog/src/features/subscriptions/repositories/subscriptions_repository.dart';

class SubscriptionsService {
  final auth = DefaultFirebaseOptions.auth;

  final subscriptionsRepository = SubscriptionsRepository();

  Future<SubscriptionInfo> getCurrentSubscriptionInfo(String businessCode) async {
    return await subscriptionsRepository.getSubscriptionInfo(businessCode);
  }

  setFreeTier() async {
    // Get the user's business code
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    // Get current subscription info
    SubscriptionInfo currentSubscriptionInfo = await getCurrentSubscriptionInfo(businessCode);

    // If the user is already on the "Free" tier, return
    if (currentSubscriptionInfo.tier == "Free") {
      return;
    // Else-If the user is on the "Pro" tier, cancel their current subscription
    } else if (currentSubscriptionInfo.tier == "Plus") {
      // await subscriptionsRepository.cancelSubscription(currentSubscriptionInfo.subscriptionId);
    // Else-If the user is on the "Enterprise" tier, todo
    } else if (currentSubscriptionInfo.tier == "Enterprise") {
    }

    // Update restrictions
    MainPage.currentRestrictions = Restrictions.freeTierRestrictions();

    // Update the database with new subscription details
    await subscriptionsRepository.updateSubscriptionInfo(businessCode, currentSubscriptionInfo.customerId, "", "Free");
  }

  setPlusTier() async {
    // Get the user's business code
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    // Get the user's current subscription information
    SubscriptionInfo currentSubscriptionInfo = await getCurrentSubscriptionInfo(businessCode);

    // If the user is already on the "Pro" tier, return
    if (currentSubscriptionInfo.tier == "Plus") { return; }

    // // if the customer ID is null, create a new customer
    // if (currentSubscriptionInfo.customerId.isEmpty) {
    //   currentSubscriptionInfo.customerId = await subscriptionsRepository.createCustomer(
    //     auth.currentUser!.email!,
    //     auth.currentUser!.displayName!
    //   );
    // }
    //
    // // Create a new payment method for the current customer
    // await subscriptionsRepository.createPaymentMethod(
    //   currentSubscriptionInfo.customerId,
    //   cardResult.cardNumber,
    //   int.parse(cardResult.expirationMonth),
    //   int.parse(cardResult.expirationYear),
    //   cardResult.cvc
    // );
    //
    // // Create a new Subscription
    // currentSubscriptionInfo.subscriptionId = await subscriptionsRepository.createSubscription(
    //   currentSubscriptionInfo.customerId,
    //   "Monthly"
    // );

    // Update the restrictions
    MainPage.currentRestrictions = Restrictions.plusTierRestrictions();

    // Update the database with the new Subscription information
    await subscriptionsRepository.updateSubscriptionInfo(
      businessCode,
      currentSubscriptionInfo.customerId,
      currentSubscriptionInfo.subscriptionId,
      "Plus"
    );
  }

  setEnterpriseTier() async {}

  setRestrictions(String newTier) {
    switch (newTier) {
      case "Free":
        MainPage.currentRestrictions = Restrictions.freeTierRestrictions();
        break;
      case "Pro":
        MainPage.currentRestrictions = Restrictions.plusTierRestrictions();
        break;
    }
  }
}
