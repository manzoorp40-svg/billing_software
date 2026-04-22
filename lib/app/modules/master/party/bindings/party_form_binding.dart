import 'package:get/get.dart';

import '../../../../data/models/party.dart';
import '../controllers/party_form_controller.dart';


class PartyFormBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    Party? party;
    if (args is Party) {
      party = args;
    }
    Get.lazyPut<PartyFormController>(() => PartyFormController(editingParty: party));
  }
}