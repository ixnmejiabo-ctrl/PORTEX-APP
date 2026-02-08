import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portex/core/services/local_sync_client.dart';
import 'package:portex/core/database/database.dart';
import 'package:portex/core/models/sync_result.dart';
import 'package:portex/core/theme/design_tokens.dart';
import 'package:portex/core/widgets/glass_container.dart';

/// Widget para sincronizar con servidor local (Mobile only)
class SyncClientSection extends StatefulWidget {
  final AppDatabase db;

  const SyncClientSection({super.key, required this.db});

  @override
  State<SyncClientSection> createState() => _SyncClientSectionState();
}

class _SyncClientSectionState extends State<SyncClientSection> {
  final _serverIpController = TextEditingController();
  final _authTokenController = TextEditingController();

  LocalSyncClient? _syncClient;
  bool _isSyncing = false;
  bool _isConnected = false;
  SyncResult? _lastSyncResult;
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  @override
  void dispose() {
    _serverIpController.dispose();
    _authTokenController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final metadata = await widget.db.getSyncMetadata();
    if (metadata != null && metadata.serverIp != null) {
      setState(() {
        _serverIpController.text = metadata.serverIp!;
        _lastSyncTime = metadata.lastSyncAt;
      });
    }
  }

  Future<void> _checkConnection() async {
    if (_serverIpController.text.isEmpty) {
      _showError('Por favor ingresa la IP del servidor');
      return;
    }

    setState(() => _isSyncing = true);

    _syncClient = LocalSyncClient(
      widget.db,
      serverIp: _serverIpController.text.trim(),
      authToken: _authTokenController.text.trim().isEmpty
          ? null
          : _authTokenController.text.trim(),
    );

    final connected = await _syncClient!.checkConnection();

    setState(() {
      _isConnected = connected;
      _isSyncing = false;
    });

    if (connected) {
      _showSuccess('✅ Conexión exitosa con el servidor');
    } else {
      _showError(
        '❌ No se pudo conectar. Verifica la IP y que el servidor esté activo',
      );
    }
  }

