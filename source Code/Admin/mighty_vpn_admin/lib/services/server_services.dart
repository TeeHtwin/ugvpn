import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/serverModel.dart';
import 'package:mighty_vpn_admin/services/base_service.dart';
import 'package:mighty_vpn_admin/services/keys.dart';

class ServerService extends BaseService<ServerModel> {
  ServerService() {
    ref = fireStore.collection(collections.server).withConverter<ServerModel>(
          fromFirestore: (snapshot, options) => ServerModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  Stream<List<ServerModel>> getServerList() {
    return ref!.snapshots().map((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<DocumentReference> addServiceDocument(ServerModel data) async {
    var doc = await ref!.add(data);
    doc.update({commonKeys.uid: doc.id});
    return doc;
  }
}
