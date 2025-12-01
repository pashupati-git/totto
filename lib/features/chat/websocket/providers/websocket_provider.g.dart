// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$webSocketMessagesHash() => r'60ce11ef03cedec4d8b027ba457fa2123f02a246';

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

/// See also [webSocketMessages].
@ProviderFor(webSocketMessages)
const webSocketMessagesProvider = WebSocketMessagesFamily();

/// See also [webSocketMessages].
class WebSocketMessagesFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [webSocketMessages].
  const WebSocketMessagesFamily();

  /// See also [webSocketMessages].
  WebSocketMessagesProvider call(ChatConnectionParams params) {
    return WebSocketMessagesProvider(params);
  }

  @override
  WebSocketMessagesProvider getProviderOverride(
    covariant WebSocketMessagesProvider provider,
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
  String? get name => r'webSocketMessagesProvider';
}

/// See also [webSocketMessages].
class WebSocketMessagesProvider
    extends AutoDisposeStreamProvider<Map<String, dynamic>> {
  /// See also [webSocketMessages].
  WebSocketMessagesProvider(ChatConnectionParams params)
    : this._internal(
        (ref) => webSocketMessages(ref as WebSocketMessagesRef, params),
        from: webSocketMessagesProvider,
        name: r'webSocketMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$webSocketMessagesHash,
        dependencies: WebSocketMessagesFamily._dependencies,
        allTransitiveDependencies:
            WebSocketMessagesFamily._allTransitiveDependencies,
        params: params,
      );

  WebSocketMessagesProvider._internal(
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
  Override overrideWith(
    Stream<Map<String, dynamic>> Function(WebSocketMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WebSocketMessagesProvider._internal(
        (ref) => create(ref as WebSocketMessagesRef),
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
  AutoDisposeStreamProviderElement<Map<String, dynamic>> createElement() {
    return _WebSocketMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WebSocketMessagesProvider && other.params == params;
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
mixin WebSocketMessagesRef
    on AutoDisposeStreamProviderRef<Map<String, dynamic>> {
  /// The parameter `params` of this provider.
  ChatConnectionParams get params;
}

class _WebSocketMessagesProviderElement
    extends AutoDisposeStreamProviderElement<Map<String, dynamic>>
    with WebSocketMessagesRef {
  _WebSocketMessagesProviderElement(super.provider);

  @override
  ChatConnectionParams get params =>
      (origin as WebSocketMessagesProvider).params;
}

String _$webSocketChannelHash() => r'8a5dc3525ddf0c6d2799f502741e4a3483a04fb7';

abstract class _$WebSocketChannel
    extends BuildlessAutoDisposeAsyncNotifier<wsc.WebSocketChannel> {
  late final ChatConnectionParams params;

  FutureOr<wsc.WebSocketChannel> build(ChatConnectionParams params);
}

/// See also [WebSocketChannel].
@ProviderFor(WebSocketChannel)
const webSocketChannelProvider = WebSocketChannelFamily();

/// See also [WebSocketChannel].
class WebSocketChannelFamily extends Family<AsyncValue<wsc.WebSocketChannel>> {
  /// See also [WebSocketChannel].
  const WebSocketChannelFamily();

  /// See also [WebSocketChannel].
  WebSocketChannelProvider call(ChatConnectionParams params) {
    return WebSocketChannelProvider(params);
  }

  @override
  WebSocketChannelProvider getProviderOverride(
    covariant WebSocketChannelProvider provider,
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
  String? get name => r'webSocketChannelProvider';
}

/// See also [WebSocketChannel].
class WebSocketChannelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          WebSocketChannel,
          wsc.WebSocketChannel
        > {
  /// See also [WebSocketChannel].
  WebSocketChannelProvider(ChatConnectionParams params)
    : this._internal(
        () => WebSocketChannel()..params = params,
        from: webSocketChannelProvider,
        name: r'webSocketChannelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$webSocketChannelHash,
        dependencies: WebSocketChannelFamily._dependencies,
        allTransitiveDependencies:
            WebSocketChannelFamily._allTransitiveDependencies,
        params: params,
      );

  WebSocketChannelProvider._internal(
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
  FutureOr<wsc.WebSocketChannel> runNotifierBuild(
    covariant WebSocketChannel notifier,
  ) {
    return notifier.build(params);
  }

  @override
  Override overrideWith(WebSocketChannel Function() create) {
    return ProviderOverride(
      origin: this,
      override: WebSocketChannelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    WebSocketChannel,
    wsc.WebSocketChannel
  >
  createElement() {
    return _WebSocketChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WebSocketChannelProvider && other.params == params;
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
mixin WebSocketChannelRef
    on AutoDisposeAsyncNotifierProviderRef<wsc.WebSocketChannel> {
  /// The parameter `params` of this provider.
  ChatConnectionParams get params;
}

class _WebSocketChannelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          WebSocketChannel,
          wsc.WebSocketChannel
        >
    with WebSocketChannelRef {
  _WebSocketChannelProviderElement(super.provider);

  @override
  ChatConnectionParams get params =>
      (origin as WebSocketChannelProvider).params;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
