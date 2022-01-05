import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_clean_arch_learning/injection_container.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: BlocProvider<NumberTriviaBloc>(
          create: (context) => sl<NumberTriviaBloc>(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  // Top half
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                      if (state is Empty) {
                        return MessageDisplay(message: 'Start searching');
                      } else if (state is Loading) {
                        return LoadingWidget();
                      } else if (state is Loaded) {
                        return TriviaDisplay(numberTrivia: state.trivia);
                      } else if (state is Error) {
                        return MessageDisplay(message: state.message);
                      } else {
                        return Text('STATE NOT HANDLED YET');
                      }
                      // We're going to also check for the other states
                    },
                  ),
                  SizedBox(height: 20),
                  // Bottom half
                  TriviaControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
