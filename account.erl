-module(account).
-compile(export_all).

-record(account,{balance = 0}).

new(AccountRecord) ->
  spawn(?MODULE,message_loop,[AccountRecord]).

message_loop(AccountRecord) ->
  receive
    {_Sender, deposit, Amount} ->

      #account { balance = Balance } = AccountRecord,
      message_loop(#account {balance = Balance + Amount});

    {_Sender, withdraw, Amount} ->

      #account { balance = Balance } = AccountRecord,
      message_loop(#account {balance = Balance - Amount});

    {Sender, balance} ->

      #account { balance = Balance } = AccountRecord,
      Sender ! Balance,
      message_loop(AccountRecord)

  end.
