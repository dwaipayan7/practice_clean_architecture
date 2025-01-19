import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:practice_clean_architecture/cors/theme/app_pallete.dart';
import 'package:practice_clean_architecture/features/blog/presentation/widgets/blog_editor.dart';

class AddNewBlog extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlog());
  const AddNewBlog({super.key});

  @override
  State<AddNewBlog> createState() => _AddNewBlogState();
}

class _AddNewBlogState extends State<AddNewBlog> {

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DottedBorder(
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
                      Icon(
                        Icons.folder_open,
                        size: 40,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Select Your Image",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children:
                      ['Technology', 'Business', 'Entertainment', 'Programming']
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: (){
                                 setState(() {
                                   if(selectedTopics.contains(e)){
                                     selectedTopics.remove(e);
                                   }else{
                                     selectedTopics.add(e);
                                   }
                                   print(selectedTopics);
                                 });
                                },
                                child: Chip(
                                  label: Text(e),
                                  color: selectedTopics.contains(e) ? MaterialStatePropertyAll(AppPallete.gradient1): null,
                                  side: selectedTopics.contains(e) ? null : BorderSide(color: AppPallete.borderColor),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 15,),
              BlogEditor(controller: titleController, hintText: "Blog Title"),
              SizedBox(height: 15,),
              BlogEditor(controller: contentController, hintText: "Blog Content"),
            ],
          ),
        ),
      ),
    );
  }
}
