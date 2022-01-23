defmodule Scylla.Migrations.AddProducts do
  def run do
    Application.ensure_all_started(:two_db_test)
    {EctoXandra, %{pid: conn}} = Ecto.Repo.Registry.lookup(TwoDbTest.Repo.Scylla)

    statements()
    |> Enum.each(&EctoXandra.Connection.execute(conn, &1, [], []))
  end

  # private

  defp statements() do
  keyspace = Application.get_env(:two_db_test, TwoDbTest.Repo.Scylla) |> Keyword.fetch!(:keyspace)

    [
      """
      CREATE KEYSPACE IF NOT EXISTS #{keyspace}
      WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'}
      AND durable_writes = true;
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.products (
        uuid uuid,
        created_at timestamp,
        title text,
        price decimal,
        inventory int,
        category text,
        availability text,
        brand text,
        PRIMARY KEY ((category, brand), uuid)
      );
      """
    ]
  end

end

Scylla.Migrations.AddProducts.run
