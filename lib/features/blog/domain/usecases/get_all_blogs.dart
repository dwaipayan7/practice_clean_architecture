
import 'package:fpdart/src/either.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/cors/usecase/usercase.dart';
import 'package:practice_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:practice_clean_architecture/features/blog/domain/repositories/blog_repositories.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams>{
  final BlogRepository blogRepository;

  GetAllBlogs({required this.blogRepository});
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async{

    return await blogRepository.getAllBlogs();

  }
}