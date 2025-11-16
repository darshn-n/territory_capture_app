import 'package:dartz/dartz.dart';
import 'package:territory_capture_app/core/error/failures.dart';
import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/repositories/abstract_territory_repository.dart';

class SaveTerritoryUseCase {
  final AbstractTerritoryRepository repository;

  SaveTerritoryUseCase(this.repository);

  Future<Either<Failure, String>> call(Territory territory) {
    return repository.saveTerritory(territory);
  }
}
