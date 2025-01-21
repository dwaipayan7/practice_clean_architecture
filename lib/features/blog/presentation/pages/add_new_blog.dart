import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_clean_architecture/cors/common/app_user/cubits/app_user_cubit.dart';
import 'package:practice_clean_architecture/cors/common/widgets/loader.dart';
import 'package:practice_clean_architecture/cors/theme/app_pallete.dart';
import 'package:practice_clean_architecture/cors/utils/pick_image.dart';
import 'package:practice_clean_architecture/cors/utils/show_snackbar.dart';
import 'package:practice_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:practice_clean_architecture/features/blog/presentation/widgets/blog_editor.dart';

import '../bloc/blog_bloc.dart';

class AddNewBlog extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlog());
  const AddNewBlog({super.key});

  @override
  State<AddNewBlog> createState() => _AddNewBlogState();
}

class _AddNewBlogState extends State<AddNewBlog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopics,
        ),
      );
    } else {
      showSnackBar(context, 'Please fill all fields and select an image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: selectImage,
                      child: image != null
                          ? SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : DottedBorder(
                        color: AppPallete.borderColor,
                        dashPattern: [10, 4],
                        radius: Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open, size: 40),
                              SizedBox(height: 15),
                              Text(
                                "Select Your Image",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Entertainment',
                          'Programming',
                        ].map(
                              (topic) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTopics.contains(topic)
                                      ? selectedTopics.remove(topic)
                                      : selectedTopics.add(topic);
                                });
                              },
                              child: Chip(
                                label: Text(topic),
                                backgroundColor: selectedTopics.contains(topic)
                                    ? AppPallete.gradient1
                                    : null,
                                side: selectedTopics.contains(topic)
                                    ? null
                                    : BorderSide(color: AppPallete.borderColor),
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 15),
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog Title",
                    ),
                    SizedBox(height: 15),
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
