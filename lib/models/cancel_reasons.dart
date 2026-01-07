class CancelReason {
  final String id;
  final String reason;

  CancelReason({required this.id, required this.reason});

  factory CancelReason.fromJson(Map<String, dynamic> json) {
    return CancelReason(
      id: json["id"].toString(),
      reason: json["reason"] ?? "",
    );
  }
}

class GetCancelOrderReasons {
  final List<CancelReason> cancelReasons;

  GetCancelOrderReasons({required this.cancelReasons});

  factory GetCancelOrderReasons.fromJson(Map<String, dynamic> json) {
    return GetCancelOrderReasons(
      cancelReasons: (json["cancelReasons"] as List)
          .map((r) => CancelReason.fromJson(r))
          .toList(),
    );
  }
}
