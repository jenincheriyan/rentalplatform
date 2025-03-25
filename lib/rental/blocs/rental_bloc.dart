import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_platform/rental/repository/rental-repository.dart';
import 'rental_event.dart';
import 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository rentalRepository;

  RentalBloc({required this.rentalRepository}) : super(RentalLoading()) {
    on<RentalLoadAll>(_onRentalLoadAll);
    on<RentalLoadMyProperties>(_onRentalLoadMyProperties);
    on<RentalCreate>(_onRentalCreate);
    on<RentalUpdate>(_onRentalUpdate);
    on<RentalDelete>(_onRentalDelete);
  }

  Future<void> _onRentalLoadAll(
      RentalLoadAll event, Emitter<RentalState> emit) async {
    emit(RentalLoading());
    try {
      final rentals = await rentalRepository.viewAll();
      emit(RentalOperationSuccess(rentals));
    } catch (_) {
      emit(RentalOperationFailure());
    }
  }

  Future<void> _onRentalLoadMyProperties(
      RentalLoadMyProperties event, Emitter<RentalState> emit) async {
    emit(RentalLoading());
    try {
      final rentals = await rentalRepository.viewMyProperties();
      emit(RentalOperationSuccess(rentals));
    } catch (_) {
      emit(RentalOperationFailure());
    }
  }

  Future<void> _onRentalCreate(
      RentalCreate event, Emitter<RentalState> emit) async {
    try {
      await rentalRepository.create(event.rental);
      final rentals = await rentalRepository.viewAll();
      emit(RentalOperationSuccess(rentals));
    } catch (_) {
      emit(RentalOperationFailure());
    }
  }

  Future<void> _onRentalUpdate(
      RentalUpdate event, Emitter<RentalState> emit) async {
    try {
      await rentalRepository.update(event.id, event.rental);
      final rentals = await rentalRepository.viewAll();
      emit(RentalOperationSuccess(rentals));
    } catch (_) {
      emit(RentalOperationFailure());
    }
  }

  Future<void> _onRentalDelete(
      RentalDelete event, Emitter<RentalState> emit) async {
    try {
      await rentalRepository.delete(event.id);
      final rentals = await rentalRepository.viewAll();
      emit(RentalOperationSuccess(rentals));
    } catch (_) {
      emit(RentalOperationFailure());
    }
  }
}

