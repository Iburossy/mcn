import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/constants.dart';

/// Widget de lecture audio élégant pour le musée
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String? title;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    this.title,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isLoading = true;
  String? _error;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _audioPlayer = AudioPlayer();

    try {
      await _audioPlayer.setUrl(widget.audioUrl);

      // Écouter les changements de durée
      _audioPlayer.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() => _duration = duration);
        }
      });

      // Écouter les changements de position
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      });

      // Écouter la fin de lecture
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted && state.processingState == ProcessingState.completed) {
          setState(() {
            _position = Duration.zero;
          });
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger l\'audio',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre (optionnel)
          if (widget.title != null) ...[
            Row(
              children: [
                const Icon(Icons.headphones, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title!,
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Contrôles de lecture
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bouton reculer 10s
              IconButton(
                icon: const Icon(Icons.replay_10),
                color: AppColors.primary,
                onPressed: () {
                  final newPosition = _position - const Duration(seconds: 10);
                  _audioPlayer.seek(
                    newPosition < Duration.zero ? Duration.zero : newPosition,
                  );
                },
              ),

              const SizedBox(width: 8),

              // Bouton Play/Pause
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final isPlaying = playerState?.playing ?? false;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        if (isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.play();
                        }
                      },
                    ),
                  );
                },
              ),

              const SizedBox(width: 8),

              // Bouton avancer 10s
              IconButton(
                icon: const Icon(Icons.forward_10),
                color: AppColors.primary,
                onPressed: () {
                  final newPosition = _position + const Duration(seconds: 10);
                  _audioPlayer.seek(
                    newPosition > _duration ? _duration : newPosition,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),

              // Temps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Contrôle du volume
          Row(
            children: [
              const Icon(Icons.volume_down, color: AppColors.primary, size: 20),
              Expanded(
                child: StreamBuilder<double>(
                  stream: _audioPlayer.volumeStream,
                  builder: (context, snapshot) {
                    final volume = snapshot.data ?? 1.0;
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: Colors.grey.shade300,
                        thumbColor: AppColors.primary,
                        overlayColor: AppColors.primary.withValues(alpha: 0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: volume,
                        onChanged: (value) {
                          _audioPlayer.setVolume(value);
                        },
                      ),
                    );
                  },
                ),
              ),
              const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
