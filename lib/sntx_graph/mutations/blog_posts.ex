defmodule SntxGraph.Mutations.BlogPosts do
  use Absinthe.Schema.Notation

  alias SntxGraph.Middleware.Authorize
  alias SntxGraph.Resolvers.BlogPostResolver

  object :blog_post_mutations do
    field :blog_post_create, :blog_post_payload do
      arg :input, non_null(:blog_post_create_input)

      middleware(Authorize)

      resolve(&BlogPostResolver.create/2)
    end

    field :blog_post_update, :blog_post_payload do
      arg :input, non_null(:blog_post_update_input)

      middleware(Authorize)

      resolve(&BlogPostResolver.update/2)
    end

    field :blog_post_delete, :blog_post_payload do
      arg :id, :uuid4

      middleware(Authorize)

      resolve(&BlogPostResolver.delete/2)
    end
  end
end
