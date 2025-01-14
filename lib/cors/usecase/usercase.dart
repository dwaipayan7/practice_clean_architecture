import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';

abstract interface class UseCase<SuccessType, Params>{

  Future<Either<Failure, SuccessType>> call(Params params);

}