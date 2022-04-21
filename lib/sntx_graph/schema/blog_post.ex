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

  input_object :blog_post_create_input do
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :author_id, non_null(:uuid4)
  end
end
