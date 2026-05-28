import 'package:equatable/equatable.dart';

import 'package:TBConsult/features/journey/domain/entities/journey_entity.dart';

abstract class JourneyState extends Equatable {
  const JourneyState();

  @override
  List<Object?> get props => [];
}

class JourneyInitial extends JourneyState {
  const JourneyInitial();
}

class JourneyLoading extends JourneyState {
  const JourneyLoading();
}

class JourneyListLoaded extends JourneyState {
  final List<JourneyListItem> journeys;
  const JourneyListLoaded({required this.journeys});

  @override
  List<Object?> get props => [journeys];
}

class JourneyDetailLoaded extends JourneyState {
  final Journey journey;
  final JourneyStats? stats;
  const JourneyDetailLoaded({required this.journey, this.stats});

  @override
  List<Object?> get props => [journey, stats];
}

class JourneyCreated extends JourneyState {
  final Journey journey;
  const JourneyCreated({required this.journey});

  @override
  List<Object?> get props => [journey];
}

class JourneyResetSuccess extends JourneyState {
  final ResetJourneyResult result;
  const JourneyResetSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class JourneyDeleteSuccess extends JourneyState {
  final String message;
  const JourneyDeleteSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class JourneyError extends JourneyState {
  final String message;
  const JourneyError({required this.message});

  @override
  List<Object?> get props => [message];
}