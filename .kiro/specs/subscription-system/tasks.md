# Implementation Plan

- [ ] 1. Set up project dependencies and configuration
  - Add purchases_flutter, flutter_secure_storage, and equatable packages to pubspec.yaml
  - Configure RevenueCat API keys and platform-specific settings
  - Update analysis_options.yaml if needed for new dependencies
  - _Requirements: 7.1, 7.2_

- [ ] 2. Create core data models and enums
  - [ ] 2.1 Implement SubscriptionTier enum and SubscriptionLimits class
    - Define all subscription tiers (free, paid, singleClassroom, fiveClassroom, institution)
    - Create static configuration for usage limits per tier
    - Add helper methods for limit lookups and comparisons
    - _Requirements: 1.3, 4.1, 4.2_

  - [ ] 2.2 Create SubscriptionPlan data model
    - Implement SubscriptionPlan class with all required fields
    - Add JSON serialization methods (fromJson, toJson)
    - Include validation logic for plan data
    - Create factory constructors for different plan types
    - _Requirements: 1.1, 1.2_

  - [ ] 2.3 Implement SubscriptionEntitlement and UsageStats models
    - Create SubscriptionEntitlement class with expiration and usage tracking
    - Implement UsageStats class for tracking daily/weekly/monthly usage
    - Add methods for usage calculation and limit checking
    - Include serialization support for secure storage
    - _Requirements: 4.1, 4.2, 5.2, 8.1_

- [ ] 3. Implement SubscriptionService interface and RevenueCat integration
  - [ ] 3.1 Create abstract SubscriptionService interface
    - Define all required methods (getAvailablePlans, purchasePlan, restorePurchases, etc.)
    - Add stream-based entitlement updates
    - Include error handling types and result classes
    - _Requirements: 7.1, 7.3_

  - [ ] 3.2 Implement RevenueCatSubscriptionService
    - Initialize RevenueCat SDK with proper configuration
    - Implement getAvailablePlans() method to fetch offerings from RevenueCat
    - Add purchasePlan() method with complete purchase flow handling
    - Implement restorePurchases() with proper error handling
    - _Requirements: 2.1, 2.2, 2.3, 3.1, 3.2, 3.3_

  - [ ] 3.3 Add entitlement management and validation
    - Implement getCurrentEntitlement() with RevenueCat integration
    - Add hasEntitlement() method for feature access checks
    - Create syncWithRevenueCat() for manual synchronization
    - Implement entitlement stream for real-time updates
    - _Requirements: 4.1, 4.2, 5.1, 5.3_

- [ ] 4. Implement secure storage and caching
  - [ ] 4.1 Create SecureStorageService for subscription data
    - Implement flutter_secure_storage wrapper for subscription data
    - Add methods for storing/retrieving entitlements securely
    - Include cache invalidation and TTL logic
    - Create backup/restore mechanisms for storage failures
    - _Requirements: 5.2, 5.3_

  - [ ] 4.2 Add usage tracking and persistence
    - Implement usage tracking for all subscription limits
    - Create daily/weekly/monthly usage reset logic
    - Add methods for incrementing and checking usage counters
    - Include usage history storage and retrieval
    - _Requirements: 4.2, 8.1, 8.3_

- [ ] 5. Create BLoC state management for subscriptions
  - [ ] 5.1 Implement SubscriptionBloc events
    - Create LoadSubscription, PurchasePlan, RestorePurchases events
    - Add CheckUsage, UpdateUsage, and SyncEntitlements events
    - Include error handling events for various failure scenarios
    - _Requirements: 7.2_

  - [ ] 5.2 Implement SubscriptionBloc states
    - Create state hierarchy (Initial, Loading, Loaded, Purchasing, Error, etc.)
    - Add UsageLimitReached state with specific limit information
    - Include proper state transitions and data preservation
    - _Requirements: 4.3, 7.2_

  - [ ] 5.3 Implement SubscriptionBloc business logic
    - Handle all events with proper async operations
    - Integrate with SubscriptionService for data operations
    - Add error handling and retry logic for failed operations
    - Implement state persistence across app sessions
    - _Requirements: 2.1, 2.2, 3.1, 3.2, 4.1, 5.1_

- [ ] 6. Create pricing and subscription UI components
  - [ ] 6.1 Implement PricingScreen widget
    - Create responsive layout for subscription plans display
    - Add monthly/annual toggle with 15% discount calculation
    - Integrate with SubscriptionBloc for real-time state updates
    - Include loading states and error handling UI
    - _Requirements: 1.1, 1.2, 1.3_

  - [ ] 6.2 Create PlanCard reusable widget
    - Design individual plan display with features and pricing
    - Add popular plan highlighting and current plan indicators
    - Implement purchase button with loading and disabled states
    - Include responsive design for different screen sizes
    - _Requirements: 1.1, 1.3_

  - [ ] 6.3 Implement UsageDashboard widget
    - Create usage statistics display with progress bars
    - Add current usage vs. limits visualization
    - Include upgrade prompts when approaching limits
    - Implement real-time usage updates
    - _Requirements: 8.1, 8.2, 8.3_

