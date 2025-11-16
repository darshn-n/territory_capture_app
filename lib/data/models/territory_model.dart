import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:territory_capture_app/domain/entities/lat_lng_timestamp.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';

class TerritoryModel extends Territory {
  TerritoryModel({
    required super.id,
    required super.userId,
    required super.createdAt,
    required super.distanceMeters,
    required super.areaSqMeters,
    required super.points,
  });

  factory TerritoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final pointsList = (data['points'] as List)
        .map((p) => LatLngTimestamp.fromJson(p as Map<String, dynamic>))
        .toList();

    return TerritoryModel(
      id: doc.id,
      userId: data['userId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      distanceMeters: (data['distanceMeters'] as num).toDouble(),
      areaSqMeters: (data['areaSqMeters'] as num).toDouble(),
      points: pointsList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'distanceMeters': distanceMeters,
      'areaSqMeters': areaSqMeters,
      'points': points.map((p) => p.toJson()).toList(),
    };
  }
}
