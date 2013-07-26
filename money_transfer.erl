-module(money_transfer).

-export([execute/3]).


execute(SourceAccount, DestinationAccount, Amount) ->
  transfer_to(SourceAccount, DestinationAccount, Amount).

transfer_to(SourceAccount, DestinationAccount, Amount) ->
  SourceAccount ! {self(), withdraw, Amount},
  DestinationAccount ! {self(), deposit, Amount}.
