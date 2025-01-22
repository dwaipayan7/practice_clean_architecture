import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:practice_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:practice_clean_architecture/features/blog/domain/repositories/blog_repositories.dart';
import 'package:uuid/uuid.dart';

import '../model/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepositoryImpl({required this.blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl
      );

     final uploadedBlog =  await blogRemoteDataSource.uploadBlog(blogModel);

     return Either.right(uploadedBlog);

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async{
    try{

      final blogs = await blogRemoteDataSource.getAllBlogs();

      return Either.right(blogs);

    }catch(e){
      return Either.left(Failure(e.toString()));
    }
  }


}
