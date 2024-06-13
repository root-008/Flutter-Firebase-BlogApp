import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  UserService userService = UserService();
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsers = [];
  Map<String, bool> isWriter = {};
  Map<String, bool> isReader = {};
  String searchQuery = '';
  String filterRole = 'all';

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    users = await userService.getUsersEmailAndRole();
    setState(() {
      // Initialize the checkboxes' states
      for (var user in users) {
        isWriter[user['email']!] = user['rool'] == 'writer';
        isReader[user['email']!] = user['rool'] == 'reader';
      }
      applyFilters();
    });
  }

  void updateUserRole(String email, String role) async {
    try {
      await userService.updateUserRoleByEmail(email, role);
      fetchUsers();
    } catch (e) {
      //print('Error updating user role: $e');
    }
  }

  void applyFilters() {
    setState(() {
      filteredUsers = users.where((user) {
        final matchesSearchQuery = user['email']!.contains(searchQuery);
        final matchesRoleFilter =
            filterRole == 'all' || user['rool'] == filterRole;
        return matchesSearchQuery && matchesRoleFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: UIWidgets().customAppBar(context, 'Admin', false, false),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: UIColor.primaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: UIColor.fourthColor),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Search by email',
                  labelStyle: TextStyle(color: UIColor.fourthColor),
                  hintText: 'Enter email',
                  hintStyle: TextStyle(color: UIColor.fourthColor),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    applyFilters();
                  });
                },
              ),
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<String>(
                  value: 'all',
                  groupValue: filterRole,
                  activeColor: UIColor.fourthColor,
                  onChanged: (value) {
                    setState(() {
                      filterRole = value!;
                      applyFilters();
                    });
                  },
                ),
                const Text('All', style: TextStyle(color: UIColor.fourthColor)),
                const SizedBox(width: 10),
                Radio<String>(
                  value: 'writer',
                  groupValue: filterRole,
                  activeColor: UIColor.fourthColor,
                  onChanged: (value) {
                    setState(() {
                      filterRole = value!;
                      applyFilters();
                    });
                  },
                ),
                const Text(
                  'Writer',
                  style: TextStyle(color: UIColor.fourthColor),
                ),
                const SizedBox(width: 10),
                Radio<String>(
                  value: 'reader',
                  groupValue: filterRole,
                  activeColor: UIColor.fourthColor,
                  onChanged: (value) {
                    setState(() {
                      filterRole = value!;
                      applyFilters();
                    });
                  },
                ),
                const Text(
                  'Reader',
                  style: TextStyle(color: UIColor.fourthColor),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  String email = filteredUsers[index]['email']!;
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: ListTile(
                      title: Text(email),
                      subtitle: Text('Role: ${filteredUsers[index]['rool']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Checkbox(
                                  value: isWriter[email],
                                  onChanged: (bool? value) {
                                    if (value != null && value) {
                                      updateUserRole(email, 'writer');
                                    }
                                  },
                                ),
                              ),
                              const Text('Writer'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Checkbox(
                                  value: isReader[email],
                                  onChanged: (bool? value) {
                                    if (value != null && value) {
                                      updateUserRole(email, 'reader');
                                    }
                                  },
                                ),
                              ),
                              const Text('Reader'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
