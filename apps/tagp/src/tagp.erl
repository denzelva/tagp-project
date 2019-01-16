-module(tagp).

-export([start/0, stop/0, reset/0, flashlights/0, redOn/0, redOff/0, yellowOn/0, yellowOff/0, greenOn/0, greenOff/0]).

-export([init/0, loop/1, get/0, ledsinit/0, flash/2]).

start() ->
    Pid = spawn(?MODULE, init, []),
    register(tagp, Pid),
    {ok, Pid}.

stop() ->
    tagp ! {stop}.

init() ->
    loop(0),
    {ok, []}.

ledsinit() ->
    L0 = gpio:init(17, out),
    L1 = gpio:init(27, out),
    L2 = gpio:init(22, out),
    {L0, L1, L2}.
    
get() ->
    tagp ! {get, self()},
    receive
       Result -> Result
    end.

reset() ->
    tagp ! {reset},
    ok.

flashlights() ->
    Leds = ledsinit(),
    flash(Leds, 10).

flash(Leds, Times) when Times > 0 ->
    gpio:write(element(1, Leds), 1),
    timer:sleep(200),
    gpio:write(element(1, Leds), 0),
    gpio:write(element(2, Leds), 1),
    timer:sleep(200),
    gpio:write(element(2, Leds), 0),
    gpio:write(element(3, Leds), 1),
    timer:sleep(200),
    gpio:write(element(3, Leds), 0),

    flash(Leds, Times-1);

flash(Leds, Times) when Times =< 0 ->
    true.

greenOn() ->
    Leds = ledsinit(),
    gpio:write(element(1, Leds), 1).

greenOff() ->
    Leds = ledsinit(),
    gpio:write(element(1, Leds), 0).

yellowOn() ->
    Leds = ledsinit(),
    gpio:write(element(2, Leds), 1).

yellowOff() ->
    Leds = ledsinit(),
    gpio:write(element(2, Leds), 0).

redOn() ->
    Leds = ledsinit(),
    gpio:write(element(3, Leds), 1).

redOff() ->
    Leds = ledsinit(),
    gpio:write(element(3, Leds), 0).

loop(Teller) ->
   receive
      {reset} ->
	 loop(0);
      {flashlights} ->
	 Leds = ledsinit(),
         flash(Leds, 10);
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
