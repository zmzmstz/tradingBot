abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String username;

  LoadProfile({required this.username});
}