- [ ] 7. Add subscription management and restoration features
  - [ ] 7.1 Implement purchase flow UI and logic
    - Create purchase confirmation dialogs
    - Add purchase progress indicators and success/failure feedback
    - Implement platform-specific purchase flow handling
    - Include purchase receipt validation and error recovery
    - _Requirements: 2.1, 2.2, 2.4_

  - [ ] 7.2 Create restore purchases functionality
    - Implement restore purchases button and flow
    - Add restoration progress indicators and result feedback
    - Include troubleshooting guidance for failed restorations
    - Create restoration success confirmation UI
    - _Requirements: 3.1, 3.2, 3.3_

  - [ ] 7.3 Add subscription management navigation
    - Create navigation to platform billing settings
    - Add subscription status display in user profile
    - Implement subscription cancellation guidance
    - Include billing issue resolution steps
    - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ] 8. Implement usage enforcement and limit checking
  - [ ] 8.1 Create usage validation middleware
    - Implement feature access guards for all subscription limits
    - Add usage increment logic for tracked features
    - Create limit exceeded handling with appropriate UI feedback
    - Include grace period handling for expired subscriptions
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

  - [ ] 8.2 Add proactive usage notifications
    - Implement usage threshold notifications (80%, 90%, 100%)
    - Create upgrade suggestion dialogs when limits are reached
    - Add usage reset notifications for new billing periods
    - Include usage trend analysis and recommendations
    - _Requirements: 8.2, 8.4_

- [ ] 9. Create comprehensive error handling and recovery
  - [ ] 9.1 Implement error handling for purchase flows
    - Add specific error messages for different purchase failure types
    - Create retry mechanisms for transient failures
    - Implement fallback flows for network connectivity issues
    - Include user-friendly error explanations and solutions
    - _Requirements: 2.3, 7.3_

  - [ ] 9.2 Add offline capability and graceful degradation
    - Implement cached subscription data usage when offline
    - Create fallback to Free tier when validation fails
    - Add manual sync options for users
    - Include offline usage tracking with sync on reconnection
    - _Requirements: 5.3, 5.4_

- [ ] 10. Add comprehensive testing suite
  - [ ] 10.1 Create unit tests for core services and models
    - Write tests for SubscriptionService methods with mocked RevenueCat
    - Test all data models serialization and validation logic
    - Add usage tracking and limit validation tests
    - Include error handling and edge case tests
    - _Requirements: 7.4_

  - [ ] 10.2 Implement BLoC and integration tests
    - Create tests for SubscriptionBloc state transitions
    - Add integration tests for purchase and restoration flows
    - Test offline/online state handling
    - Include end-to-end subscription flow tests
    - _Requirements: 7.4_

  - [ ] 10.3 Add widget and UI tests
    - Test PricingScreen rendering with different subscription states
    - Create tests for PlanCard interactions and state changes
    - Add UsageDashboard display accuracy tests
    - Include error state UI handling tests
    - _Requirements: 7.4_

- [ ] 11. Integrate with existing app architecture
  - [ ] 11.1 Add subscription integration to main app
    - Update main.dart to initialize SubscriptionService
    - Add SubscriptionBloc to app-level BlocProvider
    - Integrate subscription checks into existing feature flows
    - Update routing to include pricing screen
    - _Requirements: 7.1, 7.2_

  - [ ] 11.2 Update existing features with usage tracking
    - Add usage tracking to AI agent interactions
    - Implement subscription checks in document processing features
    - Update export functionality with usage limits
    - Integrate classroom management with subscription tiers
    - _Requirements: 4.1, 4.2, 8.1_

- [ ] 12. Add monitoring and analytics integration
  - [ ] 12.1 Implement subscription analytics tracking
    - Add conversion tracking for subscription purchases
    - Create usage pattern analytics for different tiers
    - Implement churn prediction and retention metrics
    - Include A/B testing support for pricing strategies
    - _Requirements: 7.4_

  - [ ] 12.2 Add error monitoring and alerting
    - Implement crash reporting for subscription-related errors
    - Create monitoring for purchase failure rates
    - Add alerting for unusual usage patterns or fraud detection
    - Include performance monitoring for subscription flows
    - _Requirements: 7.3, 7.4_