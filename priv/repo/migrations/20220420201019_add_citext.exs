defmodule Sntx.Repo.Migrations.AddCitext do
  use Ecto.Migration

  def change do
    execute(
      "CREATE EXTENSION IF NOT EXISTS \"citext\"",
      "DROP EXTENSION IF EXISTS \"citext\""
    )
  end
end
