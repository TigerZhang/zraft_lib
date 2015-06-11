%% -------------------------------------------------------------------
%% @author Gunin Alexander <guninalexander@gmail.com>
%% Copyright (c) 2015 Gunin Alexander.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
-module(zraft_backend).
-author("dreyk").

%% API
-export([]).

-type state() :: term().
-type read_cmd()::term().
-type write_cmd()::term().
-type snapshot_fun()::fun().
-type expire_action()::term().
-type watch()::true|false.
-type watchkey()::term().


%% init backend FSM
-callback init(zraft_consensus:peer_id()) ->
    state().

%% read/query data from FSM
-callback query(read_cmd(),state()) ->
    {ok,term()} | {error,term()}.

%% write data to FSM
-callback apply_data(write_cmd(),state()) -> {term(),state()} | {term(),list(watchkey()),state()}.

%% write data to FSM
-callback apply_data(write_cmd(),zraft_consensus:csession(),state()) ->
    {term(),state()} |
    {term(),list(watchkey()),state()}.

-callback expire_session(zraft_consensus:csession(),state())->
    {ok,state()}.

%% Prepare FSM to take snapshot asycn if it's possible otherwice return function to take snapshot immediatly
-callback snapshot(state())->{sync,snapshot_fun()} | {async,snapshot_fun()}.

%% Notify that snapshot has done.
-callback snapshot_done(state())->{ok,state()}.

%% Notify that snapshot has failed.
-callback snapshot_failed(Reason::term(),state())->{ok,state()}.

%% Read data from snapshot file or directiory.
-callback install_snapshot(file:filename(),state())->{ok,state()}.
