import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thinknode/features/auth/data/auth_repository.dart';
import 'package:thinknode/features/auth/domain/models/user_model.dart';
import 'package:thinknode/features/mindmap/data/mindmap_repository.dart';
import 'package:thinknode/features/mindmap/domain/models/mindmap_model.dart';

/// Dialog for sharing a mindmap with other users
class ShareDialog extends ConsumerStatefulWidget {
  final MindMapModel mindmap;

  const ShareDialog({super.key, required this.mindmap});

  @override
  ConsumerState<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends ConsumerState<ShareDialog> {
  final _emailController = TextEditingController();
  MindMapRole _selectedRole = MindMapRole.editor;
  bool _isSearching = false;
  String? _error;
  String? _success;

  /// Cache of userId -> UserModel for displaying collaborator info
  final Map<String, UserModel?> _userCache = {};
  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _loadCollaboratorProfiles();
  }

  Future<void> _loadCollaboratorProfiles() async {
    final authRepo = ref.read(authRepositoryProvider);
    final futures = widget.mindmap.collaborators.keys.map((userId) async {
      try {
        final profile = await authRepo.getUserProfile(userId);
        _userCache[userId] = profile;
      } catch (_) {
        _userCache[userId] = null;
      }
    });
    await Future.wait(futures);
    if (mounted) {
      setState(() => _isLoadingUsers = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleShare() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Bitte eine E-Mail eingeben');
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _success = null;
    });

    try {
      // Search for user by email
      final users =
          await ref.read(authRepositoryProvider).searchUsersByEmail(email);

      if (users.isEmpty) {
        setState(() {
          _error = 'Kein Benutzer mit dieser E-Mail gefunden';
          _isSearching = false;
        });
        return;
      }

      final user = users.first;

      // Check if already a collaborator
      if (widget.mindmap.collaborators.containsKey(user.id)) {
        setState(() {
          _error = 'Dieser Benutzer ist bereits ein Mitarbeiter';
          _isSearching = false;
        });
        return;
      }

      // Add collaborator
      await ref.read(mindmapRepositoryProvider).addCollaborator(
            mindmapId: widget.mindmap.id,
            userId: user.id,
            role: _selectedRole,
          );

      setState(() {
        _success = '${user.displayName} wurde als ${_selectedRole.name} hinzugefügt';
        _isSearching = false;
        _emailController.clear();
      });
    } catch (e) {
      setState(() {
        _error = 'Fehler beim Teilen: $e';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Row(
                children: [
                  const Icon(Icons.share),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mindmap teilen',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.mindmap.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),

              // Share link
              Card(
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Link kopieren'),
                  subtitle: const Text('Jeder mit dem Link kann beitreten'),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: 'thinknode://mindmap/${widget.mindmap.id}',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link kopiert!')),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email invite
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'E-Mail-Adresse eingeben',
                        prefixIcon: Icon(Icons.email_outlined),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (_) => _handleShare(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Role dropdown
                  DropdownButton<MindMapRole>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(
                        value: MindMapRole.editor,
                        child: Text('Editor'),
                      ),
                      DropdownMenuItem(
                        value: MindMapRole.viewer,
                        child: Text('Viewer'),
                      ),
                    ],
                    onChanged: (role) {
                      if (role != null) setState(() => _selectedRole = role);
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSearching ? null : _handleShare,
                    child: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Einladen'),
                  ),
                ],
              ),

              // Status messages
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              if (_success != null) ...[
                const SizedBox(height: 8),
                Text(
                  _success!,
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ],
              const SizedBox(height: 16),

              // Current collaborators
              Text(
                'Mitarbeiter',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: _isLoadingUsers
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children:
                            widget.mindmap.collaborators.entries.map((entry) {
                          final userId = entry.key;
                          final role = entry.value;
                          final profile = _userCache[userId];
                          final displayName = profile?.displayName ?? '';
                          final email = profile?.email ?? userId;
                          final initial = displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : (email.isNotEmpty
                                  ? email[0].toUpperCase()
                                  : '?');

                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              child: Text(initial),
                            ),
                            title: Text(
                              displayName.isNotEmpty ? displayName : email,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: displayName.isNotEmpty
                                ? Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: role == 'owner'
                                ? Chip(
                                    label: const Text('Owner'),
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Chip(label: Text(role)),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            size: 18),
                                        onPressed: () async {
                                          await ref
                                              .read(mindmapRepositoryProvider)
                                              .removeCollaborator(
                                                mindmapId: widget.mindmap.id,
                                                userId: userId,
                                              );
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

