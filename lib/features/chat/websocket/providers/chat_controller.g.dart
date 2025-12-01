// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatControllerHash() => r'd08d64fd195821080b5d392f776bccdba4738687';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ChatController
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final ChatConnectionParams params;

  FutureOr<List<Message>> build(ChatConnectionParams params);
}

/// See also [ChatController].
@ProviderFor(ChatController)
const chatControllerProvider = ChatControllerFamily();

/// See also [ChatController].
class ChatControllerFamily extends Family<AsyncValue<List<Message>>> {
  /// See also [ChatController].
  const ChatControllerFamily();

  /// See also [ChatController].
  ChatControllerProvider call(ChatConnectionParams params) {
    return ChatControllerProvider(params);
  }

  @override
  ChatControllerProvider getProviderOverride(
    covariant ChatControllerProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatControllerProvider';
}

/// See also [ChatController].
class ChatControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ChatController, List<Message>> {
  /// See also [ChatController].
  ChatControllerProvider(ChatConnectionParams params)
    : this._internal(
        () => ChatController()..params = params,
        from: chatControllerProvider,
        name: r'chatControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chatControllerHash,
        dependencies: ChatControllerFamily._dependencies,
        allTransitiveDependencies:
            ChatControllerFamily._allTransitiveDependencies,
        params: params,
      );

  ChatControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ChatConnectionParams params;

  @override
  FutureOr<List<Message>> runNotifierBuild(covariant ChatController notifier) {
    return notifier.build(params);
  }

  @override
  Override overrideWith(ChatController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatControllerProvider._internal(
        () => create()..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatController, List<Message>>
  createElement() {
    return _ChatControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatControllerProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChatControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `params` of this provider.
  ChatConnectionParams get params;
}

class _ChatControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ChatController, List<Message>>
    with ChatControllerRef {
  _ChatControllerProviderElement(super.provider);

  @override
  ChatConnectionParams get params => (origin as ChatControllerProvider).params;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
