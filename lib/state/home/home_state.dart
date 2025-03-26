part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<DoctorCategory> doctorCategories; // ✅ Fixed import
  final List<Doctor> nearbyDoctors;

  const HomeState({
    required this.status,
    required this.doctorCategories,
    required this.nearbyDoctors,
  });

  factory HomeState.initial() {
    return const HomeState(
      status: HomeStatus.initial,
      doctorCategories: [],
      nearbyDoctors: [],
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    List<DoctorCategory>? doctorCategories, // ✅ Fixed import
    List<Doctor>? nearbyDoctors,
  }) {
    return HomeState(
      status: status ?? this.status,
      doctorCategories: doctorCategories ?? this.doctorCategories,
      nearbyDoctors: nearbyDoctors ?? this.nearbyDoctors,
    );
  }

  @override
  List<Object> get props => [status, doctorCategories, nearbyDoctors];
}
