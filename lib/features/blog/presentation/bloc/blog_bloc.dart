import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:practice_clean_architecture/features/blog/domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogUpload>(_onBlogUpload);
  }

  FutureOr<void> _onBlogUpload(
      BlogUpload event,
      Emitter<BlogState> emit,
      ) async {
    emit(BlogLoading());
    try {
      final res = await uploadBlog(
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
