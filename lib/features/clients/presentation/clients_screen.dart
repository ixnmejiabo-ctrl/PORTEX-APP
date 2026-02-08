import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/database/database.dart';
import '../../../core/utils/date_helpers.dart';
import 'widgets/client_form_modal.dart';

/// Pantalla de Clientes con KPIs, búsqueda y lista completa
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];

  int totalClientes = 0;
  int clientesActivos = 0;
  int proximosVencer = 0; // Clientes con servicios por vencer en 7 días

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final clientes = await db.obtenerTodosLosClientes();

    setState(() {
      _clientes = clientes;
      _clientesFiltrados = clientes;
      totalClientes = clientes.length;
      clientesActivos = clientes.length; // Todos son activos por ahora

      // Calcular clientes próximos a vencer (7 días)
      proximosVencer = clientes.where((c) {
        final diasRestantes = DateHelpers.daysUntil(c.fechaEntrega);
        return diasRestantes >= 0 && diasRestantes <= 7;
      }).length;
    });
  }

  void _aplicarFiltros() {
    setState(() {
      _clientesFiltrados = _clientes.where((cliente) {
        if (_searchController.text.isEmpty) return true;

        final searchTerm = _searchController.text.toLowerCase();
        return cliente.empresa.toLowerCase().contains(searchTerm) ||
            cliente.nombreGerente.toLowerCase().contains(searchTerm) ||
            cliente.servicio.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          _buildHeader(
            isDark,
          ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),

          const SizedBox(height: DesignTokens.space24),

          // KPIs
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? DesignTokens.space12
                  : DesignTokens.space24,
            ),
            child: _buildKPIsRow(
              isDark,
            ).animate().fadeIn(delay: 50.ms, duration: 200.ms),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Buscador
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? DesignTokens.space12
                  : DesignTokens.space24,
            ),
            child: _buildSearchBar(
              isDark,
            ).animate().fadeIn(delay: 100.ms, duration: 200.ms),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Lista de clientes
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? DesignTokens.space12
                    : DesignTokens.space24,
              ),
              child: _clientesFiltrados.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildClientsList(
                      isDark,
                    ).animate().fadeIn(delay: 150.ms, duration: 200.ms),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isDark),
    );
  }

  Future<void> _mostrarModal({Cliente? cliente}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ClientFormModal(cliente: cliente),
    );

    if (result == true) {
      _loadClientes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              cliente == null
                  ? 'Cliente creado exitosamente'
                  : 'Cliente actualizado exitosamente',
            ),
            backgroundColor: DesignTokens.safeGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildHeader(bool isDark) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? DesignTokens.space12 : DesignTokens.space24,
        vertical: isMobile ? DesignTokens.space16 : DesignTokens.space24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [DesignTokens.deepSpace, DesignTokens.darkNebula]
              : [Color(0xFFF0F2F8), Color(0xFFE8ECFC)],
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.people_rounded,
            color: DesignTokens.purpleNeon,
            size: isMobile ? 24 : 32,
          ),
          SizedBox(
            width: isMobile ? DesignTokens.space8 : DesignTokens.space16,
          ),
          Flexible(
            child: Text(
              'Gestión de Clientes',
              style: TextStyle(
                fontSize: isMobile
                    ? DesignTokens.fontSize24
                    : DesignTokens.fontSize32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Color(0xFF111827),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Clientes',
            totalClientes.toString(),
            Icons.business_center_rounded,
            DesignTokens.purpleNeon,
            isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            'Activos',
            clientesActivos.toString(),
            Icons.verified_rounded,
            DesignTokens.safeGreen,
            isDark,
          ),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildKPICard(
            'Por Vencer',
            proximosVencer.toString(),
            Icons.schedule_rounded,
            DesignTokens.warningYellow,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return GlassCard(
      showGlow: true,
      accentColor: color,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: DesignTokens.space8),
          Text(
            value,
            style: TextStyle(
              fontSize: DesignTokens.fontSize24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space4),
          Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSize12,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return TextField(
      controller: _searchController,
      onChanged: (_) => _aplicarFiltros(),
      style: TextStyle(color: isDark ? Colors.white : Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: 'Buscar por empresa, gerente o servicio...',
        hintStyle: TextStyle(
          color: isDark ? DesignTokens.meteorGray : Color(0xFF9CA3AF),
        ),
        prefixIcon: Icon(Icons.search_rounded, color: DesignTokens.purpleNeon),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear_rounded, color: DesignTokens.meteorGray),
                onPressed: () {
                  _searchController.clear();
                  _aplicarFiltros();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildClientsList(bool isDark) {
    return ListView.builder(
      itemCount: _clientesFiltrados.length,
      itemBuilder: (context, index) {
        final cliente = _clientesFiltrados[index];
        return _ExpandableClientCard(
              cliente: cliente,
              isDark: isDark,
              onEdit: () => _mostrarModal(cliente: cliente),
            )
            .animate()
            .fadeIn(delay: (index * 30).ms, duration: 200.ms)
            .slideX(begin: 0.1);
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 80,
            color: DesignTokens.meteorGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DesignTokens.space24),
          Text(
            'No hay clientes',
            style: TextStyle(
              fontSize: DesignTokens.fontSize24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            'Registra tu primer cliente con el botón +',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildFAB(bool isDark) {
    return FloatingActionButton.extended(
      onPressed: () => _mostrarModal(),
      backgroundColor: DesignTokens.purpleNeon,
      foregroundColor: Colors.white,
      icon: Icon(Icons.person_add_rounded),
      label: Text(
        'Nuevo Cliente',
        style: TextStyle(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().scale(delay: 200.ms, duration: 200.ms);
  }
}

class _ExpandableClientCard extends StatefulWidget {
  final Cliente cliente;
  final bool isDark;
  final VoidCallback onEdit;

  const _ExpandableClientCard({
    required this.cliente,
    required this.isDark,
    required this.onEdit,
  });

  @override
  State<_ExpandableClientCard> createState() => _ExpandableClientCardState();
}

class _ExpandableClientCardState extends State<_ExpandableClientCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final diasRestantes = DateHelpers.daysUntil(widget.cliente.fechaEntrega);
    final urgencyColor = DateHelpers.getUrgencyColor(
      widget.cliente.fechaEntrega,
    );
    final isVencido = diasRestantes < 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space16),
      child: GlassCard(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        accentColor: isVencido ? DesignTokens.urgentRed : null,
        child: Column(
          children: [
            // Header del card (Siempre visible)
            Row(
              children: [
                // Icono de empresa
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: DesignTokens.purpleNeon.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSmall,
                    ),
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: DesignTokens.purpleNeon,
                    size: 24,
                  ),
                ),

                const SizedBox(width: DesignTokens.space12),

                // Información Principal (Empresa y Gerente)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cliente.empresa,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSize18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark
                              ? Colors.white
                              : Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.space4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 14,
                            color: widget.isDark
                                ? DesignTokens.meteorGray
                                : Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.cliente.nombreGerente,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSize14,
                              color: widget.isDark
                                  ? DesignTokens.meteorGray
                                  : Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botón Editar
                IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: DesignTokens.cyanNeon,
                    size: 20,
                  ),
                  onPressed: widget.onEdit,
                  tooltip: 'Editar Cliente',
                ),

                const SizedBox(width: DesignTokens.space8),

                // Badge de días restantes
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.space12,
                    vertical: DesignTokens.space8,
                  ),
                  decoration: BoxDecoration(
                    color: urgencyColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      DesignTokens.radiusSmall,
                    ),
                    border: Border.all(color: urgencyColor, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        isVencido ? 'VENCIDO' : '$diasRestantes',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSize18,
                          fontWeight: FontWeight.bold,
                          color: urgencyColor,
                        ),
                      ),
                      if (!isVencido)
                        Text(
                          'días',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSize10,
                            color: urgencyColor,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: DesignTokens.space8),

                // Botón expandir/colapsar
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: widget.isDark
                      ? DesignTokens.meteorGray
                      : Color(0xFF6B7280),
                ),
              ],
            ),

            // Detalles Expandibles
            AnimatedSize(
              duration: 300.ms,
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Column(
                      children: [
                        const SizedBox(height: DesignTokens.space16),

                        // Fila 1: Servicio y Contacto
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                Icons.work_rounded,
                                'Servicio',
                                widget.cliente.servicio,
                                DesignTokens.cyanNeon,
                                widget.isDark,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space12),
                            Expanded(
                              child: _buildInfoChip(
                                Icons.phone_rounded,
                                'Contacto',
                                widget.cliente.numeroContacto,
                                DesignTokens.blueNeon,
                                widget.isDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: DesignTokens.space12),

                        // Fila 2: Registro y Finalización
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoChip(
                                Icons.calendar_month_rounded,
                                'Registro',
                                DateHelpers.formatDate(
                                  widget.cliente.fechaRegistro,
                                ),
                                DesignTokens.purpleNeon,
                                widget.isDark,
                              ),
                            ),
                            const SizedBox(width: DesignTokens.space12),
                            Expanded(
                              child: _buildInfoChip(
                                Icons.event_rounded,
                                'Finalización',
                                DateHelpers.formatDate(
                                  widget.cliente.fechaEntrega,
                                ),
                                urgencyColor,
                                widget.isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    String value,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.space12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: DesignTokens.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize10,
                    color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSize14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
