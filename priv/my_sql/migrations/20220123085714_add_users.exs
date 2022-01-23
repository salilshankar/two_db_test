defmodule TwoDbTest.Repo.MySql.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :firstname, :string
      add :lastname, :string

      timestamps()
    end
  end
end
