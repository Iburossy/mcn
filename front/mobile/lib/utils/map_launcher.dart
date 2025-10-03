import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

/// Helper pour ouvrir les applications de navigation
class MapLauncher {
  /// Ouvrir l'itinéraire vers le musée
  static Future<bool> openDirections() async {
    final url = Platform.isIOS 
        ? MuseumLocation.appleMapsUrl 
        : MuseumLocation.googleMapsUrl;
    
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    return false;
  }

  /// Appeler le musée
  static Future<bool> callMuseum() async {
    final uri = Uri.parse('tel:${MuseumLocation.phone}');
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Envoyer un email au musée
  static Future<bool> emailMuseum() async {
    final uri = Uri.parse('mailto:${MuseumLocation.email}');
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  /// Ouvrir dans Google Maps avec navigation
  static Future<bool> openGoogleMapsNavigation() async {
    // URL pour démarrer la navigation directement
    final url = 'google.navigation:q=${MuseumLocation.latitude},${MuseumLocation.longitude}';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Fallback vers l'URL web
      return await openDirections();
    }
  }

  /// Ouvrir dans Apple Maps avec navigation
  static Future<bool> openAppleMapsNavigation() async {
    final url = 'maps://?daddr=${MuseumLocation.latitude},${MuseumLocation.longitude}&dirflg=d';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Fallback vers l'URL web
      return await openDirections();
    }
  }

  /// Ouvrir la navigation selon la plateforme
  static Future<bool> startNavigation() async {
    if (Platform.isIOS) {
      return await openAppleMapsNavigation();
    } else {
      return await openGoogleMapsNavigation();
    }
  }
}
