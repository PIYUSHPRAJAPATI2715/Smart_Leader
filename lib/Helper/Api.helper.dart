import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:smart_leader/Componants/session_manager.dart';
import 'package:smart_leader/Helper/Api.network.dart';
import 'package:http/http.dart' as http;
import 'package:smart_leader/Modal/about_us_modal.dart';
import 'package:smart_leader/Modal/add_connection_modal.dart';
import 'package:smart_leader/Modal/add_connevtion_folder_modal.dart';
import 'package:smart_leader/Modal/add_meeting_modal.dart';
import 'package:smart_leader/Modal/add_note_modal.dart';
import 'package:smart_leader/Modal/add_task_modal.dart';
import 'package:smart_leader/Modal/add_to_cart_book_modal.dart';
import 'package:smart_leader/Modal/add_video_modal.dart';
import 'package:smart_leader/Modal/book_tags.dart';
import 'package:smart_leader/Modal/branch.dart';
import 'package:smart_leader/Modal/contact_us_modal.dart';
import 'package:smart_leader/Modal/delete_connection_folder_modal.dart';
import 'package:smart_leader/Modal/delete_connection_modal.dart';
import 'package:smart_leader/Modal/delete_folder_modal.dart';
import 'package:smart_leader/Modal/delete_multiple_meeting_modal.dart';
import 'package:smart_leader/Modal/delete_note_note.dart';
import 'package:smart_leader/Modal/delete_task_modal.dart';
import 'package:smart_leader/Modal/downloaded_book_modal.dart';
import 'package:smart_leader/Modal/edit_connection_modal.dart';
import 'package:smart_leader/Modal/edit_note_modal.dart';
import 'package:smart_leader/Modal/edit_task_modal.dart';
import 'package:smart_leader/Modal/events.dart';
import 'package:smart_leader/Modal/join_team.dart';
import 'package:smart_leader/Modal/login_modal.dart';
import 'package:smart_leader/Modal/message_response.dart';
import 'package:smart_leader/Modal/multiple_delete_notes_modal.dart';
import 'package:smart_leader/Modal/multiple_delete_task_modal.dart';
import 'package:smart_leader/Modal/my_joined_team.dart';
import 'package:smart_leader/Modal/my_team.dart';
import 'package:smart_leader/Modal/new_event.dart';
import 'package:smart_leader/Modal/place_order_modal.dart';
import 'package:smart_leader/Modal/privecy_policy_screen.dart';
import 'package:smart_leader/Modal/remove_added_video_modal.dart';
import 'package:smart_leader/Modal/remove_cart_modal.dart';
import 'package:smart_leader/Modal/show_added_video_modal.dart';
import 'package:smart_leader/Modal/show_analytics.dart';
import 'package:smart_leader/Modal/show_banner_modal.dart';
import 'package:smart_leader/Modal/show_book_list_modal.dart';
import 'package:smart_leader/Modal/show_cart_book_modal.dart';
import 'package:smart_leader/Modal/show_connection_folder_modal.dart';
import 'package:smart_leader/Modal/show_connection_modal.dart';
import 'package:smart_leader/Modal/show_expense.dart';
import 'package:smart_leader/Modal/show_folder_modal.dart';
import 'package:smart_leader/Modal/show_note_modal.dart';
import 'package:smart_leader/Modal/show_search_meeting_modal.dart';
import 'package:smart_leader/Modal/show_sub_team.dart';
import 'package:smart_leader/Modal/show_task_modal.dart';
import 'package:smart_leader/Modal/show_videos_modal.dart';
import 'package:smart_leader/Modal/simple_response.dart';
import 'package:smart_leader/Modal/team_branch.dart';
import 'package:smart_leader/Modal/team_graph.dart';
import 'package:smart_leader/Modal/termsCondition_modal.dart';
import 'package:smart_leader/Modal/update_profilename_modal.dart';

import '../Modal/language_filter_model.dart';
import '../Modal/vidoes_name_model.dart';

