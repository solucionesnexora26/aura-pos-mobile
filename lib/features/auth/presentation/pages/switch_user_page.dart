import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_providers.dart';

final _activeUsersProvider = FutureProvider<Either<Failure, List<UserEntity>>>(
  (ref) => ref.read(getActiveUsersUseCaseProvider).call(const NoParams()),
);

class SwitchUserPage extends ConsumerWidget {
  const SwitchUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Either<Failure, List<UserEntity>>> usersAsync = ref.watch(_activeUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Usuario'),
        leading: const BackButton(),
      ),
      body: usersAsync.when(
        loading: () => const AppLoadingView(message: 'Cargando usuarios...'),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (result) => result.fold(
          (failure) => AppErrorView(message: failure.message),
          (users) {
            if (users.isEmpty) {
              return const AppEmptyView(message: 'No hay usuarios activos.');
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(user.role.label),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go(
                      RoutePaths.pinEntry,
                      extra: user.username,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
