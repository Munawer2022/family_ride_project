class BidsModel {
  final int id;
  final int counterOffer;
  final int riderId;
  final String riderName;
  final int vehicleType;
  final String vehicleNumber;
  final String distance;
  final String time;
  final String stars;
  final int totalReviews;
  final String riderProfile;

  BidsModel({
    required this.id,
    required this.counterOffer,
    required this.riderId,
    required this.riderName,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.distance,
    required this.time,
    required this.stars,
    required this.totalReviews,
    required this.riderProfile,
  });
}
