-module(account).
-compile(export_all).

new(Balance) ->
  spawn(?MODULE,message_loop,[Balance,[]]).

message_loop(Balance,Roles) ->
  receive
    {_Sender, as,[Role]} ->
      message_loop(Balance, Roles ++ [Role]);
    {_Sender, un_as,[Role]} ->
      message_loop(Balance, Roles -- [Role]);
    {_Sender, deposit, [Arg]} ->
      message_loop(Balance + Arg, Roles);
    {_Sender, withdraw, [Arg]} ->
      message_loop(Balance - Arg, Roles);
    {Sender, balance, []} ->
      Sender ! Balance,
      message_loop(Balance, Roles);
    {_Sender, balance,[Arg]} ->
      message_loop(Arg, Roles);
    {Sender, Message,Args} ->
      deleagate_to_role(Roles, Sender, Message, Args),
      message_loop(Balance, Roles)
  end.

deleagate_to_role([],_Sender,Message,_Args) ->
  erlang:error("Not found " ++ atom_to_list(Message) ++ ".");
deleagate_to_role([Role|Rest],Sender, Message, Args) ->
  io:format("~p~n",[Role]),
  CheckMessage = lists:any( fun({Name,_Arity}) -> (Name =:= Message) end, Role:module_info(exports)),
  if 
    CheckMessage ->
      spawn(Role,Message,[Sender,self(),Args]);
    true ->
      deleagate_to_role(Rest,Sender,Message,Args)
  end.
