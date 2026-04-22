import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/providers/database_provider.dart';

class BackupService extends GetxService {
  late final DatabaseProvider _db;

  final isBackingUp = false.obs;
  final lastBackupTime = 0.obs;

  Future<BackupService> init() async {
    _db = Get.find<DatabaseProvider>();
    return this;
  }

  /// Create a backup of the database
  Future<String?> createBackup() async {
    if (isBackingUp.value) return null;

    isBackingUp.value = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${appDir.path}/construction_billing/backups');

      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Generate backup filename with timestamp
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');

      // In a real implementation, you would:
      // 1. Close the ObjectBox store
      // 2. Zip the entire data directory
      // 3. Reopen the store

      // For ObjectBox, the data is stored in a specific location
      final dataDir = Directory('${appDir.path}/construction_billing/data');

      if (await dataDir.exists()) {
        // Create backup by copying files
        final files = await dataDir.list().toList();
        final backupPath = '${backupDir.path}/backup_$timestamp';

        for (final entity in files) {
          if (entity is File) {
            final fileName = entity.path.split(Platform.pathSeparator).last;
            await entity.copy('$backupPath/$fileName');
          }
        }

        lastBackupTime.value = DateTime.now().toUtc().millisecondsSinceEpoch;

        return backupPath;
      }

      return null;
    } catch (e) {
      return null;
    } finally {
      isBackingUp.value = false;
    }
  }

  /// Restore from a backup
  Future<bool> restoreBackup(String backupPath) async {
    if (isBackingUp.value) return false;

    isBackingUp.value = true;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dataDir = Directory('${appDir.path}/construction_billing/data');
      final backupDir = Directory(backupPath);

      if (!await backupDir.exists()) return false;

      // Close current store
      _db.store.close();

      // Copy backup files to data directory
      final backupFiles = await backupDir.list().toList();

      if (!await dataDir.exists()) {
        await dataDir.create(recursive: true);
      }

      for (final entity in backupFiles) {
        if (entity is File) {
          final fileName = entity.path.split(Platform.pathSeparator).last;
          await entity.copy('${dataDir.path}/$fileName');
        }
      }

      // Reinitialize store (would need app restart in real scenario)
      return true;
    } catch (e) {
      return false;
    } finally {
      isBackingUp.value = false;
    }
  }

  /// List available backups
  Future<List<Map<String, dynamic>>> listBackups() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/construction_billing/backups');

    if (!await backupDir.exists()) return [];

    final backups = <Map<String, dynamic>>[];
    final files = await backupDir.list().toList();

    for (final entity in files) {
      if (entity is Directory) {
        final name = entity.path.split(Platform.pathSeparator).last;
        final stat = await entity.stat();

        backups.add({
          'name': name,
          'path': entity.path,
          'date': stat.modified.millisecondsSinceEpoch,
          'size': await _getDirectorySize(entity),
        });
      }
    }

    // Sort by date, newest first
    backups.sort((a, b) => (b['date'] as int).compareTo(a['date'] as int));

    return backups;
  }

  /// Delete a backup
  Future<bool> deleteBackup(String backupPath) async {
    try {
      final dir = Directory(backupPath);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getDirectorySize(Directory dir) async {
    int size = 0;
    final files = dir.list(recursive: true);
    await for (final file in files) {
      if (file is File) {
        size += await file.length();
      }
    }
    return size;
  }
}