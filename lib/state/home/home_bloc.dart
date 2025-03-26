import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/doctor.dart';
import '../../models/doctor_category.dart';
import '../../repositories/doctor_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DoctorRepository doctorRepository;

  HomeBloc({required this.doctorRepository}) : super(HomeState.initial()) {
    on<FetchDoctorsAndCategories>(_fetchData);
  }

  Future<void> _fetchData(
    FetchDoctorsAndCategories event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final categories = await doctorRepository.fetchDoctorCategories();
      final doctors = await doctorRepository.fetchDoctors();

      emit(state.copyWith(
        doctorCategories: categories,
        nearbyDoctors: doctors,
        status: HomeStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: e.toString(), // ✅ Logs the exact error message
      ));
    }
  }
}