class ApiHelper {
  static Future<LoginModal> login(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.login);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return LoginModal.fromJson(jsonDecode(response.body));
      } else {
        return LoginModal(result: 'Something went wrong!');
      }
    } catch (e) {
      return LoginModal(result: 'Something went wrong!');
    }
  }

  static Future<ShowBannerModal> homeBanner() async {
    Uri uri = Uri.parse(ApiNetwork.homeBanner);

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return ShowBannerModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowBannerModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowBannerModal(message: 'Something went wrong!');
    }
  }

  static Future<TermsConditionModal> termCondition() async {
    Uri uri = Uri.parse(ApiNetwork.termsCondition);

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return TermsConditionModal.fromJson(jsonDecode(response.body));
      } else {
        return TermsConditionModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return TermsConditionModal(message: 'Something went wrong!');
    }
  }

  static Future<PrivecyPolicyModal> privecyPolicy() async {
    Uri uri = Uri.parse(ApiNetwork.termsCondition);

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return PrivecyPolicyModal.fromJson(jsonDecode(response.body));
      } else {
        return PrivecyPolicyModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return PrivecyPolicyModal(message: 'Something went wrong!');
    }
  }

  static Future<AboutUsModal> aboutUs() async {
    Uri uri = Uri.parse(ApiNetwork.aboutUs);

    try {
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return AboutUsModal.fromJson(jsonDecode(response.body));
      } else {
        return AboutUsModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AboutUsModal(message: 'Something went wrong!');
    }
  }

  static Future<ContactUsModal> contacTUs(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.contactUs);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ContactUsModal.fromJson(jsonDecode(response.body));
      } else {
        return ContactUsModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ContactUsModal(message: 'Something went wrong!');
    }
  }

  static Future<AddConnectionModal> addConnection(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addConection);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return AddConnectionModal.fromJson(jsonDecode(response.body));
      } else {
        return AddConnectionModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddConnectionModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowConnectionFolderModal> showConnectionFolder() async {
    Uri uri = Uri.parse(ApiNetwork.showConnecFolder);

    Map<String, String> body = {'user_id': SessionManager.getUserID()};
    print(SessionManager.getUserID());
    try {
      final response = await http.post(uri, body: body);
      print("jasaasasaha${response.body}");

      if (response.statusCode == 200) {
        return ShowConnectionFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowConnectionFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowConnectionFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<AddConnectionFolderModal> addConnectFolder(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addConnecFolder);

    try {
      final response = await http.post(uri, body: map);

      if (response.statusCode == 200) {
        return AddConnectionFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return AddConnectionFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddConnectionFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<DeleteConnectionFolderModal> deleteConnectFolder(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteConnecFolder);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return DeleteConnectionFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return DeleteConnectionFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return DeleteConnectionFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowConnectionModal> showConnection(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showConection);

    try {
      final response = await http.post(uri, body: map);

      print('CONN ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return ShowConnectionModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowConnectionModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowConnectionModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowConnectionDeleteModal> deleteConection(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteConnection);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowConnectionDeleteModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowConnectionDeleteModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowConnectionDeleteModal(message: 'Something went wrong!');
    }
  }

  static Future<UpdateProfileINameModal> updatedName(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.updateName);
    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return UpdateProfileINameModal.fromJson(jsonDecode(response.body));
      } else {
        return UpdateProfileINameModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return UpdateProfileINameModal(message: 'Something went wrong!');
    }
  }

  static Future<AddConnectionModal> addFolder(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addFolder);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return AddConnectionModal.fromJson(jsonDecode(response.body));
      } else {
        return AddConnectionModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddConnectionModal(message: 'Something went wrong!');
    }
  }

  static Future<EditConnectionModal> editConnection(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editConnection);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return EditConnectionModal.fromJson(jsonDecode(response.body));
      } else {
        return EditConnectionModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return EditConnectionModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowFolderModal> showFolder() async {
    Uri uri = Uri.parse(ApiNetwork.showfolder);

    Map<String, String> body = {"user_id": SessionManager.getUserID()};

    try {
      final response = await http.post(uri, body: body);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<DeleteFolderModal> deleteFolder(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteFoldre);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return DeleteFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return DeleteFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return DeleteFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowFolderModal> showstaticFolder() async {
    Uri uri = Uri.parse(ApiNetwork.showstaticFolder);

    try {
      final response = await http.post(uri);
      print("jahdsdsdsdsddsddsxsdsda${response.body}");
      if (response.statusCode == 200) {
        return ShowFolderModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowFolderModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowFolderModal(message: 'Something went wrong!');
    }
  }

  static Future<AddNoteModal> addNote(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addNote);

    try {
      final response = await http.post(uri, body: map);
      print("jasaasaasaassaaha${response.body}");
      if (response.statusCode == 200) {
        return AddNoteModal.fromJson(jsonDecode(response.body));
      } else {
        return AddNoteModal(message: 'Something went wrong!');
      }
    } catch (e) {
      print(e);
      return AddNoteModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowNoteModal> showNote(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showNote);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowNoteModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowNoteModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowNoteModal(message: 'Something went wrong!');
    }
  }

  static Future<DeleteNoteModal> deleteNote(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteNote);

    try {
      final response = await http.post(uri, body: map);
      print("ddddd${response.body}");
      if (response.statusCode == 200) {
        return DeleteNoteModal.fromJson(jsonDecode(response.body));
      } else {
        return DeleteNoteModal(message: 'Something went wrong!');
      }
    } catch (e) {
      print(e);
      return DeleteNoteModal(message: 'Something went wrong!');
    }
  }

  static Future<MultipleDeleteNotesModal> multideleteNote(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.multipledeleteNote);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return MultipleDeleteNotesModal.fromJson(jsonDecode(response.body));
      } else {
        return MultipleDeleteNotesModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return MultipleDeleteNotesModal(message: 'Something went wrong!');
    }
  }

  static Future<EditeNoteModal> editNote(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editNote);

    try {
      final response = await http.post(uri, body: map);
      print("demo yrr note${response.body}");
      if (response.statusCode == 200) {
        return EditeNoteModal.fromJson(jsonDecode(response.body));
      } else {
        return EditeNoteModal(message: 'Something went wrong!');
      }
    } catch (e) {
      print("edit cathch note${e}");
      return EditeNoteModal(message: 'Something went wrong!');
    }
  }

  static Future<AddTaskModal> addTask(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addTask);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return AddTaskModal.fromJson(jsonDecode(response.body));
      } else {
        return AddTaskModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddTaskModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowTaskModal> showTask() async {
    Uri uri = Uri.parse(ApiNetwork.showTask);
    Map<String, String> body = {"user_id": SessionManager.getUserID()};

    try {
      final response = await http.post(uri, body: body);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowTaskModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowTaskModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowTaskModal(message: 'Something went wrong!');
    }
  }

  static Future<DeleteTaskModal> deleteTask(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteTsk);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return DeleteTaskModal.fromJson(jsonDecode(response.body));
      } else {
        return DeleteTaskModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return DeleteTaskModal(message: 'Something went wrong!');
    }
  }

  static Future<MultipleDeleteTaskModal> multideleteTask(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.multideleteTask);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return MultipleDeleteTaskModal.fromJson(jsonDecode(response.body));
      } else {
        return MultipleDeleteTaskModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return MultipleDeleteTaskModal(message: 'Something went wrong!');
    }
  }

  static Future<EditTaskModal> editTask(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editTask);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return EditTaskModal.fromJson(jsonDecode(response.body));
      } else {
        return EditTaskModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return EditTaskModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowBookListModal> showebookList(String tag) async {
    Uri uri = Uri.parse(ApiNetwork.ebookList);

    try {
      final response = await http.post(uri, body: {'tag': tag});
      if (response.statusCode == 200) {
        return ShowBookListModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowBookListModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowBookListModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowBookListModal> searchBook(String search) async {
    Uri uri = Uri.parse(ApiNetwork.searchBook);

    try {
      Map<String, String> body = {'word': search};
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        return ShowBookListModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowBookListModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowBookListModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowBookListModal> newaddedbookList() async {
    Uri uri = Uri.parse(ApiNetwork.newEditBookList);

    try {
      final response = await http.post(
        uri,
      );
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowBookListModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowBookListModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowBookListModal(message: 'Something went wrong!');
    }
  }

  static Future<AddToCartBookModal> addtoCart(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addtoCart);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return AddToCartBookModal.fromJson(jsonDecode(response.body));
      } else {
        return AddToCartBookModal(result: 'Something went wrong!');
      }
    } catch (e) {
      return AddToCartBookModal(result: 'Something went wrong!');
    }
  }

  static Future<ShowCartBookModal> showCart() async {
    Map<String, String> map = {"user_id": SessionManager.getUserID()};
    Uri uri = Uri.parse(ApiNetwork.showCart);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowCartBookModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowCartBookModal();
      }
    } catch (e) {
      return ShowCartBookModal();
    }
  }

  static Future<AddMeetingModal> addMeeting(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addMeeting);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return AddMeetingModal.fromJson(jsonDecode(response.body));
      } else {
        return AddMeetingModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddMeetingModal(message: 'Something went wrong!');
    }
  }

  static Future<DeleteMeetingModal> multideleteMeeting(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteMeting);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return DeleteMeetingModal.fromJson(jsonDecode(response.body));
      } else {
        return DeleteMeetingModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return DeleteMeetingModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowSearchMeetingModal> showsearchMeeting() async {
    Uri uri = Uri.parse(ApiNetwork.serchMeeting);
    Map<String, String> body = {"user_id": SessionManager.getUserID()};

    try {
      final response = await http.post(uri, body: body);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowSearchMeetingModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowSearchMeetingModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowSearchMeetingModal(message: 'Something went wrong!');
    }
  }

  static Future<RemoveCartModal> deleteCart(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.removecart);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return RemoveCartModal.fromJson(jsonDecode(response.body));
      } else {
        return RemoveCartModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return RemoveCartModal(message: 'Something went wrong!');
    }
  }

  static Future<PlaceOrderModal> placeOrder(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.placeOrder);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return PlaceOrderModal.fromJson(jsonDecode(response.body));
      } else {
        return PlaceOrderModal(result: 'Something went wrong!');
      }
    } catch (e) {
      return PlaceOrderModal(result: 'Something went wrong!');
    }
  }

  static Future<ShowVideosModal> showeVideoList(
      Map<String, dynamic> body) async {
    Uri uri = Uri.parse(ApiNetwork.showVideo);

    try {
      final response = await http.post(uri, body: body);
      print("VideoData:::${response.body}");
      if (response.statusCode == 200) {
        return ShowVideosModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowVideosModal(message: 'Something went wrong!');
      }
    } catch (e) {
      print("Catch$e");
      return ShowVideosModal(message: 'Something went wrong!');
    }
  }

  static Future<LanguageFilterModel> languageFilter() async {
    Uri uri = Uri.parse(ApiNetwork.languageFilter);

    try {
      final response = await http.get(
        uri,
      );
      print("LanguageFilter${response.body}");
      if (response.statusCode == 200) {
        return LanguageFilterModel.fromJson(jsonDecode(response.body));
      } else {
        return LanguageFilterModel(status: false);
      }
    } catch (e) {
      print("LanguageFilterCatch$e");
      return LanguageFilterModel(status: false);
    }
  }

  static Future<DownloadEbooksModal> showeDowloadedList(
      String languageID) async {
    Map<String, String> body = {
      "user_id": SessionManager.getUserID(),
      "language_key": languageID.toString(),
    };

    Uri uri = Uri.parse(ApiNetwork.downloadBokks);
    print("BODY$body");

    try {
      final response = await http.post(uri, body: body);
      print("ShowDownloadList :: ${response.body}");
      if (response.statusCode == 200) {
        return DownloadEbooksModal.fromJson(jsonDecode(response.body));
      } else {
        return DownloadEbooksModal(message: 'Something went wrong!');
      }
    } catch (e) {
      print("ShowDownloadListCatch :: $e");
      return DownloadEbooksModal(message: 'Something went wrong!');
    }
  }

  static Future<AddVideoModal> addVideo(Map<String, String> body) async {
    Uri uri = Uri.parse(ApiNetwork.addVideo);
    try {
      final response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        return AddVideoModal.fromJson(jsonDecode(response.body));
      } else {
        return AddVideoModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return AddVideoModal(message: 'Something went wrong!');
    }
  }

  static Future<ShowVideoModal> showaddedVideo() async {
    Map<String, String> body = {"user_id": SessionManager.getUserID()};
    Uri uri = Uri.parse(ApiNetwork.showaddedVideo);
    try {
      final response = await http.post(uri, body: body);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return ShowVideoModal.fromJson(jsonDecode(response.body));
      } else {
        return ShowVideoModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowVideoModal(message: 'Something went wrong!');
    }
  }

  static Future<VideoRemoveModal> removeVideo(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.removeVideo);

    try {
      final response = await http.post(uri, body: map);
      print("jaha${response.body}");
      if (response.statusCode == 200) {
        return VideoRemoveModal.fromJson(jsonDecode(response.body));
      } else {
        return VideoRemoveModal(message: 'Something went wrong!');
      }
    } catch (e) {
      return VideoRemoveModal(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> moveNotes(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.moveNotes);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> addEvents(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addEvents);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<Events> showEvent(String type) async {
    Uri uri = Uri.parse(ApiNetwork.showEvents);

    try {
      final response = await http.post(uri,
          body: {'user_id': SessionManager.getUserID(), 'type': type});

      if (response.statusCode == 200) {
        return Events.fromJson(jsonDecode(response.body));
      } else {
        return Events(message: 'Something went wrong!');
      }
    } catch (e) {
      return Events(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> deleteEvent(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteEvents);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> editEvent(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editEvents);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print('response ${jsonDecode(response.body)}');
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> addExpense(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addExpense);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<ShowExpense> showExpense() async {
    Uri uri = Uri.parse(ApiNetwork.showExpense);

    try {
      final response = await http.post(uri, body: {
        'user_id': SessionManager.getUserID(),
      });
      if (response.statusCode == 200) {
        return ShowExpense.fromJson(jsonDecode(response.body));
      } else {
        return ShowExpense(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowExpense(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> addTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> addIndividualTeam(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addIndividualTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MyTeam> showTeam() async {
    Uri uri = Uri.parse(ApiNetwork.showTeam);

    try {
      final response =
          await http.post(uri, body: {'user_id': SessionManager.getUserID()});
      if (response.statusCode == 200) {
        return MyTeam.fromJson(jsonDecode(response.body));
      } else {
        return MyTeam(message: 'Something went wrong!');
      }
    } catch (e) {
      return MyTeam(message: 'Something went wrong!');
    }
  }

  static Future<MyTeam> showIndividualTeam() async {
    Uri uri = Uri.parse(ApiNetwork.showIndividualTeam);

    try {
      final response =
          await http.post(uri, body: {'user_id': SessionManager.getUserID()});
      if (response.statusCode == 200) {
        return MyTeam.fromJson(jsonDecode(response.body));
      } else {
        return MyTeam(message: 'Something went wrong!');
      }
    } catch (e) {
      return MyTeam(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateIndividualTeamAmount(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editIndividualTeamAmount);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateTargetTeam(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.targetUpdateTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateIndividualTarget(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.editIndividualTargetAmount);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> joinTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.joinTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> deleteTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> deleteIndividualTeam(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteIndividualTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<JoinedTeam> myJoinTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showJoinTeam);

    try {
      final response = await http.post(uri, body: map);
      print('RES ${response.statusCode}');
      if (response.statusCode == 200) {
        return JoinedTeam.fromJson(jsonDecode(response.body));
      } else {
        return JoinedTeam(message: 'Something went wrong!!');
      }
    } catch (e) {
      print('ERROR $e');
      return JoinedTeam(message: 'Something went wrong!');
    }
  }

  static Future<ShowSubTeam> showSubTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showSubTeam);

    try {
      final response = await http.post(uri, body: map);
      print('RES ${response.statusCode}');
      if (response.statusCode == 200) {
        return ShowSubTeam.fromJson(jsonDecode(response.body));
      } else {
        return ShowSubTeam(message: 'Something went wrong!!');
      }
    } catch (e) {
      print('ERROR $e');
      return ShowSubTeam(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateJoinTeamAmount(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.updateJoinCompleteAmount);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateMemberSubTeamTarget(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.updateMemberSubTeamTarget);

    try {
      final response = await http.post(uri, body: map);

      print('RESOose ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MyJoinedTeam> showMyJoinedTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showMyJoinedTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MyJoinedTeam.fromJson(jsonDecode(response.body));
      } else {
        return MyJoinedTeam(message: 'Something went wrong!');
      }
    } catch (e) {
      return MyJoinedTeam(message: 'Something went wrong!');
    }
  }

  static Future<BooksTags> getBookTags() async {
    Uri uri = Uri.parse(ApiNetwork.bookTags);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return BooksTags.fromJson(jsonDecode(response.body));
      } else {
        return BooksTags(message: 'Something went wrong!');
      }
    } catch (e) {
      return BooksTags(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> addBranch(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addBranch);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateBranch(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.updateBranch);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> deleteBranch(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteBranch);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<Branch> showBranch() async {
    Uri uri = Uri.parse(ApiNetwork.showBranch);

    try {
      final response =
          await http.post(uri, body: {'user_id': SessionManager.getUserID()});
      if (response.statusCode == 200) {
        return Branch.fromJson(jsonDecode(response.body));
      } else {
        return Branch(message: 'Something went wrong!');
      }
    } catch (e) {
      return Branch(message: 'Something went wrong!');
    }
  }

  static Future<TeamBranch> showBranchByTeam(String branchId) async {
    Uri uri = Uri.parse(ApiNetwork.showTeamByBranch);

    try {
      final response = await http.post(uri, body: {'branch_id': branchId});
      if (response.statusCode == 200) {
        return TeamBranch.fromJson(jsonDecode(response.body));
      } else {
        return TeamBranch(message: 'Something went wrong!');
      }
    } catch (e) {
      return TeamBranch(message: 'Something went wrong!');
    }
  }

  static Future<TeamGraph> showTeamGraph() async {
    Uri uri = Uri.parse(ApiNetwork.showTeamGraph);

    try {
      final response = await http.post(uri, body: {
        'user_id': SessionManager.getUserID(),
      });
      if (response.statusCode == 200) {
        return TeamGraph.fromJson(jsonDecode(response.body));
      } else {
        return TeamGraph(message: 'Something went wrong!');
      }
    } catch (e) {
      return TeamGraph(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> copyTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.copyTeam);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<ShowAnalytics> showAnalytics(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.showAnalytics);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return ShowAnalytics.fromJson(jsonDecode(response.body));
      } else {
        return ShowAnalytics(message: 'Something went wrong!');
      }
    } catch (e) {
      return ShowAnalytics(message: 'Something went wrong!');
    }
  }

  static Future<MessageResponse> updateTargetLock(
      Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.lockTargetAmount);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return MessageResponse.fromJson(jsonDecode(response.body));
      } else {
        return MessageResponse(message: 'Something went wrong!');
      }
    } catch (e) {
      return MessageResponse(message: 'Something went wrong!');
    }
  }

  static Future<ResultResponse> deleteSubTeam(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteSubTeam);
    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return ResultResponse.fromJson(jsonDecode(response.body));
      } else {
        return ResultResponse(result: 'Something went wrong!');
      }
    } catch (e) {
      return ResultResponse(result: 'Something went wrong!');
    }
  }

  //todo: ******************************************************************
  static Future<SimpleResponse> addNewEvents(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.addNewEvent);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return SimpleResponse.fromJson(jsonDecode(response.body));
      } else {
        return SimpleResponse(massage: 'Something went wrong!');
      }
    } catch (e) {
      return SimpleResponse(massage: 'Something went wrong!');
    }
  }

  static Future<SimpleResponse> deleteNewEvent(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.deleteNewEvent);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return SimpleResponse.fromJson(jsonDecode(response.body));
      } else {
        return SimpleResponse(massage: 'Something went wrong!');
      }
    } catch (e) {
      return SimpleResponse(massage: 'Something went wrong!');
    }
  }

  static Future<SimpleResponse> updateNewEvent(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.updateNewEvent);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        return SimpleResponse.fromJson(jsonDecode(response.body));
      } else {
        return SimpleResponse(massage: 'Something went wrong!');
      }
    } catch (e) {
      return SimpleResponse(massage: 'Something went wrong!');
    }
  }

  static Future<NewEvent> getNewEvent(Map<String, String> map) async {
    Uri uri = Uri.parse(ApiNetwork.getNewEvent);

    try {
      final response = await http.post(uri, body: map);
      if (response.statusCode == 200) {
        print(response.body);
        return NewEvent.fromJson(jsonDecode(response.body));
      } else {
        return NewEvent(massage: 'Something went wrong!');
      }
    } catch (e) {
      print(e);
      return NewEvent(massage: 'Something went wrong!');
    }
  }
  //video name
  static Future<VideosName> getvideosName() async {
    final url = Uri.parse(ApiNetwork.get_video_names);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['status'] == true) {
          return VideosName.fromJson(decodedData);
        } else {
          return VideosName(status: false, message: decodedData['message'] ?? 'Unknown error');
        }
      } else {
        if (kDebugMode) {
          print('HTTP Error: ${response.statusCode}, Body: ${response.body}');
        }
        return VideosName(status: false, message: 'Data not found');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Exception: $e');
        print('StackTrace: $stackTrace');
      }
      return VideosName(status: false, message: 'Something went wrong');
    }
  }
}
