import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:manage/api/response_error.dart';
import 'package:manage/widgets/animated_snackbar.dart';
import 'package:manage/widgets/bottom_sheet.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../api/api.dart';
import '../../utilities/appearance/style.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/infinite_list.dart';
import '../locations/widgets/progress_button.dart';
import 'models/user.dart';

class Users extends StatefulWidget {
  const Users({required this.title, required this.type, Key? key})
      : super(key: key);
  final String title;
  final String type;

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final API api = API('User');

  final List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.type == 'admin')
            IconButton(
              onPressed: addUser,
              icon: const Icon(Icons.add_rounded),
            )
        ],
      ),
      body: InfiniteList<User>(
        padding: const EdgeInsets.all(10),
        items: users,
        getItems: (List<String> sentItemsIds) {
          return getUsers(sentItemsIds);
        },
        child: (int index) => Card(
          child: Obx(
            () => Slidable(
              useTextDirection: false,
              endActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const DrawerMotion(),
                children: [
                  users[index].isActive.value
                      ? SlidableAction(
                          onPressed: (_) {
                            CustomAlertDialog.show(
                              animation: true,
                              type: AlertType.question,
                              title: '???? ???????? ???????? ${users[index].name}??',
                              showCancelButton: true,
                              confirmBackgroundColor: Colors.red,
                              confirmText: '??????',
                              onConfirmPressed: () => changeState(
                                index: index,
                                state: false,
                                type: '??????',
                              ),
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.cancel_rounded,
                          label: '??????',
                        )
                      : SlidableAction(
                          onPressed: (_) {
                            CustomAlertDialog.show(
                              animation: true,
                              type: AlertType.question,
                              title: '???? ???????? ???????????? ${users[index].name}??',
                              showCancelButton: true,
                              confirmBackgroundColor: Colors.green,
                              confirmText: '??????????',
                              onConfirmPressed: () => changeState(
                                index: index,
                                state: true,
                                type: '??????????',
                              ),
                            );
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check_circle_rounded,
                          label: '??????????',
                        ),
                ],
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: users[index].isActive.value
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('${index + 1}'),
                ),
                title: Text(users[index].name),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(users[index].username),
                    if (users[index].isVerified)
                      Text(' | ${users[index].verifiedAt!}')
                  ],
                ),
                trailing: users[index].isVerified
                    ? const Icon(
                        Icons.mark_email_read_rounded,
                        color: AppColors.mainColor,
                      )
                    : const Icon(
                        Icons.access_time_filled_rounded,
                        color: Colors.orange,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<User>> getUsers(List<String> sentIds) async {
    var data = await api.post('GetUsers', data: {widget.type: sentIds});
    return User.fromJson(data);
  }

  Future<void> addUser() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController name = TextEditingController();
    final TextEditingController username = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController privateCode = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController confPassword = TextEditingController();

    bool obscurePassword = true;

    User? user = await showGetBottomSheet(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: '?????????? ????????????',
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: name,
                labelText: '??????????',
                hintText: '???????? ??????????',
                prefixIcon: Icons.person_pin_rounded,
                validator: (val) {
                  if (val!.trim().isEmpty) return '???????? ??????????';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: email,
                labelText: '???????????? ????????????????????',
                hintText: '???????? ???????????? ????????????????????',
                prefixIcon: Icons.email_rounded,
                validator: (val) {
                  if (val!.trim().isEmpty) return '???????? ???????????? ????????????????????';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: username,
                labelText: '?????? ????????????????',
                hintText: '???????? ?????? ????????????????',
                prefixIcon: Icons.person_rounded,
                validator: (val) {
                  if (val!.trim().isEmpty) return '???????? ?????? ????????????????';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Column(
                    children: [
                      CustomTextFormField(
                        controller: password,
                        labelText: '???????? ????????',
                        hintText: '???????? ???????? ????????',
                        prefixIcon: Icons.lock_rounded,
                        obscureText: obscurePassword,
                        showObscureWidget: false,
                        obscureWidget: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: Icon(
                            obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 20,
                            color: AppColors.mainColor,
                          ),
                        ),
                        validator: (val) {
                          if (val!.trim().isEmpty) return '???????? ???????? ????????';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: confPassword,
                        labelText: '?????????? ???????? ????????',
                        hintText: '???????? ???????? ????????',
                        prefixIcon: Icons.lock_rounded,
                        obscureText: obscurePassword,
                        showObscureWidget: false,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return '???????? ???????? ????????';
                          } else if (val.trim() != password.text.trim()) {
                            return '???????? ???????? ???? ????????????';
                          }
                          return null;
                        },
                      ),
                      const Divider(height: 20),
                      CustomTextFormField(
                        controller: privateCode,
                        labelText: '?????????? ????????????',
                        hintText: '???????? ?????????? ????????????',
                        prefixIcon: Icons.phonelink_lock_rounded,
                        obscureText: true,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return '???????? ?????????? ????????????';
                          } else if (val.trim() == password.text.trim()) {
                            return '?????????? ???????????? ?????? ???? ???? ???????? ???????? ????????';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      LocationProgressButton(
                        confirmText: '??????????',
                        successMessage: '???? ?????????? ???????????????? ??????????',
                        formKey: formKey,
                        onPressed: () async {
                          User user = User(
                            id: '',
                            name: name.text.trim(),
                            username: username.text.trim(),
                            isVerified: false,
                            verifiedAt: '',
                            isActive: RxBool(true),
                          );
                          return await api.post(
                            'AddUser',
                            data: {
                              'name': user.name,
                              'email': email.text.trim(),
                              'username': user.username,
                              'password': password.text.trim(),
                              'privateCode': privateCode.text.trim(),
                            },
                          );
                        },
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );

    if (user != null) {
      setState(() {
        users.insert(0, user);
      });
    }
  }

  Future<void> changeState({
    required int index,
    required bool state,
    required String type,
  }) async {
    context.loaderOverlay.show();
    try {
      await api.post('ChangeState', data: {users[index].id: state});
      context.loaderOverlay.hide();
      Get.back();
      showSnackBar(
          message: '???? $type ${users[index].name}', type: AlertType.success);
      users[index].isActive(state);
    } catch (e) {
      context.loaderOverlay.hide();
      showSnackBar(
        title: '???????? ??????????????',
        message: '?????? $type ${users[index].name}',
        type: AlertType.failure,
      );
    }
  }
}
