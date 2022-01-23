defmodule TwoDbTestWeb.UsersController do
  use TwoDbTestWeb, :controller
  alias TwoDbTest.User
  alias TwoDbTest.Repo.MySql

  def index(conn, _params) do
    users = MySql.all(User)

    render conn, "index.html", users: users
  end

  def create(conn, %{"user" => user}) do
    changeset = User.changeset(%User{}, user)

    case MySql.insert(changeset) do
      {:ok, _} ->
        render conn, user: changeset.changes
      {:error, _} ->
        render conn, %{"problem" => "User DB write failed!"}
    end
  end
end
