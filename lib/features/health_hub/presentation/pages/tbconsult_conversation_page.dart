import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:TBConsult/core/theme/app_colors.dart';
import 'package:TBConsult/features/health_hub/presentation/cubit/conversation_cubit.dart';
import 'package:TBConsult/features/health_hub/presentation/cubit/conversation_state.dart';
import 'package:TBConsult/features/health_hub/presentation/widgets/chat_bubble_widget.dart';
import 'package:TBConsult/features/health_hub/presentation/widgets/input_bar_widget.dart';
import 'package:TBConsult/features/health_hub/domain/entities/message.dart';
import 'conversation_summary_page.dart';

class TBConsultConversationPage extends StatefulWidget {
  final String? initialMessage;

  const TBConsultConversationPage({super.key, this.initialMessage});

  @override
  State<TBConsultConversationPage> createState() =>
      _TBConsultConversationPageState();
}

class _TBConsultConversationPageState extends State<TBConsultConversationPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _mediaButtonKey = GlobalKey();

  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      _textController.text = widget.initialMessage!;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<ConversationCubit>().sendTextMessage(text);
  }

  void _listen() async {
    _focusNode.unfocus();
    final cubit = context.read<ConversationCubit>();

    if (!_speechEnabled) {
      bool initialized = await _speech.initialize(
        onError: (val) {
          debugPrint('Speech error: $val');
          if (mounted) cubit.finishTranscription();
        },
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            if (mounted) cubit.finishTranscription();
          }
        },
        debugLogging: true,
      );
      _speechEnabled = initialized;
      if (!initialized) return;

      // Give the system a brief moment to finish setting up locales if it was just initialized
      await Future.delayed(const Duration(milliseconds: 200));
    }

    final state = cubit.state;
    final isCurrentlyListening =
        state is ConversationMessaging && state.isListening;

    if (!isCurrentlyListening) {
      _textController.clear();
      cubit.startListening();

      // Resolve the target locale dynamically based on the conversation history first.
      // For new conversations (empty history), default to Indonesian ('id-ID') to ensure
      // voice inputs like "cari rumah sakit terdekat" are transcribed in Indonesian,
      // regardless of the active voice persona's language.
      String targetLocaleId = 'id-ID';
      final messages = state.conversation?.messages ?? [];
      
      if (messages.isNotEmpty) {
        final lastMessage = messages.last.content;
        targetLocaleId = ChatBubbleWidget.detectLanguage(lastMessage);
        debugPrint("STT: Resolved locale from last message language: $targetLocaleId");
      } else {
        debugPrint("STT: Resolved locale defaulting to Indonesian for new conversation: $targetLocaleId");
      }

      debugPrint("STT: Active Persona name: ${ChatBubbleWidget.activePersona.name}, locale: ${ChatBubbleWidget.activePersona.locale}");

      try {
        final systemLocales = await _speech.locales();
        debugPrint("STT: Available system locales: ${systemLocales.map((l) => l.localeId).toList()}");
        
        // Canonical translation that treats legacy 'in' (Indonesian) and modern 'id' as equivalent
        String canonical(String loc) {
          final clean = loc.toLowerCase().replaceAll(RegExp(r'[-_]'), '');
          if (clean.startsWith('id')) {
            return 'in${clean.substring(2)}';
          }
          return clean;
        }

        final targetCanonical = canonical(targetLocaleId);
        bool foundMatch = false;
        
        for (var locale in systemLocales) {
          if (canonical(locale.localeId) == targetCanonical) {
            targetLocaleId = locale.localeId;
            foundMatch = true;
            debugPrint("STT: Resolved canonical matching locale from system list: $targetLocaleId");
            break;
          }
        }

        // If not found in the list, fallback to language prefix matching (e.g. matching id/in prefix)
        if (!foundMatch && systemLocales.isNotEmpty) {
          String prefixCanonical(String loc) {
            final prefix = loc.split('-')[0].split('_')[0].toLowerCase();
            return prefix == 'in' ? 'id' : prefix;
          }
          
          final targetPrefix = prefixCanonical(targetLocaleId);
          for (var locale in systemLocales) {
            if (prefixCanonical(locale.localeId) == targetPrefix) {
              targetLocaleId = locale.localeId;
              foundMatch = true;
              debugPrint("STT: Resolved prefix matching locale from system list: $targetLocaleId");
              break;
            }
          }
        }
      } catch (e) {
        debugPrint("STT: Error querying available system locales: $e");
      }

      // Format locale ID properly for Android if it wasn't matched from system list.
      // If the target is Indonesian and not found, fall back to 'in_ID' which is standard for Android legacy engine.
      if (Platform.isAndroid) {
        if (targetLocaleId.toLowerCase().startsWith('id-') || targetLocaleId.toLowerCase() == 'id-id') {
          targetLocaleId = 'in_ID';
          debugPrint("STT: Android fallback formatting to legacy Indonesian locale: $targetLocaleId");
        } else if (targetLocaleId.contains('-')) {
          targetLocaleId = targetLocaleId.replaceAll('-', '_');
          debugPrint("STT: Formatted to Android style: $targetLocaleId");
        }
      }

      debugPrint("STT: Listening with localeId: $targetLocaleId");

      _speech.listen(
        localeId: targetLocaleId,
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
        ),
        onResult: (val) {
          if (mounted) {
            _textController.text = val.recognizedWords;
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textController.text.length),
            );
            if (val.finalResult) {
              cubit.finishTranscription();
            }
          }
        },
      );
    } else {
      cubit.stopListening();
      _speech.stop();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) cubit.finishTranscription();
      });
    }
  }

  void _showMediaOptions() async {
    _focusNode.unfocus();
    final RenderBox? box =
        _mediaButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset offset = box.localToGlobal(Offset.zero);

    final value = await showMenu<ImageSource>(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy - 120, offset.dx + box.size.width, offset.dy),
      items: const [
        PopupMenuItem(
          value: ImageSource.camera,
          child: Row(
            children: [
              Icon(Icons.camera_alt_outlined),
              SizedBox(width: 8),
              Text('Camera'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ImageSource.gallery,
          child: Row(
            children: [
              Icon(Icons.photo_library_outlined),
              SizedBox(width: 8),
              Text('Gallery'),
            ],
          ),
        ),
      ],
    );

    if (value != null) {
      final XFile? image = await _picker.pickImage(source: value);
      if (image != null && mounted) {
        context.read<ConversationCubit>().sendImageMessage(File(image.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<ConversationCubit>().saveBeforeExit();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F8),
        body: SafeArea(
          child: BlocConsumer<ConversationCubit, ConversationState>(
            listener: (context, state) {
              _scrollToBottom();

              // Navigate to summary when summarization completes
              if (state is ConversationSummarized &&
                  state.conversation != null) {
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationSummaryPage(
                      conversation: state.conversation!,
                    ),
                  ),
                );
              }

              // Show error snackbar
              if (state is ConversationError) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final messages = state.conversation?.messages ?? [];
              final isWaiting = state is ConversationMessaging &&
                  state.isWaitingForResponse;
              final isListening =
                  state is ConversationMessaging && state.isListening;
              final isTranscribing =
                  state is ConversationMessaging && state.isTranscribing;
              final isSummarizing = state is ConversationSummarizing;

              int lastUserIndex = -1;
              for (int i = messages.length - 1; i >= 0; i--) {
                if (messages[i].role == MessageRole.user) {
                  lastUserIndex = i;
                  break;
                }
              }

              return Column(
                children: [
                  _buildAppBar(context, isWaiting || isSummarizing),
                  Expanded(
                    child: messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 24.0),
                            itemCount:
                                messages.length + (isWaiting ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == messages.length && isWaiting) {
                                return _buildTypingIndicator();
                              }
                              return ChatBubbleWidget(
                                message: messages[index],
                                isLatestUserMessage: index == lastUserIndex,
                              );
                            },
                          ),
                  ),
                  if (isSummarizing)
                    _buildSummarizingBar()
                  else
                    InputBarWidget(
                      textController: _textController,
                      focusNode: _focusNode,
                      isLoading: isWaiting,
                      isListening: isListening,
                      isTranscribing: isTranscribing,
                      onSend: _sendMessage,
                      onMicTap: _listen,
                      onMediaTap: _showMediaOptions,
                      mediaButtonKey: _mediaButtonKey,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isBusy) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TBConsult',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isBusy
                            ? AppColors.accentYellow
                            : const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isBusy ? 'Thinking...' : 'Online',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showPersonaSelectionDialog(context),
            child: const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 20,
              child:
                  Icon(Icons.smart_toy, color: AppColors.background, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void _showPersonaSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              title: const Row(
                children: [
                  Icon(Icons.smart_toy, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    "Select Voice Persona",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: VoicePersona.all.length,
                  itemBuilder: (context, index) {
                    final persona = VoicePersona.all[index];
                    final isSelected = ChatBubbleWidget.activePersona.name == persona.name;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.12),
                        child: Icon(
                          persona.isMale ? Icons.face : Icons.face_3,
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                      ),
                      title: Text(
                        persona.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        persona.description,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppColors.primary : Colors.grey,
                        size: 20,
                      ),
                      onTap: () {
                        ChatBubbleWidget.stopSpeaking();
                        setState(() {
                          ChatBubbleWidget.activePersona = persona;
                        });
                        setDialogState(() {});
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Voice Persona set to: ${persona.name}"),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Close",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "How can TBConsult help you today?",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            radius: 14,
            child: const Icon(Icons.smart_toy,
                color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const SizedBox(
              width: 40,
              height: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BouncingDot(delay: 0),
                  _BouncingDot(delay: 150),
                  _BouncingDot(delay: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarizingBar() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Generating summary...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing indicator animation ───────────────────────────────────────────

class _BouncingDot extends StatefulWidget {
  final int delay;

  const _BouncingDot({required this.delay});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
