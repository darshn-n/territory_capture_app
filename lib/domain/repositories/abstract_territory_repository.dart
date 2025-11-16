import 'package:dartz/dartz.dart';
import 'package:territory_capture_app/core/error/failures.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';

abstract class AbstractTerritoryRepository {
  Future<Either<Failure, String>> saveTerritory(Territory territory);
  Stream<List<Territory>> getUserTerritories(String userId);
  Future<Either<Failure, Territory>> getTerritory(String id);
}
