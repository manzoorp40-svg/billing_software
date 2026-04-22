import 'dart:math';
import 'dart:typed_data';

/// Generates MongoDB ObjectId-compatible 24-character hexadecimal strings.
/// Format: 12 bytes = 24 hex chars
/// Structure: [4 bytes timestamp][3 bytes machine][2 bytes pid][3 bytes counter]
class IdGenerator {
  static final Random _secureRandom = Random.secure();
  static int _counter = 0;
  static final int _machineId = _generateMachineId();

  /// Generate a new 24-character hex ID
  static String generate() {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final machine = _machineId;
    final pid = PidGenerator.getPid;
    final counter = _getNextCounter();

    // Pack into 12 bytes
    final buffer = ByteData(12);
    buffer.setInt32(0, timestamp, Endian.big); // 4 bytes
    buffer.setUint8(4, (machine >> 16) & 0xFF); // 1 byte
    buffer.setUint8(5, (machine >> 8) & 0xFF);  // 1 byte
    buffer.setUint8(6, machine & 0xFF);          // 1 byte
    buffer.setUint16(7, pid, Endian.big);       // 2 bytes
    buffer.setUint8(9, (counter >> 16) & 0xFF); // 1 byte
    buffer.setUint8(10, (counter >> 8) & 0xFF); // 1 byte
    buffer.setUint8(11, counter & 0xFF);        // 1 byte

    return _bytesToHex(buffer.buffer.asUint8List());
  }

  /// Convert bytes to lowercase hex string
  static String _bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toLowerCase();
  }

  /// Generate a machine ID from network interfaces (simplified)
  static int _generateMachineId() {
    // Use random for simplicity - can be enhanced with actual network interface
    return (_secureRandom.nextInt(0xFFFFFF));
  }

  /// Get next counter value (cycles every 16M)
  static int _getNextCounter() {
    _counter = (_counter + 1) & 0xFFFFFF;
    return _counter;
  }

  /// Generate multiple IDs
  static List<String> generateMany(int count) {
    return List.generate(count, (_) => generate());
  }

  /// Validate if a string is a valid 24-char hex ID
  static bool isValid(String id) {
    if (id.length != 24) return false;
    return RegExp(r'^[0-9a-f]{24}$').hasMatch(id.toLowerCase());
  }

  /// Get timestamp from ID
  static DateTime? getTimestampFromId(String id) {
    if (!isValid(id)) return null;
    final timestampHex = id.substring(0, 8);
    final timestamp = int.parse(timestampHex, radix: 16);
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
  }

  /// Check if ID is older than given duration
  static bool isOlderThan(String id, Duration duration) {
    final timestamp = getTimestampFromId(id);
    if (timestamp == null) return false;
    return DateTime.now().toUtc().difference(timestamp) > duration;
  }
}

/// PID generator (simplified for cross-platform)
class PidGenerator {
  static int _cachedPid = 0;
  static bool _initialized = false;

  static int get getPid {
    if (!_initialized) {
      _initialized = true;
      // Use a random value as fallback - in production would use ProcessInfo
      _cachedPid = DateTime.now().millisecondsSinceEpoch & 0xFFFF;
    }
    return _cachedPid;
  }
}