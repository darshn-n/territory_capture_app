import 'package:territory_capture_app/domain/entities/territory.dart';
import 'package:territory_capture_app/domain/repositories/abstract_territory_repository.dart';

class GetUserTerritoriesUseCase {
  final AbstractTerritoryRepository repository;

  GetUserTerritoriesUseCase(this.repository);

  Stream<List<Territory>> call(String userId) {
    return repository.getUserTerritories(userId);
  }
}
