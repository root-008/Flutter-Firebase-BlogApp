import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/blog_write_widgets.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pushable_button/pushable_button.dart';

class BlogWriteScreen extends StatefulWidget {
  const BlogWriteScreen({super.key, this.blog});
  final Blog? blog;

  @override
  State<BlogWriteScreen> createState() => _BlogWriteScreenState();
}

class _BlogWriteScreenState extends State<BlogWriteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final UIWidgets widgets = UIWidgets();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Blog? blog;

  final List<String> items = [
    'Lifestyle',
    'Finance',
    'News',
    'Fashion',
    'Music',
    'Business',
    'Food',
    'Game'
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    blog = widget.blog;
    if (blog != null) {
      titleController.text = blog!.title;
      textController.text = blog!.text;
      selectedValue = blog!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      backgroundColor: UIColor.secondaryColor,
      resizeToAvoidBottomInset: false,
      appBar: widgets.customAppBar(context,
          blog == null ? 'Yeni Blog Ekle' : 'Blogu Güncelle', false, false),
      body: Container(
        decoration: BoxDecoration(
            color: UIColor.primaryColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
                style: BorderStyle.solid, color: UIColor.secondaryColor)),
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        //color: UIColor.primaryColor,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: PushableButton(
                    height: 40,
                    hslColor: HSLColor.fromColor(UIColor.thirdColor),
                    child: Text(
                      blog == null ? 'Blog Ekle' : 'Blogu Güncelle',
                      style: const TextStyle(
                          color: UIColor.primaryColor,
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                    ),
                    onPressed: () => _submitForm(context),
                  ),
                ),
                const Gap(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: dropDownWidget(),
                ),
                const Gap(50),
                BlogAddTextField(
                  controller: titleController,
                  label: 'Başlık',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Başlık boş olamaz';
                    }
                    return null;
                  },
                ),
                const Gap(50),
                BlogAddTextField(
                  controller: textController,
                  label: 'Metin',
                  maxLines: 20,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Metin boş olamaz';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_formKey.currentState!.validate()) {
      if (selectedValue == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir kategori seçin')),
        );
        return;
      }

      final title = titleController.text;
      final text = textController.text;
      final category = selectedValue;

      try {
        final FirebaseFirestore db = FirebaseFirestore.instance;
        final CollectionReference blogs = db.collection('blogs');

        if (blog == null) {
          // Create new blog
          Blog blog = Blog(
            title: title,
            text: text,
            author: await getUserEmail2(),
            time: DateTime.now(),
            category: category!,
            authorId: user!.uid,
          );

          BlogService().addBlog(blog: blog);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog başarıyla eklendi!')),
          );
        } else {
          // Update existing blog
          await blogs.doc(blog!.id).update({
            'title': title,
            'text': text,
            'category': category,
            'time': DateTime.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog başarıyla güncellendi!')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    }
  }

  DropdownButtonHideUnderline dropDownWidget() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 30,
              color: UIColor.fourthColor,
            ),
            Gap(10),
            Text(
              'Kategori Seç',
              style: TextStyle(color: UIColor.fourthColor),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: UIColor.fourthColor),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Lütfen bir kategori seçin';
          }
          return null;
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 200,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: UIColor.secondaryColor,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: UIColor.fourthColor,
          iconDisabledColor: UIColor.secondaryColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: UIColor.secondaryColor,
          ),
          offset: const Offset(60, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

String getUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String email = user.email!;
    return email.substring(0, email.indexOf('@'));
  } else {
    return '';
  }
}

Future<String> getUserEmail2() async {
  return await UserService()
      .getUserById(FirebaseAuth.instance.currentUser!.uid);
}
