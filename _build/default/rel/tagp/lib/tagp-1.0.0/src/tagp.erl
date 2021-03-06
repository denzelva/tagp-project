-module(teller).

-export([start/0, stop/0, reset/0]).

-export([init/0, loop/1, get/0]).

start() ->
    Pid = spawn(?MODULE, init, []),
    register(teller, Pid),
    {ok, Pid}.

stop() ->
    teller ! {stop}.

init() ->
    loop(0),
    {ok, []}.

get() ->
    teller ! {get, self()},
    receive
       Result -> Result
    end.

reset() ->
    teller ! {reset},
    ok.

loop(Teller) ->
   receive
      {reset} ->
	 loop(0);
      {get, From} ->
         From ! Teller,
         loop(Teller);
      {stop} ->
         ok;
      _ ->
         loop(Teller)
   after
      1000 ->
         loop(Teller + 1)
   end.
