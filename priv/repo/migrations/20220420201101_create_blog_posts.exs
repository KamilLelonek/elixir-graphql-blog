defmodule Sntx.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")

      add(:title, :string)
      add(:body, :citext)

      add :author_id, references(:blog_posts, type: :binary_id)

      timestamps()
    end
  end
end
