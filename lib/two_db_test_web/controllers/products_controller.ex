defmodule TwoDbTestWeb.ProductsController do
  use TwoDbTestWeb, :controller
  alias TwoDbTest.Product
  alias TwoDbTest.Repo.Scylla

  def index(conn, _params) do
    products = Scylla.all(Product)

    render conn, "index.html", products: products
  end

  def create(conn, %{"product" => product}) do
    changeset = Product.changeset(%Product{}, product)


    case Scylla.insert(changeset) do
      {:ok, _} ->
        render conn, product: changeset.changes
      {:error, _} ->
        render conn, %{"problem" => "Product DB write failed!"}
    end
  end
end
