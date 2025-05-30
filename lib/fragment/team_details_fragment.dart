import 'package:flutter/material.dart';

import '../Componants/Custom_text.dart';
import '../Componants/custom_bottun.dart';
import '../Componants/custom_textField.dart';
import '../Componants/session_manager.dart';
import '../Helper/Api.helper.dart';
import '../Helper/helper.dart';
import '../Helper/theme_colors.dart';
import '../Modal/branch.dart';
import '../Screen/team_by_branch_screen.dart';

class TeamDetailsFragment extends StatefulWidget {
  const TeamDetailsFragment({super.key});

  @override
  State<TeamDetailsFragment> createState() => _TeamDetailsFragmentState();
}

class _TeamDetailsFragmentState extends State<TeamDetailsFragment> {
  final TextEditingController _branchNameController = TextEditingController();

  late Future<Branch> _branchFuture;
  Future<Branch> getBranch() {
    return ApiHelper.showBranch();
  }
  @override
  void initState() {
    // TODO: implement initState
    _branchFuture = getBranch();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                      hight: 50.0,
                      title: 'Enter Team Name',
                      controller: _branchNameController,
                      hint: '',
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      lableName: 'Team Name (Max 6 teams allowed)',
                      hintfont: 14,
                      lablefont: 14),
                ),
                const SizedBox(width: 10.0),
                Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  child: custom_Button(
                    onTap: addBranch,
                    title: 'Add Team',
                    hight: 50.0,
                    width: 100,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<Branch>(
              future: _branchFuture,
              builder: (context, response) {
                if (response.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<BranchData> branchList = response.data!.data!;

                if (branchList.isEmpty) {
                  return Center(
                    child: customtext(
                        fontWeight: FontWeight.w500,
                        text: 'No Team added',
                        fontsize: 14.0),
                  );
                }

                return ListView.builder(
                  itemCount: branchList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamByBranchScreen(
                              branchData: branchList[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: KBoxNewColor)),
                        child: Row(
                          children: [
                            Expanded(
                              child: customtext(
                                fontWeight: FontWeight.w500,
                                text: branchList[index].btanchName!,
                                fontsize: 12.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  child: const Icon(
                                    Icons.edit,
                                    color: kblueColor,
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return UpdateBranchWidget(
                                            branchData: branchList[index],
                                          );
                                        }).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          _branchFuture = getBranch();
                                        });
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 15.0),
                                InkWell(
                                  child: const Icon(Icons.delete,
                                      color: kredColor),
                                  onTap: () {
                                    deleteDialog(branchList[index].id!);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void addBranch() {
    if (_branchNameController.text.isEmpty) {
      Helper.toastMassage('Enter branch name', Colors.red);
      return;
    }

    Map<String, String> body = {
      'btanch_name': _branchNameController.text,
      'user_id': SessionManager.getUserID(),
    };

    Helper.showLoaderDialog(context, message: 'Adding...');
    ApiHelper.addBranch(body).then((value) {
      Navigator.pop(context);
      if (value.message == 'Team Add Successfully ') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        _branchNameController.clear();
        setState(() {
          _branchFuture = getBranch();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }

  void checkBranchContainsTeam(String branchId) {
    Helper.showLoaderDialog(context, message: 'Please wait...');

    ApiHelper.showBranchByTeam(branchId).then((value) {
      Navigator.pop(context);
      if (value.data!.isEmpty) {
        //then go to delete
        deleteBranch(branchId);
      } else {
        Helper.toastMassage('Please delete team first', Colors.red);
      }
    });
  }

  void deleteDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: customtext(
          fontWeight: FontWeight.w500,
          text: "Confirm Deletion ?",
          fontsize: 22,
          color: Theme.of(context).primaryColor,
        ),
        content: customtext(
          fontWeight: FontWeight.w400,
          text: "",
          fontsize: 15,
          color: Theme.of(context).primaryColor,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: customtext(
                    fontWeight: FontWeight.w600, text: 'No', fontsize: 12),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);

                  checkBranchContainsTeam(id);
                },
                child: customtext(
                  fontWeight: FontWeight.w600,
                  text: 'Yes',
                  fontsize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void deleteBranch(String id) {
    Map<String, String> map = {'id': id};

    Helper.showLoaderDialog(context, message: 'Deleting...');

    ApiHelper.deleteBranch(map).then((value) {
      Navigator.pop(context);
      if (value.message == ' Successfully Deleted') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        setState(() {
          _branchFuture = getBranch();
        });
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }

}


class UpdateBranchWidget extends StatefulWidget {
  const UpdateBranchWidget({Key? key, required this.branchData})
      : super(key: key);
  final BranchData branchData;

  @override
  State<UpdateBranchWidget> createState() => _UpdateBranchWidgetState();
}

class _UpdateBranchWidgetState extends State<UpdateBranchWidget> {
  final TextEditingController _branchNameController = TextEditingController();

  bool isUpdate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _branchNameController.text = widget.branchData.btanchName!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 15.0),
          decoration: const BoxDecoration(color: kblueColor),
          child: Row(
            children: [
              Expanded(
                child: customtext(
                  fontWeight: FontWeight.w500,
                  text: 'Update Name',
                  fontsize: 14.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear, color: Colors.white),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: CustomTextField(
              hight: 50.0,
              title: 'Enter Team Name',
              controller: _branchNameController,
              hint: '',
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              lableName: 'Team Name',
              hintfont: 12,
              lablefont: 12),
        ),
        isUpdate
            ? const Center(child: CircularProgressIndicator())
            : custom_Button(
            onTap: _updateBranch,
            title: 'Update',
            hight: 45.0,
            width: 100.0,
            fontSize: 14.0)
      ],
    );
  }

  void _updateBranch() {
    if (_branchNameController.text.isEmpty) {
      Helper.toastMassage('Enter branch name', Colors.red);
      return;
    }
    Map<String, String> body = {
      'id': widget.branchData.id!,
      'btanch_name': _branchNameController.text
    };

    setState(() {
      isUpdate = true;
    });

    ApiHelper.updateBranch(body).then((value) {
      setState(() {
        isUpdate = false;
      });

      if (value.message == 'Updated  Successfully') {
        Helper.showSnackVar(value.message!, Colors.green, context);
        Navigator.pop(context, true);
      } else {
        Helper.showSnackVar(value.message!, Colors.red, context);
      }
    });
  }
}
