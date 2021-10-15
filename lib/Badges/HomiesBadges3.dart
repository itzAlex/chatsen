import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:chatsen_resources/data.dart' as resources;
import 'package:chatsen_resources/user.dart' as resources;
import 'package:chatsen_resources/badge.dart' as resources;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

class HomiesBadges3 extends Cubit<Map<String, List<twitch.Badge>>> {
  HomiesBadges3() : super({}) {
    refresh();
  }

  void refresh() async {
    var response = await http.get(Uri.parse('https://chatterinohomies.com/api/badges/list'));
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    var users = <String, List<twitch.Badge>>{};
    for (var badgeData in jsonResponse['badges']) {
      if (users[badgeData['userId']] == null) users[badgeData['userId']] = <twitch.Badge>[];
      users[badgeData['userId']]!.add(
        twitch.Badge(
          title: badgeData['tooltip'],
          description: null,
          id: base64Encode(badgeData['tooltip'].codeUnits),
          mipmap: [
            badgeData['image1'],
            badgeData['image2'],
            badgeData['image3'],
          ],
          name: base64Encode(badgeData['tooltip'].codeUnits),
          tag: base64Encode(badgeData['tooltip'].codeUnits),
        ),
      );
    }

    emit(users);
  }

  List<twitch.Badge> getBadgesForUser(String id) {
    if (state.containsKey(id)) return state[id]!;
    return [];
  }
}
