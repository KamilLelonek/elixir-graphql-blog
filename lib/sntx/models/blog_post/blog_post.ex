defmodule Sntx.Models.BlogPost do
  use Sntx.Models

  alias Sntx.Models.User.Account

  schema "blog_posts" do
    field :title, :string
    field :body, :string

    belongs_to :author, Account

    timestamps()
  end
end
