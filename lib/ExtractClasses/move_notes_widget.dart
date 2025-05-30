import 'package:flutter/material.dart';
import 'package:smart_leader/Componants/Custom_text.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.helper.dart';
import 'package:smart_leader/Helper/helper.dart';
import 'package:smart_leader/Helper/theme_colors.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';

class MoveNoteWidget extends StatefulWidget {
  const MoveNoteWidget({
    Key? key,
    required this.showfolderData,
    required this.noteId,
  }) : super(key: key);

  final List<ShowFolderModalData> showfolderData;
  final String noteId;

  @override
  State<MoveNoteWidget> createState() => _MoveNoteWidgetState();
}

class _MoveNoteWidgetState extends State<MoveNoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              color: kblueDarkColor,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: customtext(
                        fontWeight: FontWeight.w600,
                        text: 'Select Folder',
                        color: Colors.white,
                        fontsize: 16),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                shrinkWrap: true,
                itemCount: widget.showfolderData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      moveFolder(widget.showfolderData[index].id!,
                          widget.showfolderData[index].folderName!);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder,
                            color: Colors.amberAccent,
                          ),
                          SizedBox(width: 15.0),
                          customtext(
                            fontWeight: FontWeight.w600,
                            text: widget.showfolderData[index].folderName!,
                            fontsize: 16.0,
                            color: Colors.black87,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void moveFolder(String folderId, String folderName) {
    Map<String, String> body = {
      'user_id': SessionManager.getUserID(),
      'folder_id': folderId,
      'note_id': widget.noteId,
    };

    Helper.showLoaderDialog(context, message: 'Moving notes...');

    ApiHelper.moveNotes(body).then((value) {
      Navigator.pop(context);

      if (value.message == 'Note Move Successfully') {
        Navigator.pop(context, true);
        Helper.toastMassage('Note moved to $folderName', Colors.green);
      } else {
        Helper.toastMassage('Failed to move note', Colors.red);
      }
    });
  }
}
