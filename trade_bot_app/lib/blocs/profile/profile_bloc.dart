import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        // Kullanıcı verisini alın
        final user = await userRepository.getUser(event.username);
        emit(ProfileLoaded(user: user));
      } catch (e) {
        emit(ProfileError(error: e.toString()));
      }
    });
  }
}
