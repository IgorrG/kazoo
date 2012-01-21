%%%-------------------------------------------------------------------
%%% @author James Aimonetti <>
%%% @copyright (C) 2012, James Aimonetti
%%% @doc
%%%
%%% @end
%%% Created : 11 Jan 2012 by James Aimonetti <>
%%%-------------------------------------------------------------------
-module(cf_set).


-export([handle/2]).

-include("../callflow.hrl").

-spec handle/2 :: (wh_json:json_object(), #cf_call{}) -> 'ok'.
handle(Data, #cf_call{call_kvs=KVs}=Call) ->
    cf_exe:continue(Call#cf_call{call_kvs=merge(Data, KVs)}).

-spec merge/2 :: (wh_json:json_object(), orddict:orddict()) -> orddict:orddict().
merge(New, Old) ->
    lists:foldl(fun({K,NewV}, AccDict) ->
                        ?LOG("adding ~p : ~p", [K, NewV]),
                        orddict:update(K, fun(_) -> NewV end, NewV, AccDict)
                end, Old, wh_json:to_proplist(New)).
