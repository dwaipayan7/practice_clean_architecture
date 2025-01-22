import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_clean_architecture/cors/common/widgets/loader.dart';
import 'package:practice_clean_architecture/cors/theme/app_pallete.dart';
import 'package:practice_clean_architecture/cors/utils/show_snackbar.dart';
import 'package:practice_clean_architecture/features/blog/presentation/pages/add_new_blog.dart';

import '../bloc/blog_bloc.dart';
import '../widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<BlogBloc>().add(BlogFetchGetAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlog.route());
            },
            icon: Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }

          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallete.gradient1
                      : index % 3 == 1
                          ? AppPallete.gradient2
                          : AppPallete.gradient3,
                );
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
