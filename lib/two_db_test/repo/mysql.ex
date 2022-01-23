defmodule TwoDbTest.Repo.MySql do
  use Ecto.Repo,
    otp_app: :two_db_test,
    adapter: Ecto.Adapters.MyXQL
end
