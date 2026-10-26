import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class VoiceMemoService {
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  Timer? _countdownTimer;

  static const int maxDurationSeconds = 10;
  int _secondsRemaining = maxDurationSeconds;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _currentFilePath;

  final StreamController<int> _secondsStream = StreamController<int>.broadcast();
  final StreamController<bool> _recordingStateStream = StreamController<bool>.broadcast();
  final StreamController<bool> _playingStateStream = StreamController<bool>.broadcast();

  VoiceMemoService({
    AudioRecorder? recorder,
    AudioPlayer? player,
  })  : _recorder = recorder ?? AudioRecorder(),
        _player = player ?? AudioPlayer() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _playingStateStream.add(_isPlaying);
    });
  }

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  int get secondsRemaining => _secondsRemaining;
  String? get currentFilePath => _currentFilePath;

  Stream<int> get secondsStream => _secondsStream.stream;
  Stream<bool> get recordingStateStream => _recordingStateStream.stream;
  Stream<bool> get playingStateStream => _playingStateStream.stream;

  /// Starts recording a 10-second voice memo.
  /// Automatically stops when 10 seconds have elapsed.
  Future<bool> startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final memoDir = Directory('${dir.path}/voice_memos');
        if (!memoDir.existsSync()) {
          memoDir.createSync(recursive: true);
        }

        final memoId = const Uuid().v4();
        final path = '${memoDir.path}/memo_$memoId.m4a';
        _currentFilePath = path;

        // Configure high efficiency AAC/M4A recording
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        _isRecording = true;
        _secondsRemaining = maxDurationSeconds;
        _recordingStateStream.add(true);
        _secondsStream.add(_secondsRemaining);

        // Start 10-second countdown timer
        _countdownTimer?.cancel();
        _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          _secondsRemaining--;
          _secondsStream.add(_secondsRemaining);

          if (_secondsRemaining <= 0) {
            timer.cancel();
            await stopRecording();
          }
        });

        return true;
      }
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
    }
    return false;
  }

  /// Stops current recording and returns the saved file path.
  Future<String?> stopRecording() async {
    _countdownTimer?.cancel();
    if (!_isRecording) return _currentFilePath;

    try {
      final path = await _recorder.stop();
      _isRecording = false;
      _recordingStateStream.add(false);
      _currentFilePath = path ?? _currentFilePath;
      return _currentFilePath;
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      _isRecording = false;
      _recordingStateStream.add(false);
      return null;
    }
  }

  /// Plays recorded voice memo at [filePath]
  Future<void> play(String filePath) async {
    try {
      if (_isPlaying) {
        await _player.stop();
      }
      await _player.play(DeviceFileSource(filePath));
    } catch (e) {
      debugPrint('Error playing audio memo: $e');
    }
  }

  /// Pauses playback
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  /// Stops playback
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  /// Deletes memo file from storage
  Future<void> deleteMemo(String filePath) async {
    try {
      await stop();
      final file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
      if (_currentFilePath == filePath) {
        _currentFilePath = null;
      }
    } catch (e) {
      debugPrint('Error deleting voice memo file: $e');
    }
  }

  void dispose() {
    _countdownTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    _secondsStream.close();
    _recordingStateStream.close();
    _playingStateStream.close();
  }
}
