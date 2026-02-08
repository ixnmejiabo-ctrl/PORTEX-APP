/// Modelo de resultado de sincronización
class SyncResult {
  final int actividadesPushed;
  final int actividadesPulled;
  final int clientesPushed;
  final int clientesPulled;
  final int serviciosPushed;
  final int serviciosPulled;
  final DateTime timestamp;
  final List<String> errors;

  SyncResult({
    this.actividadesPushed = 0,
    this.actividadesPulled = 0,
    this.clientesPushed = 0,
    this.clientesPulled = 0,
    this.serviciosPushed = 0,
    this.serviciosPulled = 0,
    DateTime? timestamp,
    this.errors = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  int get totalPushed => actividadesPushed + clientesPushed + serviciosPushed;
  int get totalPulled => actividadesPulled + clientesPulled + serviciosPulled;
  int get totalSynced => totalPushed + totalPulled;
  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => !hasErrors;

  @override
  String toString() {
    return 'SyncResult(↑$totalPushed ↓$totalPulled ${hasErrors ? "⚠️" : "✓"})';
  }
}
