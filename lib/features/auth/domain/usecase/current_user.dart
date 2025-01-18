import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/cors/usecase/usercase.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';

import '../../../../cors/common/entities/user.dart';

class CurrentUser implements UseCase<User, NoParams> {

  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async{

    return await authRepository.currentUser();
  }

}