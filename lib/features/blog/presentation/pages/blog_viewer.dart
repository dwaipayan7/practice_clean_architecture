import 'package:flutter/material.dart';
import 'package:practice_clean_architecture/cors/utils/format_date.dart';
import 'package:practice_clean_architecture/features/blog/domain/entities/blog.dart';

import '../../../../cors/utils/calculate_reading_time.dart';
import 'package:intl/intl.dart';

class BlogViewer extends StatelessWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogViewer(
            blog: blog,
          ));
  const BlogViewer({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "By ${blog.posterName}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  //formatDateBydMMMYYYY
                  '${(formatDateBydMMMYYYY(blog.updatedAt))} • ${calculateReadingTime(blog.content)} min read',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                SizedBox(height: 10,),
                Text(blog.content, style: TextStyle(
                  fontSize: 16,
                  height: 2,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
