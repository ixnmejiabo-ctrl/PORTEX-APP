import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/database/database.dart';
import 'widgets/service_form_modal.dart';
import 'widgets/package_form_modal.dart';

/// Pantalla de Servicios y Paquetes con CRUD completo
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedTab = 0; // 0: Servicios, 1: Paquetes
  List<Servicio> _servicios = [];
  List<Servicio> _paquetes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = Provider.of<AppDatabase>(context, listen: false);

    final servicios = await db.obtenerServicios();
    final paquetes = await db.obtenerPaquetes();

    setState(() {
      _servicios = servicios;
      _paquetes = paquetes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          _buildHeader(
            isDark,
          ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),

          const SizedBox(height: DesignTokens.space24),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.space32,
            ),
            child: _buildTabs(isDark).animate().fadeIn(delay: 50.ms),
          ),

          const SizedBox(height: DesignTokens.space24),

          // Contenido según tab
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.space32,
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: DesignTokens.cyanNeon,
                      ),
                    )
                  : (_selectedTab == 0
                        ? _buildServicesList(isDark)
                        : _buildPackagesList(isDark)),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(isDark),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.space32,
        vertical: DesignTokens.space24,
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
            Icons.shopping_basket_rounded,
            color: DesignTokens.blueNeon,
            size: 32,
          ),
          const SizedBox(width: DesignTokens.space16),
          Text(
            'Servicios y Paquetes',
            style: TextStyle(
              fontSize: DesignTokens.fontSize32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTabButton('Servicios (${_servicios.length})', 0, isDark),
        ),
        const SizedBox(width: DesignTokens.space16),
        Expanded(
          child: _buildTabButton('Paquetes (${_paquetes.length})', 1, isDark),
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, int index, bool isDark) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DesignTokens.space16),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignTokens.blueNeon
              : (isDark ? DesignTokens.darkGray : Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(
            color: isSelected ? DesignTokens.blueNeon : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: DesignTokens.fontSize16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Color(0xFF111827)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList(bool isDark) {
    if (_servicios.isEmpty) {
      return _buildEmptyState(isDark, 'servicios', Icons.work_outline_rounded);
    }

    return ListView.builder(
      itemCount: _servicios.length,
      itemBuilder: (context, index) {
        final servicio = _servicios[index];
        return _buildServiceCard(servicio, isDark);
      },
    );
  }

  Widget _buildPackagesList(bool isDark) {
    if (_paquetes.isEmpty) {
      return _buildEmptyState(isDark, 'paquetes', Icons.inventory_2_outlined);
    }

    return ListView.builder(
      itemCount: _paquetes.length,
      itemBuilder: (context, index) {
        final paquete = _paquetes[index];
        return _buildPackageCard(paquete, isDark);
      },
    );
  }

  Widget _buildServiceCard(Servicio servicio, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space16),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.space16),
              decoration: BoxDecoration(
                color: DesignTokens.cyanNeon.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
              child: Icon(
                Icons.room_service_rounded,
                color: DesignTokens.cyanNeon,
                size: 32,
              ),
            ),
            const SizedBox(width: DesignTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    servicio.nombre,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                    ),
                  ),
                  if (servicio.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      servicio.descripcion,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSize14,
                        color: isDark
                            ? DesignTokens.meteorGray
                            : Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '\$${servicio.precio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: DesignTokens.fontSize20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.safeGreen,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded, color: DesignTokens.cyanNeon),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => ServiceFormModal(servicio: servicio),
                );
                if (result == true) _loadData();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded, color: DesignTokens.urgentRed),
              onPressed: () =>
                  _confirmDelete(servicio.id, servicio.nombre, true),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildPackageCard(Servicio paquete, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignTokens.space16),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(DesignTokens.space16),
              decoration: BoxDecoration(
                color: DesignTokens.purpleNeon.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSmall),
              ),
              child: Icon(
                Icons.inventory_2_rounded,
                color: DesignTokens.purpleNeon,
                size: 32,
              ),
            ),
            const SizedBox(width: DesignTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paquete.nombre,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSize18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF111827),
                    ),
                  ),
                  if (paquete.descripcion.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      paquete.descripcion,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSize14,
                        color: isDark
                            ? DesignTokens.meteorGray
                            : Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '\$${paquete.precio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: DesignTokens.fontSize20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.safeGreen,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded, color: DesignTokens.purpleNeon),
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => PackageFormModal(paquete: paquete),
                );
                if (result == true) _loadData();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_rounded, color: DesignTokens.urgentRed),
              onPressed: () =>
                  _confirmDelete(paquete.id, paquete.nombre, false),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildEmptyState(bool isDark, String tipo, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: DesignTokens.meteorGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: DesignTokens.space24),
          Text(
            'No hay $tipo',
            style: TextStyle(
              fontSize: DesignTokens.fontSize20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            'Crea tu primer ${tipo == 'servicios' ? 'servicio' : 'paquete'} con el botón +',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Future<void> _confirmDelete(int id, String nombre, bool isServicio) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar ${isServicio ? 'Servicio' : 'Paquete'}'),
        content: Text('¿Estás seguro de que deseas eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: DesignTokens.urgentRed,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final db = Provider.of<AppDatabase>(context, listen: false);
        await db.eliminarServicio(id);
        _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${isServicio ? 'Servicio' : 'Paquete'} eliminado exitosamente',
              ),
              backgroundColor: DesignTokens.safeGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: DesignTokens.urgentRed,
            ),
          );
        }
      }
    }
  }

  Widget _buildFAB(bool isDark) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) =>
              _selectedTab == 0 ? ServiceFormModal() : PackageFormModal(),
        );
        if (result == true) _loadData();
      },
      backgroundColor: DesignTokens.blueNeon,
      foregroundColor: Colors.white,
      icon: Icon(Icons.add_rounded),
      label: Text(
        _selectedTab == 0 ? 'Nuevo Servicio' : 'Nuevo Paquete',
        style: TextStyle(
          fontSize: DesignTokens.fontSize14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().scale(delay: 150.ms, duration: 200.ms);
  }
}
