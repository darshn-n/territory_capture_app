import 'package:dartz/dartz.dart';
import 'package:territory_capture_app/core/error/failures.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/repositories/abstract_territory_repository.dart';

class GetTerritoryUseCase {
  final AbstractTerritoryRepository repository;

  GetTerritoryUseCase(this.repository);

  Future<Either<Failure, Territory>> call(String id) {
    return repository.getTerritory(id);
  }
}
