enum ComplaintStatus { pending, processing, resolved, cancelled }

enum SubscriptionPlan { hourly, daily, monthly }

enum DocumentState {
  posted,
  valid,
  invalid,
}

enum BookingStatus { all, accepted, completed, cancelled, active }

enum AnnouncementType { announcement, offer }

enum AnnouncementReceiverType { user, guard }

enum GuardApprovalStatus { pending, approved, rejected, objection }
