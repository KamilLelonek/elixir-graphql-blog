defmodule Sntx.Models.BlogPost do
  use Sntx.Models

  import Ecto.Changeset

  alias Sntx.{Models.User.Account, Repo}

  @attrs ~w(title body author_id)a

  schema "blog_posts" do
    field :title, :string
    field :body, :string

    belongs_to :author, Account

    timestamps()
  end

  def create(attrs) do
    %__MODULE__{}
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> foreign_key_constraint(:author_id)
    |> Repo.insert()
  end

  def delete(blog_post), do: Repo.delete(blog_post)

  def update(attrs) do
    case Repo.get(__MODULE__, attrs[:id]) do
      %__MODULE__{} = blog_post -> update(blog_post, attrs)
      nil -> {:error, "does not exist"}
    end
  end

  defp update(blog_post, attrs) do
    blog_post
    |> cast(attrs, @attrs ++ [:id])
    |> validate_required(@attrs ++ [:id])
    |> foreign_key_constraint(:author_id)
    |> Repo.update()
  end
end
