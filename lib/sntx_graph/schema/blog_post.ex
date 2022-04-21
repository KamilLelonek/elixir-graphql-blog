defmodule SntxGraph.Schema.BlogPost do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias SntxGraph.BasicDataloader

  object :blog_post do
    field :id, :uuid4
    field :title, :string
    field :body, :string
    field :author, :user_public_account, resolve: dataloader(BasicDataloader)
  end
end
