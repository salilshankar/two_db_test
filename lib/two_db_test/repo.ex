defmodule TwoDbTest.Repo do
  use Ecto.Repo,
    otp_app: :two_db_test,
    adapter: Ecto.Adapters.Postgres
end
