-module(neuron).
-export([init/3, sigmoid/1]).

init(Weights, Bias, ActFunc) ->
  spawn(fun() -> loop([], {Weights, Bias, ActFunc})end).

loop(Inputs, State) ->
  io:format("Looping ~p~n", [42]),
  receive {Input, Pid} -> AllInputs = [Input|Inputs],
                          All = length(element(1,State)),
                          case length(AllInputs) of
                            All ->
                              io:format("Found all"),
                              send_output(AllInputs, State, Pid),
                              loop([], State);
                            _ ->
                              loop(AllInputs, State)
                          end
  end.

send_output(Inputs, State, Listener) ->
  {Weights, Bias, ActFunc} = State,
  S = lists:sum(lists:zipwith(fun(A,B) -> A*B end, Inputs, Weights)) + Bias,
  io:format('Hello: ~p~n', [S]),
  Listener ! {ActFunc(S), self()}.

sigmoid(S) ->
  1/(math:exp(-S)).
