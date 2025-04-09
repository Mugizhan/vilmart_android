import 'package:equatable/equatable.dart';

abstract class DataFetchStatus extends Equatable {
  const DataFetchStatus();

  @override
  List<Object?> get props => [];
}

class InitialDataStatus extends DataFetchStatus {
  const InitialDataStatus();
}

class DataFetchLoading extends DataFetchStatus {
  const DataFetchLoading();
}

class DataFetchSuccess extends DataFetchStatus {
  const DataFetchSuccess();
}

class DataFetchFailed extends DataFetchStatus {
  const DataFetchFailed();
}
