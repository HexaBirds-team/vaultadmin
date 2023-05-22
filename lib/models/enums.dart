enum ComplaintStatus { pending, processing, resolved, canceled }

enum SubscriptionPlan { hourly, daily, monthly }

enum DocumentState {
  posted,
  valid,
  invalid,
}

enum BookingStatus { all, pending, accepted, completed, cancelled }

enum AnnouncementType { announcement, offer }

enum AnnouncementReceiverType { user, guard }

enum GuardApprovalStatus { pending, approved, rejected }
