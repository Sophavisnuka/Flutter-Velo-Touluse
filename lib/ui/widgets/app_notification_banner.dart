import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/services/notification_service.dart';

class AppNotificationBanner extends StatefulWidget {
  const AppNotificationBanner({super.key});

  @override
  State<AppNotificationBanner> createState() => _AppNotificationBannerState();
}

class _AppNotificationBannerState extends State<AppNotificationBanner>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  AnimationController? _progressController;

  // The notification currently being displayed (kept alive during slide-out)
  InAppNotification? _displayedNotification;
  NotificationService? _service;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    // Clear displayed notification after slide-out completes
    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && mounted) {
        setState(() => _displayedNotification = null);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = context.read<NotificationService>();
    if (_service != service) {
      _service?.removeListener(_onNotificationChanged);
      _service = service;
      _service!.addListener(_onNotificationChanged);
    }
  }

  void _onNotificationChanged() {
    final notification = _service?.current;
    if (notification != null) {
      // Start progress bar for new notification
      _progressController?.dispose();
      _progressController = AnimationController(
        vsync: this,
        duration: notification.duration,
      )..forward();

      setState(() => _displayedNotification = notification);
      _slideController.forward(from: 0);
    } else {
      _slideController.reverse();
    }
  }

  @override
  void dispose() {
    _service?.removeListener(_onNotificationChanged);
    _slideController.dispose();
    _progressController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedNotification == null) return const SizedBox.shrink();

    final notification = _displayedNotification!;

    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              notification.onTap?.call();
              context.read<NotificationService>().dismiss();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: notification.color.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(notification.icon,
                                color: notification.color, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF101828),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                context.read<NotificationService>().dismiss(),
                            child: Icon(Icons.close,
                                size: 18, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                    // Countdown progress bar
                    if (_progressController != null)
                      AnimatedBuilder(
                        animation: _progressController!,
                        builder: (context, child) => LinearProgressIndicator(
                          value: 1 - _progressController!.value,
                          backgroundColor: Colors.grey[100],
                          valueColor:
                              AlwaysStoppedAnimation(notification.color),
                          minHeight: 3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
