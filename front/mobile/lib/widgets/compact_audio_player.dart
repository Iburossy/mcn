import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Lecteur audio compact inline
class CompactAudioPlayer extends StatefulWidget {
  final String audioUrl;

  const CompactAudioPlayer({
    super.key,
    required this.audioUrl,
  });

  @override
  State<CompactAudioPlayer> createState() => _CompactAudioPlayerState();
}

class _CompactAudioPlayerState extends State<CompactAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isLoading = true;
  bool _hasError = false;
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

      _audioPlayer.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() => _duration = duration);
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() => _position = position);
        }
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (mounted && state.processingState == ProcessingState.completed) {
          setState(() => _position = Duration.zero);
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
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
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.red),
        ),
      );
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // Bouton Play/Pause
          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;

              return IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 28,
                ),
                onPressed: () {
                  if (isPlaying) {
                    _audioPlayer.pause();
                  } else {
                    _audioPlayer.play();
                  }
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              );
            },
          ),

          const SizedBox(width: 12),

          // Temps actuel
          Text(
            _formatDuration(_position),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '/',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(width: 8),

          // Durée totale
          Text(
            _formatDuration(_duration),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(width: 12),

          // Barre de progression
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.grey.shade400,
                thumbColor: Colors.black,
                overlayColor: Colors.black.withValues(alpha: 0.2),
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
          ),

          const SizedBox(width: 12),

          // Icône volume
          const Icon(
            Icons.volume_up,
            size: 24,
          ),
        ],
      ),
    );
  }
}
