import 'package:dartz/dartz.dart';
import 'package:territory_capture_app/core/error/exceptions.dart';
import 'package:territory_capture_app/core/error/failures.dart';
import 'package:territory_capture_app/data/datasources/territory_remote_datasource.dart';
import 'package:territory_capture_app/data/models/territory_model.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/repositories/abstract_territory_repository.dart';

class TerritoryRepositoryImpl implements AbstractTerritoryRepository {
  final TerritoryRemoteDataSource remoteDataSource;

  TerritoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> saveTerritory(Territory territory) async {
    try {
      final model = _toModel(territory);
      final id = await remoteDataSource.saveTerritory(model);
      return Right(id);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<List<Territory>> getUserTerritories(String userId) {
    return remoteDataSource
        .getUserTerritories(userId)
        .map((models) => models.cast<Territory>());
  }

  @override
  Future<Either<Failure, Territory>> getTerritory(String id) async {
    try {
      final model = await remoteDataSource.getTerritory(id);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  TerritoryModel _toModel(Territory territory) {
    return TerritoryModel(
      id: territory.id,
      userId: territory.userId,
      createdAt: territory.createdAt,
      distanceMeters: territory.distanceMeters,
      areaSqMeters: territory.areaSqMeters,
      points: territory.points,
    );
  }
}
