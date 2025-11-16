sealed class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);
}

class LocationFailure extends Failure {
  final String message;
  const LocationFailure(this.message);
}

class PermissionFailure extends Failure {}
