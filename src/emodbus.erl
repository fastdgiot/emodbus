%%%-----------------------------------------------------------------------------
%%% Copyright (c) 2015 Feng Lee <feng@emqtt.io>, All Rights Reserved.
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%-----------------------------------------------------------------------------
%%% @doc
%%% emodbus main module
%%%
%%% @end
%%%-----------------------------------------------------------------------------
-module(emodbus).

-include("emodbus.hrl").

-export([open_listeners/1]).

-type listener() :: {atom(), inet:port_number(), [esockd:option()]}. 

%%------------------------------------------------------------------------------
%% @doc Open Listeners
%% @end
%%------------------------------------------------------------------------------
-spec open_listeners([listener()]) -> any().
open_listeners(Listeners) when is_list(Listeners) ->
    [open_listener(Listener) || Listener <- Listeners].

open_listener({modbus, Port, Options}) ->
    MFArgs = {emodbus_server, start_link, [application:get_env(emodbus, frame, [])]},
    esockd:open(modbus, Port, merge_sockopts(Options) , MFArgs).
    
merge_sockopts(Options) ->
    SockOpts = merge_opts(?MODBUS_SOCKOPTS,
                          proplists:get_value(sockopts, Options, [])),
    merge_opts(Options, [{sockopts, SockOpts}]).

%%------------------------------------------------------------------------------
%% @doc Merge Options
%% @end
%%------------------------------------------------------------------------------
merge_opts(Defaults, Options) ->
    lists:foldl(
        fun({Opt, Val}, Acc) ->
                case lists:keymember(Opt, 1, Acc) of
                    true ->
                        lists:keyreplace(Opt, 1, Acc, {Opt, Val});
                    false ->
                        [{Opt, Val}|Acc]
                end;
            (Opt, Acc) ->
                case lists:member(Opt, Acc) of
                    true -> Acc;
                    false -> [Opt | Acc]
                end
        end, Defaults, Options).


