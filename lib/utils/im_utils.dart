import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
// import 'package:video_compress/video_compress.dart';

class CustomMessageType {
  static const callingInvite = 200;
  static const callingAccept = 201;
  static const callingReject = 202;
  static const callingCancel = 203;
  static const callingHungup = 204;

  static const call = 901;
  static const emoji = 902;
  static const tag = 903;
  static const moments = 904;
  static const meeting = 905;
  static const blockedByFriend = 910;
  static const deletedByFriend = 911;
  static const removedFromGroup = 912;
  static const groupDisbanded = 913;
}

class IMUtils {
  IMUtils._();

  static final passwordRegExp = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,20}$',
  );
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  static String? emptyStrToNull(String? str) =>
      (null != str && str.trim().isEmpty) ? null : str;

  static int getPlatform() {
    final context = Get.context;

    if (context == null) {
      return 2;
    }

    if (Platform.isAndroid) {
      return context.isTablet ? 8 : 2;
    } else {
      return context.isTablet ? 9 : 1;
    }
  }



  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static String getGroupMemberShowName(GroupMembersInfo membersInfo) {
    return membersInfo.userID == OpenIM.iMManager.userID
        ? "you"
        : membersInfo.nickname!;
  }

  static String? parseNtf(
    Message message, {
    bool isConversation = false,
  }) {
    String? text;
    try {
      if (message.contentType! >= 1000) {
        final elem = message.notificationElem!;
        final map = json.decode(elem.detail!);
        switch (message.contentType) {
          case MessageType.groupCreatedNotification:
            {
              final ntf = GroupNotification.fromJson(map);

              const label = "createGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupInfoSetNotification:
            {
              final ntf = GroupNotification.fromJson(map);
              if (ntf.group?.notification != null &&
                  ntf.group!.notification!.isNotEmpty) {
                return isConversation ? ntf.group!.notification! : null;
              }

              const label = "editGroupInfoNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberQuitNotification:
            {
              final ntf = QuitGroupNotification.fromJson(map);

              const label = "quitGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.quitUser!)]);
            }
            break;
          case MessageType.memberInvitedNotification:
            {
              final ntf = InvitedJoinGroupNotification.fromJson(map);

              const label = "invitedJoinGroupNtf";
              final b = ntf.invitedUserList
                  ?.map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(
                  label, [getGroupMemberShowName(ntf.opUser!), b ?? '']);
            }
            break;
          case MessageType.memberKickedNotification:
            {
              final ntf = KickedGroupMemeberNotification.fromJson(map);

              const label = "kickedGroupNtf";
              final b = ntf.kickedUserList!
                  .map((e) => getGroupMemberShowName(e))
                  .toList()
                  .join('、');
              text = sprintf(label, [b, getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.memberEnterNotification:
            {
              final ntf = EnterGroupNotification.fromJson(map);

              const label = "joinGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.entrantUser!)]);
            }
            break;
          case MessageType.dismissGroupNotification:
            {
              final ntf = GroupNotification.fromJson(map);

              const label = "dismissGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupOwnerTransferredNotification:
            {
              final ntf = GroupRightsTransferNoticication.fromJson(map);

              const label = "transferredGroupNtf";
              text = sprintf(label, [
                getGroupMemberShowName(ntf.opUser!),
                getGroupMemberShowName(ntf.newGroupOwner!)
              ]);
            }
            break;
          case MessageType.groupMemberMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              const label = "muteMemberNtf";
              // final c = ntf.mutedSeconds;
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!),
                // mutedTime(c!)
              ]);
            }
            break;
          case MessageType.groupMemberCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              const label = "muteCancelMemberNtf";
              text = sprintf(label, [
                getGroupMemberShowName(ntf.mutedUser!),
                getGroupMemberShowName(ntf.opUser!)
              ]);
            }
            break;
          case MessageType.groupMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              const label = "muteGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.groupCancelMutedNotification:
            {
              final ntf = MuteMemberNotification.fromJson(map);

              const label = "muteCancelGroupNtf";
              text = sprintf(label, [getGroupMemberShowName(ntf.opUser!)]);
            }
            break;
          case MessageType.friendApplicationApprovedNotification:
            {
              text = "friendAddedNtf";
            }
            break;
          case MessageType.burnAfterReadingNotification:
            {
              final ntf = BurnAfterReadingNotification.fromJson(map);
              if (ntf.isPrivate == true) {
                text = "openPrivateChatNtf";
              } else {
                text = "closePrivateChatNtf";
              }
            }
            break;
          case MessageType.groupMemberInfoChangedNotification:
            final ntf = GroupMemberInfoChangedNotification.fromJson(map);
            text = sprintf(
                "memberInfoChangedNtf", [getGroupMemberShowName(ntf.opUser!)]);
            break;
          case MessageType.groupInfoSetAnnouncementNotification:
            if (isConversation) {
              final ntf = GroupNotification.fromJson(map);
              text = ntf.group?.notification ?? '';
            }
            break;
          case MessageType.groupInfoSetNameNotification:
            final ntf = GroupNotification.fromJson(map);
            text = sprintf(
                "whoModifyGroupName", [getGroupMemberShowName(ntf.opUser!)]);
            break;
        }
      }
    } catch (e, s) {
      debugPrint('Exception details:\n $e');
      debugPrint('Stack trace:\n $s');
    }
    return text;
  }

  static String parseMsg(
    Message message, {
    bool isConversation = false,
    bool replaceIdToNickname = false,
  }) {
    String? content;
    try {
      switch (message.contentType) {
        case MessageType.text:
          content = message.textElem!.content!;
          break;
        case MessageType.atText:
          content = message.atTextElem!.text!;
          if (replaceIdToNickname) {
            var list = message.atTextElem?.atUsersInfo;
            list?.forEach((e) {
              content = content?.replaceAll(
                '@${e.atUserID}',
                '@${getAtNickname(e.atUserID!, e.groupNickname!)}',
              );
            });
          }
          break;
        case MessageType.picture:
          content = 'Ảnh';
          break;
        case MessageType.voice:
          content = 'Âm thanh';
          break;
        case MessageType.video:
          content = 'Video';
          break;
        case MessageType.file:
          content = 'Tệp';
          break;
        case MessageType.location:
          content = 'Vị trí';
          break;
        case MessageType.merger:
          content = 'Chat record';
          break;
        case MessageType.card:
          content = 'Thẻ';
          break;
        case MessageType.quote:
          content = message.quoteElem?.text ?? '';
          break;
        case MessageType.revokeMessageNotification:
          var isSelf = message.sendID == OpenIM.iMManager.userID;
          var map = json.decode(message.notificationElem!.detail!);
          var info = RevokedInfo.fromJson(map);
          if (message.isSingleChat) {
            if (isSelf) {
              content = '${"you"} ${"revokeMsg"}';
            } else {
              content = '${message.senderNickname} ${"revokeMsg"}';
            }
          } else {
            if (info.revokerID == info.sourceMessageSendID) {
              if (isSelf) {
                content = '${"you"} ${"revokeMsg"}';
              } else {
                content = '${message.senderNickname} ${"revokeMsg"}';
              }
            } else {
              late String revoker;
              late String sender;
              if (info.revokerID == OpenIM.iMManager.userID) {
                revoker = "you";
              } else {
                revoker = info.revokerNickname!;
              }
              if (info.sourceMessageSendID == OpenIM.iMManager.userID) {
                sender = "you";
              } else {
                sender = info.sourceMessageSenderNickname!;
              }

              content = sprintf("aRevokeBMsg", [revoker, sender]);
            }
          }
          break;
        case MessageType.customFace:
          content = '[${"emoji"}]';
          break;
        case MessageType.custom:
          var data = message.customElem!.data;
          var map = json.decode(data!);
          var customType = map['customType'];
          var customData = map['data'];
          switch (customType) {
            case CustomMessageType.callingAccept:
            case CustomMessageType.callingHungup:
            case CustomMessageType.callingCancel:
            case CustomMessageType.callingReject:
              var type = map['data']['mediaType'];
              content = '[${type == 'video' ? "callVideo" : "callVoice"}]';
              break;
            case CustomMessageType.call:
              var type = map['data']['type'];
              content = '[${type == 'video' ? "callVideo" : "callVoice"}]';
              break;
            case CustomMessageType.emoji:
              content = '[${"emoji"}]';
              break;
            case CustomMessageType.tag:
              if (null != customData['textElem']) {
                final textElem = TextElem.fromJson(customData['textElem']);
                content = textElem.content;
              } else if (null != customData['soundElem']) {
                content = '[${"voice"}]';
              } else {
                content = '[${"unsupportedMessage"}]';
              }
              break;
            case CustomMessageType.meeting:
              content = '[${"meetingMessage"}]';
              break;
            case CustomMessageType.blockedByFriend:
              content = "blockedByFriendHint";
              break;
            case CustomMessageType.deletedByFriend:
              content = sprintf(
                "deletedByFriendHint",
                [''],
              );
              break;
            case CustomMessageType.removedFromGroup:
              content = "removedFromGroupHint";
              break;
            case CustomMessageType.groupDisbanded:
              content = "groupDisbanded";
              break;
            default:
              content = '[${"unsupportedMessage"}]';
              break;
          }
          break;
        case MessageType.oaNotification:
          String detail = message.notificationElem!.detail!;
          var oa = OANotification.fromJson(json.decode(detail));
          content = oa.text!;
          break;
        default:
          content = '[${"unsupportedMessage"}]';
          break;
      }
    } catch (e, s) {
      debugPrint('Exception details:\n $e');
      debugPrint('Stack trace:\n $s');
    }
    content = content?.replaceAll("\n", " ");
    return content ?? '[${"unsupportedMessage"}]';
  }

  static String getAtNickname(String atUserID, String atNickname) {
    return atUserID == 'atAllTag' ? "everyone" : atNickname;
  }

  static Future<File?> compressImageAndGetFile(File file) async {
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/") + 1);
    var targetPath = await createTempFile(name: name, dir: 'pic');
    if (name.endsWith('.gif')) {
      return file;
    }

    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 480,
      minHeight: 800,
      format: format,
    );
    return result != null ? File(result.path) : file;
  }

  static Future<String> createTempFile({
    required String dir,
    required String name,
  }) async {
    final storage = await createTempDir(dir: dir);
    File file = File('$storage/$name');
    if (!(await file.exists())) {
      file.create();
    }
    return file.path;
  }

  static Future<String> createTempDir({
    required String dir,
  }) async {
    final storage = (Platform.isIOS
        ? await getApplicationCacheDirectory()
        : await getExternalStorageDirectory());
    Directory directory = Directory('${storage!.path}/$dir');
    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    return directory.path;
  }

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static bool checkPhone(String phoneNumber) {
    //check valid phone number here
    // final regex = RegExp(r'^(0[3|5|7|8|9])+([0-9]{8,9})$');
    // return regex.hasMatch(phoneNumber);
    return true;
  }
  static bool checkLoginId(String loginId) {

    //validate username here
    // return RegExp(r'^.{6,}$').hasMatch(loginId) && RegExp(r'[0-9]').hasMatch(loginId);
    return true;
  }
  static bool isSvg(String url) {
    return url.toLowerCase().endsWith(".svg");
  }
  static bool isMobile() => MediaQuery.of(Get.context!).size.shortestSide < 600;



  static Future<List<String>?> openCamera() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // final result = MultipartFile(photo.path, filename: photo.path.split('/').last);
      final result = File(photo.path);
      return [result.path];
    } else {
      return null;
    }


  }
  static Future<List<String>?> pickImageFromLibrary() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return [pickedFile.path];
    }

    return null;
  }


  // static Future<File> getVideoThumbnail(File file) async {
  //   final thumbnailFile = await VideoCompress.getFileThumbnail(
  //     file.path,
  //     quality: 20,
  //     position: 1,
  //   );
  //   return thumbnailFile;
  // }

  // static Future<File?> compressVideoAndGetFile(File file) async {
  //   var mediaInfo = await VideoCompress.compressVideo(
  //     file.path,
  //     quality: VideoQuality.DefaultQuality,
  //     deleteOrigin: false,
  //   );
  //   return mediaInfo?.file;
  // }
}