  Future<void> _syncData() async {
    if (!_isConnected) {
      _showError('Primero verifica la conexión');
      return;
    }

    if (_authTokenController.text.trim().isEmpty) {
      _showError('Se requiere el token de autenticación');
      return;
    }

    setState(() => _isSyncing = true);

    try {
      final result = await _syncClient!.syncAll();

      setState(() {
        _lastSyncResult = result;
        _lastSyncTime = result.timestamp;
        _isSyncing = false;
      });

      if (result.isSuccess) {
        _showSuccess(
          '✅ Sincronización completa\n'
          '📤 Enviados: ${result.totalPushed}\n'
          '📥 Recibidos: ${result.totalPulled}',
        );
      } else {
        _showError(
          '⚠️ Sincronización con errores:\n'
          '${result.errors.join('\n')}',
        );
      }
    } catch (e) {
      setState(() => _isSyncing = false);
      _showError('Error durante la sincronización: $e');
    }
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DesignTokens.safeGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: DesignTokens.urgentRed,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _pasteFromClipboard(TextEditingController controller) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        controller.text = data.text!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Solo mostrar en Mobile (no Web, no Desktop)
    if (kIsWeb || Platform.isWindows) {
      return const SizedBox.shrink();
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.sync_rounded,
                color: _isConnected
                    ? DesignTokens.safeGreen
                    : DesignTokens.cyanNeon,
                size: 28,
              ),
              const SizedBox(width: DesignTokens.space12),
              Expanded(
                child: Text(
                  'Sincronización Local',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space16),

          // Descripción
          Text(
            'Sincroniza tus datos con el servidor local en la misma red Wi-Fi',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Campo de IP
          _buildTextField(
            controller: _serverIpController,
            label: 'IP del Servidor',
            hint: 'Ej: 192.168.1.100',
            icon: Icons.wifi_rounded,
            isDark: isDark,
            onPaste: () => _pasteFromClipboard(_serverIpController),
          ),

          const SizedBox(height: DesignTokens.space16),

          // Campo de Token
          _buildTextField(
            controller: _authTokenController,
            label: 'Token de Autenticación',
            hint: 'Token del servidor',
            icon: Icons.key_rounded,
            isDark: isDark,
            obscure: true,
            onPaste: () => _pasteFromClipboard(_authTokenController),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Estado de conexión
          if (_isConnected)
            Container(
              padding: const EdgeInsets.all(DesignTokens.space12),
              decoration: BoxDecoration(
                color: DesignTokens.safeGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: DesignTokens.safeGreen.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: DesignTokens.safeGreen,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.space8),
                  Expanded(
                    child: Text(
                      'Conectado al servidor',
                      style: TextStyle(
                        color: DesignTokens.safeGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: DesignTokens.fontSize14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_isConnected) const SizedBox(height: DesignTokens.space16),

          // Última sincronización
          if (_lastSyncTime != null) ...[
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                ),
                const SizedBox(width: DesignTokens.space8),
                Text(
                  'Última sincronización: ${_formatDateTime(_lastSyncTime!)}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignTokens.space16),
          ],

          // Resultado de última sincronización
          if (_lastSyncResult != null) ...[
            _buildSyncResultInfo(_lastSyncResult!, isDark),
            const SizedBox(height: DesignTokens.space16),
          ],

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSyncing ? null : _checkConnection,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DesignTokens.cyanNeon,
                    side: BorderSide(color: DesignTokens.cyanNeon, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: _isSyncing && !_isConnected
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              DesignTokens.cyanNeon,
                            ),
                          ),
                        )
                      : Icon(Icons.link_rounded),
                  label: Text('Verificar'),
                ),
              ),
              const SizedBox(width: DesignTokens.space12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isSyncing ? null : _syncData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignTokens.purpleNeon,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: _isSyncing && _isConnected
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Icon(Icons.sync_rounded),
                  label: Text(
                    _isSyncing ? 'Sincronizando...' : 'Sincronizar',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space16),

          // Instrucciones
          Container(
            padding: const EdgeInsets.all(DesignTokens.space12),
            decoration: BoxDecoration(
              color: DesignTokens.cyanNeon.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: DesignTokens.cyanNeon.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: DesignTokens.cyanNeon,
                    ),
                    const SizedBox(width: DesignTokens.space8),
                    Text(
                      'Instrucciones',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: DesignTokens.cyanNeon,
                        fontSize: DesignTokens.fontSize14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.space8),
                Text(
                  '1. Inicia el servidor en tu PC Desktop\n'
                  '2. Copia la IP y Token que aparecen\n'
                  '3. Pégalos aquí y verifica la conexión\n'
                  '4. Presiona Sincronizar para transferir datos',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize12,
                    color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool obscure = false,
    VoidCallback? onPaste,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: DesignTokens.fontSize14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF111827),
          ),
        ),
        const SizedBox(height: DesignTokens.space8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: isDark ? Colors.white : Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? DesignTokens.meteorGray.withValues(alpha: 0.5)
                  : Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(icon, color: DesignTokens.cyanNeon, size: 20),
            suffixIcon: onPaste != null
                ? IconButton(
                    icon: Icon(
                      Icons.content_paste_rounded,
                      color: DesignTokens.cyanNeon,
                      size: 20,
                    ),
                    onPressed: onPaste,
                  )
                : null,
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: DesignTokens.cyanNeon, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncResultInfo(SyncResult result, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space12),
      decoration: BoxDecoration(
        color: result.isSuccess
            ? DesignTokens.safeGreen.withValues(alpha: 0.1)
            : DesignTokens.warningYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: result.isSuccess
              ? DesignTokens.safeGreen.withValues(alpha: 0.3)
              : DesignTokens.warningYellow.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isSuccess
                    ? Icons.check_circle_rounded
                    : Icons.warning_rounded,
                color: result.isSuccess
                    ? DesignTokens.safeGreen
                    : DesignTokens.warningYellow,
                size: 18,
              ),
              const SizedBox(width: DesignTokens.space8),
              Text(
                'Último resultado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: DesignTokens.fontSize14,
                  color: result.isSuccess
                      ? DesignTokens.safeGreen
                      : DesignTokens.warningYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            '📤 Enviados: ${result.totalPushed} | 📥 Recibidos: ${result.totalPulled}',
            style: TextStyle(
              fontSize: DesignTokens.fontSize12,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) {
      return 'Hace un momento';
    } else if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} hrs';
    } else {
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }
}
