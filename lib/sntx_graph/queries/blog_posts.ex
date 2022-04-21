defmodule SntxGraph.Queries.BlogPosts do
  use Absinthe.Schema.Notation

  alias Sntx.Repo
  alias Sntx.Models.BlogPost

  object :blog_post_queries do
    field :blog_posts, list_of(:blog_post) do
      resolve(fn _, _ ->
        {:ok, Repo.all(BlogPost)}
      end)
    end

    field :blog_post, :blog_post do
      arg :id, :uuid4

      resolve(fn args, _ ->
        {:ok, Repo.get(BlogPost, args.id)}
      end)
    end
  end
end
