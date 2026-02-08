import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portex/core/services/local_sync_server.dart';
import 'package:portex/core/database/database.dart';
import 'package:portex/core/theme/design_tokens.dart';
import 'package:portex/core/widgets/glass_container.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Widget para controlar el servidor de sincronización local (Desktop only)
class SyncServerSection extends StatefulWidget {
  final AppDatabase db;

  const SyncServerSection({super.key, required this.db});

  @override
  State<SyncServerSection> createState() => _SyncServerSectionState();
}

class _SyncServerSectionState extends State<SyncServerSection> {
  LocalSyncServer? _syncServer;
  bool _isRunning = false;
  String? _serverIp;
  String? _authToken;
  bool _isLoading = false;

  @override
  void dispose() {
    _stopServer();
    super.dispose();
  }

  Future<void> _startServer() async {
    setState(() => _isLoading = true);

    try {
      // Crear servidor
      _syncServer = LocalSyncServer(widget.db);
      await _syncServer!.start();

      // Obtener IP local
      _serverIp = await _getLocalIp();
      _authToken = _syncServer!.authToken;

      setState(() {
        _isRunning = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🚀 Servidor iniciado correctamente'),
            backgroundColor: DesignTokens.safeGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al iniciar servidor: $e'),
            backgroundColor: DesignTokens.urgentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _stopServer() async {
    if (_syncServer != null) {
      await _syncServer!.stop();
      setState(() {
        _isRunning = false;
        _serverIp = null;
        _authToken = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⛔ Servidor detenido'),
            backgroundColor: DesignTokens.warningYellow,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<String?> _getLocalIp() async {
    try {
      final info = NetworkInfo();
      return await info.getWifiIP();
    } catch (e) {
      debugPrint('Error getting IP: $e');
      return null;
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📋 Copiado al portapapeles'),
          backgroundColor: DesignTokens.cyanNeon,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Solo mostrar en Desktop (no Web, no Mobile)
    if (kIsWeb || !Platform.isWindows) {
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
                color: _isRunning
                    ? DesignTokens.safeGreen
                    : DesignTokens.cyanNeon,
                size: 28,
              ),
              const SizedBox(width: DesignTokens.space12),
              Expanded(
                child: Text(
                  'Servidor de Sincronización Local',
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
            'Permite sincronizar datos con dispositivos móviles en la misma red Wi-Fi',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Estado del servidor
          if (_isRunning) ...[
            _buildServerInfo(isDark),
            const SizedBox(height: DesignTokens.space24),
          ],

          // Botón de control
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _isRunning ? _stopServer() : _startServer(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRunning
                    ? DesignTokens.urgentRed.withValues(alpha: 0.2)
                    : DesignTokens.cyanNeon.withValues(alpha: 0.2),
                foregroundColor: _isRunning
                    ? DesignTokens.urgentRed
                    : DesignTokens.cyanNeon,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _isRunning
                        ? DesignTokens.urgentRed
                        : DesignTokens.cyanNeon,
                    width: 1,
                  ),
                ),
              ),
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          _isRunning
                              ? DesignTokens.urgentRed
                              : DesignTokens.cyanNeon,
                        ),
                      ),
                    )
                  : Icon(
                      _isRunning
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                    ),
              label: Text(
                _isLoading
                    ? 'Cargando...'
                    : _isRunning
                    ? 'Detener Servidor'
                    : 'Iniciar Servidor',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        color: DesignTokens.safeGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesignTokens.safeGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator de activo
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: DesignTokens.safeGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.safeGreen.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.space8),
              Text(
                'Servidor Activo',
                style: TextStyle(
                  fontSize: DesignTokens.fontSize16,
                  fontWeight: FontWeight.bold,
                  color: DesignTokens.safeGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.space16),

          // IP Address
          _buildInfoRow(
            'Dirección IP',
            _serverIp ?? 'Obteniendo...',
            Icons.wifi_rounded,
            isDark,
            onTap: _serverIp != null
                ? () => _copyToClipboard('http://$_serverIp:8080')
                : null,
          ),

          const SizedBox(height: DesignTokens.space12),

          // Puerto
          _buildInfoRow(
            'Puerto',
            '8080',
            Icons.settings_ethernet_rounded,
            isDark,
          ),

          const SizedBox(height: DesignTokens.space12),

          // Auth Token
          _buildInfoRow(
            'Token de Autenticación',
            _authToken != null ? '${_authToken!.substring(0, 20)}...' : 'N/A',
            Icons.key_rounded,
            isDark,
            onTap: _authToken != null
                ? () => _copyToClipboard(_authToken!)
                : null,
          ),

          const SizedBox(height: DesignTokens.space16),

          // URL completa
          Container(
            padding: const EdgeInsets.all(DesignTokens.space12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.link_rounded,
                  color: DesignTokens.cyanNeon,
                  size: 20,
                ),
                const SizedBox(width: DesignTokens.space8),
                Expanded(
                  child: Text(
                    _serverIp != null
                        ? 'http://$_serverIp:8080'
                        : 'Cargando...',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Color(0xFF111827),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.space12),

          // Instrucciones
          Text(
            '💡 Ingresa esta IP en tu dispositivo móvil para sincronizar',
            style: TextStyle(
              fontSize: DesignTokens.fontSize12,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: DesignTokens.cyanNeon),
            const SizedBox(width: DesignTokens.space8),
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: DesignTokens.fontSize14,
                color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: DesignTokens.fontSize14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
              ),
          ],
        ),
      ),
    );
  }
}
