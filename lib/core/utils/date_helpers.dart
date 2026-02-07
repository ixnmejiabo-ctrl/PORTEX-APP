import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Helpers para cálculos de fechas y colores de urgencia
class DateHelpers {
  static int daysUntil(DateTime targetDate) {
    final now = DateTime.now();
    // Normalizamos ambas fechas al inicio del día (00:00:00) en hora local
    // para asegurar una diferencia de días calendario exacta.
    final today = DateTime(now.year, now.month, now.day);
    final targetLocal = targetDate.toLocal();
    final target = DateTime(
      targetLocal.year,
      targetLocal.month,
      targetLocal.day,
    );

    return target.difference(today).inDays;
  }

  /// Obtiene el color semáforo según días restantes
  /// Rojo: 0-2 días, Amarillo: 3-5 días, Verde: 6+ días
  static Color getUrgencyColor(DateTime targetDate) {
    final daysLeft = daysUntil(targetDate);

    if (daysLeft <= 2) {
      return DesignTokens.urgentRed;
    } else if (daysLeft <= 5) {
      return DesignTokens.warningYellow;
    } else {
      return DesignTokens.safeGreen;
    }
  }

  /// Obtiene el texto de urgencia
  static String getUrgencyText(DateTime targetDate) {
    final daysLeft = daysUntil(targetDate);

    if (daysLeft < 0) {
      return 'Retrasado ${-daysLeft} día${-daysLeft != 1 ? 's' : ''}';
    } else if (daysLeft == 0) {
      return 'Hoy';
    } else if (daysLeft == 1) {
      return 'Mañana';
    } else {
      return 'En $daysLeft días';
    }
  }

  /// Formatea fecha en español
  static String formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Formatea fecha completa
  static String formatFullDate(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  /// Verifica si una fecha está en el rango
  static bool isInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
  }
}

/// Helpers para colores de tipos de actividad
class ActivityTypeHelper {
  static Color getTypeColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'video':
        return DesignTokens.typeVideo;
      case 'imagen':
      case 'image':
        return DesignTokens.typeImage;
      case 'campaña':
      case 'campaign':
      case 'ads':
        return DesignTokens.typeCampaign;
      case 'post':
        return DesignTokens.typePost;
      case 'historia':
      case 'story':
        return DesignTokens.typeStory;
      default:
        return DesignTokens.purpleNeon;
    }
  }

  static IconData getTypeIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'video':
        return Icons.videocam;
      case 'imagen':
      case 'image':
        return Icons.image;
      case 'campaña':
      case 'campaign':
      case 'ads':
        return Icons.campaign;
      case 'post':
        return Icons.article;
      case 'historia':
      case 'story':
        return Icons.auto_stories;
      default:
        return Icons.work;
    }
  }
}

/// Helpers para estados de actividad
class ActivityStateHelper {
  static Color getStateColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return DesignTokens.statePending;
      case 'en proceso':
      case 'proceso':
        return DesignTokens.stateInProgress;
      case 'listo':
        return DesignTokens.stateReady;
      case 'entregado':
        return DesignTokens.stateDelivered;
      case 'publicado':
        return DesignTokens.statePublished;
      case 'retrasado':
        return DesignTokens.stateDelayed;
      default:
        return DesignTokens.meteorGray;
    }
  }

  static IconData getStateIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Icons.schedule;
      case 'en proceso':
      case 'proceso':
        return Icons.play_circle;
      case 'listo':
        return Icons.check_circle;
      case 'entregado':
        return Icons.send;
      case 'publicado':
        return Icons.public;
      case 'retrasado':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }
}
