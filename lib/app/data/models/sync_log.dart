import 'package:objectbox/objectbox.dart';

@Entity()
class SyncLog {
  @Id()
  int localId;

  String remoteId;
  bool isSync;

  @Index()
  int syncDate; // UTC timestamp

  int entitiesPushed;
  int entitiesPulled;
  int conflicts;
  int errors;

  String? errorMessage;
  int duration; // milliseconds

  int createdAt;
  int updatedAt;
  int? syncedAt;

  SyncLog({
    this.localId = 0,
    required this.remoteId,
    this.isSync = true, // Sync logs don't need syncing
    required this.syncDate,
    required this.entitiesPushed,
    required this.entitiesPulled,
    this.conflicts = 0,
    this.errors = 0,
    this.errorMessage,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });
}