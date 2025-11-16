import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:territory_capture_app/core/error/exceptions.dart';
import 'package:territory_capture_app/data/models/territory_model.dart';

abstract class TerritoryRemoteDataSource {
  Future<String> saveTerritory(TerritoryModel territory);
  Stream<List<TerritoryModel>> getUserTerritories(String userId);
  Future<TerritoryModel> getTerritory(String id); // ← FIXED
}

class TerritoryRemoteDataSourceImpl implements TerritoryRemoteDataSource {
  final FirebaseFirestore firestore;

  TerritoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> saveTerritory(TerritoryModel territory) async {
    try {
      final ref = await firestore
          .collection('territories')
          .add(territory.toFirestore());
      return ref.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<TerritoryModel>> getUserTerritories(String userId) {
    return firestore
        .collection('territories')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TerritoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<TerritoryModel> getTerritory(String id) async {
    try {
      final doc = await firestore.collection('territories').doc(id).get();
      if (!doc.exists) throw ServerException('Territory not found');
      return TerritoryModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
