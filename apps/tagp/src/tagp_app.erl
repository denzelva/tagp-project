-module(tagp_app).
-behavior(application).
 
-export([start/2]).
-export([stop/1]).
 
start(_Type, _Args) ->
    Dispatch = cowboy_router:compile(
    [
        %% {URIHost, list({URIPath, Handler, Opts})}
        {'_', % host
            [
		% static information
		{
		    "/res/[...]",	% path
		    cowboy_static,	% handler
		    {		        % options
		        priv_dir, tagp, "",
		        [{mimetypes, cow_mimetypes, all}]
		    }
		},
		% flashlights POST action
		{"/flashlights", flashlights_handler, []},
		% redOn POST action
		{"/redOn", redOn_handler, []},
		% redOff POST action
		{"/redOff", redOff_handler, []},
		% yellowOn POST action
		{"/yellowOn", yellowOn_handler, []},
		% yellowOff POST action
		{"/yellowOff", yellowOff_handler, []},
		% greenOn POST action
		{"/greenOn", greenOn_handler, []},
		% greenOff POST action
		{"/greenOff", greenOff_handler, []},
		% extra pagina's
		{"/over", over_handler, []},
		{"/statistiek", statistiek_handler, []},	
		% main page
		{'_', tagp_handler, []}
            ]
	}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    cowboy:start_http(my_http_listener, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ),

    M = code:which(index_dtl),
    io:format("module path ~p~n", [M]),
    M2 = code:which(cowboy),
    io:format("module path ~p~n", [M2]),

    tagp:start().
 
stop(_State) ->
    ok.


