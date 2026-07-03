
import 'package:fleet_driver/core/utils/colors/app_colors.dart';
import 'package:fleet_driver/core/utils/service_locator/service_locator.dart';
import 'package:fleet_driver/core/utils/styles/app_style.dart';
import 'package:fleet_driver/core/utils/widgets/primary_button.dart';
import 'package:fleet_driver/feature/home/presentation/widgets/counter_button.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/pending_logas_cubit.dart';
import 'package:fleet_driver/feature/log_free_seats/presentation/cubits/seats_cubit/seats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogFreeSeatsModal extends StatefulWidget {
  final String stationId;
  final String stationName;
  final String routeId;
  final double stationLat;
  final double stationLng;

  const LogFreeSeatsModal({
    super.key,
    required this.stationId,
    required this.stationName,
    required this.routeId,
    required this.stationLat,
    required this.stationLng,
  });

  @override
  State<LogFreeSeatsModal> createState() => _LogFreeSeatsModalState();
}

class _LogFreeSeatsModalState extends State<LogFreeSeatsModal> {
  int freeSeats = 5;
  bool _isWithinRange = false; 

  void _increment() => setState(() => freeSeats++);

  void _decrement() {
    if (freeSeats > 0) setState(() => freeSeats--);
  }

  @override
  void initState() {
    super.initState();
    context.read<SeatsCubit>().checkGeofence(
          stationLat: widget.stationLat,
          stationLng: widget.stationLng,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeatsCubit, SeatsState>(
      listener: (context, state) {
        if (state is SeatsWithinRange) {
          setState(() => _isWithinRange = true);
        }
        if (state is SeatsOutOfRange) {
          setState(() => _isWithinRange = false);
        }

        if (state is SeatsSubmitSuccess) {
          getIt<PendingLogsCubit>().refresh();

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.synced
                    ? '✅ Submitted successfully'
                    : '📥 Saved offline - will sync when the internet is back',
              ),
            ),
          );
        }
        if (state is SeatsSubmitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is SeatsSubmitLoading;
        final isCheckingLocation = state is SeatsCheckingLocation;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              const SizedBox(height: 20),

              Text(widget.stationName, style: AppStyle.text20),
              const SizedBox(height: 4),
              Text(
                'Log available seats for this stop',
                style: AppStyle.text16.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              _buildLocationBadge(_isWithinRange, isCheckingLocation), 

              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CounterButton(icon: Icons.remove, onTap: _decrement),
                  Column(
                    children: [
                      Text(
                        '$freeSeats',
                        style: AppStyle.text28.copyWith(fontSize: 48),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'free seats',
                        style: AppStyle.text16.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  CounterButton(icon: Icons.add, onTap: _increment),
                ],
              ),
              const SizedBox(height: 36),

       
              PrimaryButton(
  label: isSubmitting ? "Loading....." : "Confirm",
  onTap: (_isWithinRange && !isSubmitting)
      ? () {
          context.read<SeatsCubit>().submitFreeSeats(
                stationId: widget.stationId,
                stationName: widget.stationName,
                routeId: widget.routeId,
                freeSeats: freeSeats,
              );
        }
      : null, 
),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationBadge(bool isWithinRange, bool isChecking) {
    if (isChecking) {
      return const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Getting your location...')
        ],
      );
    }

    final bool ok = isWithinRange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ok ? AppColors.successBg : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ok ? AppColors.success.withOpacity(0.4) : Colors.red,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.location_on : Icons.location_off,
            color: ok ? AppColors.success : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            ok ? 'Within station range' : 'Out of station range',
            style: AppStyle.text16.copyWith(
              color: ok ? AppColors.success : Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}