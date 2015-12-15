%%% @doc NewsItems repository
-module(canillita_newsitems_repo).

-export([fetch/1, fetch/2, fetch_since/1]).

-define(TABLE, canillita_newsitems).

%% @doc returns the newsitem identified with the given id.
-spec fetch(Id::canillita_newsitems:id()) -> notfound | sumo_rest_doc:entity().
fetch(Id) ->
  sumo:find(?TABLE, Id).

%% @doc Returns the newsitem that matches the given
%%      newspaper_name and id (if any).
-spec fetch( NewspaperName::canillita_newspapers:name()
           , Id::canillita_newsitems:id()
           ) -> notfound | sumo_rest_doc:entity().
fetch(NewspaperName, Id) ->
  Conditions = [{id, Id}, {newspaper_name, NewspaperName}],
  sumo:find_one(?TABLE, Conditions).

%% @doc returns all the news after the given event-id or all the news
%%      if not event-id provided.
-spec fetch_since(CreatedAt::calendar:datetime()  | undefined) ->
  [sumo_rest_doc:entity()].
fetch_since(undefined) ->
  fetch_all();
fetch_since(LastEventId) ->
  #{created_at := CreatedAt} = fetch(LastEventId),
  fetch_all(CreatedAt).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% internal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% @doc returns all the newsitems stored so far.
-spec fetch_all() -> [sumo_rest_doc:entity()].
fetch_all() ->
  sumo:find_all(?TABLE).

%% @doc returns all elements created after the given datetime.
-spec fetch_all(CreatedAt::calendar:datetime()) -> [sumo_rest_doc:entity()].
fetch_all(CreatedAt) ->
  Conditions = [{created_at, '>', CreatedAt}],
  sumo:find_by(?TABLE, Conditions).
