defmodule TwoDbTestWeb.ProductsView do
  use TwoDbTestWeb, :view

  def render("create.json", %{product: product}) do
    %{message: "product created in DB", product: product}
  end

  def render("create.json", %{"problem" => problem_message}) do
    %{error: problem_message}
  end
end
