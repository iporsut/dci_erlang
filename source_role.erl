-module(source_role).
-export([transfer_to/3]).

transfer_to(_Sender,Self,[Dest,Amount]) ->
  Self ! {self(), withdraw, [Amount]},
  Dest ! {self(), deposit, [Amount]}. 
