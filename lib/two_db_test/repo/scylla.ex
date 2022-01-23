defmodule TwoDbTest.Repo.Scylla do
  use Ecto.Repo,
    otp_app: :two_db_test,
    adapter: EctoXandra
end
