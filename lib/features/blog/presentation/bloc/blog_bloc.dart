import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:practice_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:practice_clean_architecture/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:practice_clean_architecture/features/blog/domain/usecases/upload_blog.dart';

import '../../../../cors/usecase/usercase.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchGetAllBlogs>(_onFetchAllBlogs);
  }

  FutureOr<void> _onFetchAllBlogs(
      BlogFetchGetAllBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    try {
      final res = await _getAllBlogs(NoParams());

      res.fold(
        (l) => emit(
          BlogFailure(error: l.message),
        ),
        (r) => emit(
          BlogDisplaySuccess(blogs: r),
        ),
      );
    } catch (e) {
      emit(BlogFailure(error: e.toString()));
    }
  }

  FutureOr<void> _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    try {
      final res = await _uploadBlog(
        UploadBlogParams(
          posterId: event.posterId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics,
        ),
      );

      res.fold(
        (failure) {
          emit(BlogFailure(error: failure.message));
        },
        (success) {
          emit(BlogSuccess());
        },
      );
    } catch (e) {
      emit(BlogFailure(error: e.toString()));
    }
  }
}
