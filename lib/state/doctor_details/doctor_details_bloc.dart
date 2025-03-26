import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/doctor.dart';
import '../../repositories/doctor_repository.dart';
import 'doctor_details_event.dart';
import 'doctor_details_state.dart';

class DoctorDetailsBloc extends Bloc<DoctorDetailsEvent, DoctorDetailsState> {
  final DoctorRepository doctorRepository;

  DoctorDetailsBloc({required this.doctorRepository})
      : super(const DoctorDetailsState()) {
    on<LoadDoctorDetailsEvent>(_onLoadDoctorDetails);
  }

  Future<void> _onLoadDoctorDetails(
      LoadDoctorDetailsEvent event, Emitter<DoctorDetailsState> emit) async {
    emit(state.copyWith(status: DoctorDetailsStatus.loading));

    try {
      final Doctor? doctor = doctorRepository.fetchDoctorById(event.doctorId);
      
      if (doctor != null) {
        emit(state.copyWith(status: DoctorDetailsStatus.loaded, doctor: doctor));
      } else {
        emit(state.copyWith(status: DoctorDetailsStatus.error, errorMessage: "Doctor not found"));
      }
    } catch (e) {
      emit(state.copyWith(status: DoctorDetailsStatus.error, errorMessage: e.toString()));
    }
  }
}
