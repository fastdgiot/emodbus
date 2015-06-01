%%%-----------------------------------------------------------------------------
%%% @Copyright (C) 2015, Feng Lee <feng@emqtt.io>
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
%%% Modbus Frame.
%%%
%%% @end
%%%-----------------------------------------------------------------------------

%%------------------------------------------------------------------------------
%% Modbus Port
%%------------------------------------------------------------------------------
-define(MODBUS_PORT, 502).

%%------------------------------------------------------------------------------
%% Modbus Socket Options
%%------------------------------------------------------------------------------
-define(MODBUS_SOCKOPTS, [
	binary,
	{packet,    raw},
	{reuseaddr, true},
	{nodelay,   true}
]).

%%------------------------------------------------------------------------------
%% Modbus Function Code
%%------------------------------------------------------------------------------
-define(FUN_CODE_READ_COILS,    16#01).
-define(FUN_CODE_READ_INPUTS,   16#02).
-define(FUN_CODE_READ_HREGS,    16#03).
-define(FUN_CODE_READ_IREGS,    16#04).
-define(FUN_CODE_WRITE_COIL,    16#05).
-define(FUN_CODE_WRITE_HREG,    16#06).
-define(FUN_CODE_WRITE_COILS,   16#0f).
-define(FUN_CODE_WRITE_HREGS,   16#10).

%%------------------------------------------------------------------------------
%% Modbus MBAP Header
%%------------------------------------------------------------------------------

-define(MBAP_LENGTH, 7).

-record(mbap_header, {
        tid         :: 1..16#ffff,
        proto_id = 0,
        length      :: 1..16#ffff,
        unit_id     :: byte()
}).

-type mbap_header() :: #mbap_header{}.

%%------------------------------------------------------------------------------
%% Modbus PDUs
%%------------------------------------------------------------------------------

-record(modbus_req, {
        funcode  :: byte(),
        offset   :: 1..16#ffff,
        quantity :: 1..16#ffff,
        value    :: any()
}).

-record(modbus_resp, {
        funcode :: byte(),
        count   :: byte(),
        bytes   :: binary()
}).

-record(modbus_err, {
        funcode  :: byte(),
        errcode :: byte()
}).

-type modbus_pdu() :: #modbus_req{} | #modbus_resp{} | #modbus_err{}.

%%------------------------------------------------------------------------------
%% Modbus Frame
%%------------------------------------------------------------------------------

-record(modbus_frame, {
        hdr :: mbap_header(),
        pdu :: modbus_pdu()
}).

-type modbus_frame() :: #modbus_frame{}.

