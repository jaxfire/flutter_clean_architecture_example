import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

// TODO: Override get props in sub classes? See how ResoCoder does it later on in the course.
// @override
// List<Object> get props => [name];

// He suggested the following, but it doesn't compile...
// If the subclasses have some properties, they'll get passed to this constructor
// so that Equatable can perform value comparison.
// Failure([List properties = const <dynamic>[]]) : super(properties);
