defmodule TwoDbTest.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID
  alias EctoXandra.Types.Timestamp

  @primary_key false
  schema "products" do
        field :uuid, UUID, autogenerate: true, primary_key: true
        field :created_at, Timestamp, autogenerate: true
        field :title, :string
        field :price, :decimal
        field :inventory, :integer
        field :category, :string, primary_key: true
        field :availability, :string
        field :brand, :string, primary_key: true
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uuid, :title, :category, :brand, :created_at, :price, :inventory, :availability])
    |> validate_required([:title])
  end
end
