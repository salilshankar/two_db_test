defmodule TwoDbTestWeb.UsersView do
  use TwoDbTestWeb, :view

  def render("create.json", %{user: user}) do
    %{message: "user created in DB", user: user}
  end
end
