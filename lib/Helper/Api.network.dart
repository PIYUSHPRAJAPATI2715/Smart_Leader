class ApiNetwork {
  static const String baseUrl =
      "https://ruparnatechnology.com/Smartleader/Api/process.php";

  static const String homeBanner = "$baseUrl?action=banner";

  static const String aboutUs = "$baseUrl?action=About_us";

  static const String termsCondition = "$baseUrl?action=terms_condition";

  static const String privecyPolicy = "$baseUrl?action=privacy_policy";

  static const String contactUs = "$baseUrl?action=contact_us";

  static const String addConection = "$baseUrl?action=connection";
  static const String showConection = "$baseUrl?action=show_connection";
  static const String editConnection = "$baseUrl?action=edit_connection";
  static const String deleteConnection = "$baseUrl?action=connection_delete";
  static const String login = "$baseUrl?action=social_login";
  static const String updateprofile = "$baseUrl?action=update_profile";
  static const String showprofile = "$baseUrl?action=show_profile";
  static const String updateName = "$baseUrl?action=update_name";
  static const String addFolder = "$baseUrl?action=add_folder";
  static const String showfolder = "$baseUrl?action=show_folder";
  static const String deleteFoldre = "$baseUrl?action=delete_folder";
  static const String showstaticFolder = "$baseUrl?action=show_static_folder";
  static const String addNote = "$baseUrl?action=add_note";
  static const String showNote = "$baseUrl?action=show_note";
  static const String deleteNote = "$baseUrl?action=delete_note";
  static const String editNote = "$baseUrl?action=edit_note";
  static const String multipledeleteNote =
      "$baseUrl?action=multipal_delete_note";
  static const String addTask = "$baseUrl?action=add_task";
  static const String showTask = "$baseUrl?action=show_task";
  static const String deleteTsk = "$baseUrl?action=task_delete";
  static const String multideleteTask = "$baseUrl?action=multipal_delete_task";
  static const String editTask = "$baseUrl?action=edit_task";
  static const String ebookList = "$baseUrl?action=show_book";
  static const String newEditBookList = "$baseUrl?action=New_edit_book";
  static const String addtoCart = "$baseUrl?action=add_cart";
  static const String showCart = "$baseUrl?action=show_cart";
  static const String addMeeting = "$baseUrl?action=add_meeting";
  static const String showMeting = "$baseUrl?action=show_meeting";
  static const String deleteMeting = "$baseUrl?action=multipal_delete_meeting";
  static const String serchMeeting = "$baseUrl?action=search_meeting";
  static const String removecart = "$baseUrl?action=delete_cart";
  static const String showVideo = "$baseUrl?action=show_video";
  static const String placeOrder = "$baseUrl?action=order_now";
  static const String downloadBokks = "$baseUrl?action=order_history";
  static const String showConnecFolder = "$baseUrl?action=show_connection_type";
  static const String addConnecFolder = "$baseUrl?action=add_connection_type";
  static const String deleteConnecFolder =
      "$baseUrl?action=connection_type_delete";
  static const String addVideo = "$baseUrl?action=video_download";
  static const String showaddedVideo = "$baseUrl?action=show_video_download";
  static const String removeVideo = "$baseUrl?action=delete_video_download";

  static const String moveNotes = "$baseUrl?action=notes_move";

  static const String addEvents = "$baseUrl?action=add_event";
  static const String showEvents = "$baseUrl?action=show_event";
  static const String deleteEvents = "$baseUrl?action=event_delete";
  static const String editEvents = "$baseUrl?action=edit_event";

  static const String addExpense = "$baseUrl?action=add_expense";

  static const String showExpense = "$baseUrl?action=show_expense";

  static const String addTeam = "$baseUrl?action=add_team";

  static const String showTeam = "$baseUrl?action=show_team";

  static const String editTeam = "$baseUrl?action=edit_team";

  static const String deleteTeam = "$baseUrl?action=delete_team";

  //https://ruparnatechnology.com/Smartleader/Api/process.php?action=target_update_team
  static const String targetUpdateTeam = "$baseUrl?action=target_update_team";

  static const String joinTeam = "$baseUrl?action=add_sub_team";

  static const String showJoinTeam = "$baseUrl?action=new_show_sub_team";

  //todo: deprecated api
  static const String showSubTeam = "$baseUrl?action=show_sub_team";

  // static const String updateJoinCompleteAmount = "$baseUrl?action=sub_team_completed";

  static const String updateJoinCompleteAmount =
      "$baseUrl?action=new_update_sub_team";

  static const String updateMemberSubTeamTarget =
      "$baseUrl?action=member_target_team";
  static const String showMyJoinedTeam = "$baseUrl?action=show_sub_team_member";

  static const String searchBook = "$baseUrl?action=search_book";

  static const String bookTags = "$baseUrl?action=show_tags";

  static const String addIndividualTeam = "$baseUrl?action=add_individual_team";

  static const String deleteIndividualTeam =
      "$baseUrl?action=delete_individual_team";

  static const String editIndividualTeamAmount =
      "$baseUrl?action=edit_individual_team";

  static const String editIndividualTargetAmount =
      "$baseUrl?action=individual_target_update";

  static const String showIndividualTeam =
      "$baseUrl?action=show_individual_team";

  static const String addBranch = "$baseUrl?action=add_branch";

  static const String showBranch = "$baseUrl?action=show_branch";

  static const String updateBranch = "$baseUrl?action=edit_branch";

  static const String deleteBranch = "$baseUrl?action=delete_branch";

  static const String showTeamByBranch = "$baseUrl?action=show_branch_team";

  static const String showTeamGraph = "$baseUrl?action=show_team_graph";

  static const String copyTeam = "$baseUrl?action=copy_team";

  static const String showAnalytics = "$baseUrl?action=show_analytics";

  static const String lockTargetAmount = "$baseUrl?action=lock_target_amount";

  static const String deleteSubTeam = "$baseUrl?action=delete_subteam";
  
  static const String languageFilter = "$baseUrl?action=language_list";

  //todo:********************************************************************

  static const String newBaseUrl =
      'https://ruparnatechnology.com/Smartleader/Api';

  static const String addNewEvent = "$newBaseUrl/add_connection_event.php";

  static const String  getNewEvent = "$newBaseUrl/show_connection_event.php";
  static const String get_video_names = "https://ruparnatechnology.com/Smartleader/Api/process.php?action=get_video_names";

  static const String deleteNewEvent =
      "$newBaseUrl/delete_connection_event.php";

  static const String updateNewEvent =
      "$newBaseUrl/update_connection_event.php";
}
