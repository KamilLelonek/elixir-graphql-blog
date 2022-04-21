defmodule SntxGraph.Mutations.BlogPosts do
  use Absinthe.Schema.Notation

  import SntxWeb.Payload

  alias Sntx.Models.BlogPost
  alias SntxGraph.Middleware.Authorize

  object :blog_post_mutations do
    field :blog_post_create, :blog_post_payload do
      arg :input, non_null(:blog_post_create_input)

      middleware(Authorize)

      resolve(fn %{input: input}, _ ->
        case BlogPost.create(input) do
          {:ok, blog_post} -> {:ok, blog_post}
          error -> mutation_error_payload(error)
        end
      end)
    end

    field :blog_post_update, :blog_post_payload do
      arg :input, non_null(:blog_post_update_input)

      middleware(Authorize)

      resolve(fn %{input: input}, _ ->
        case BlogPost.update(input) do
          {:ok, blog_post} -> {:ok, blog_post}
          error -> mutation_error_payload(error)
        end
      end)
    end

    field :blog_post_delete, :blog_post_payload do
      arg :id, :uuid4

      middleware(Authorize)

      resolve(fn %{id: id}, _ ->
        case BlogPost.delete(id) do
          {:ok, blog_post} -> {:ok, blog_post}
          error -> mutation_error_payload(error)
        end
      end)
    end
  end
end
