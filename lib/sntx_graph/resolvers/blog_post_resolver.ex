defmodule SntxGraph.Resolvers.BlogPostResolver do
  import SntxWeb.Payload

  alias Sntx.Models.BlogPost

  def create(%{input: input}, _) do
    case BlogPost.create(input) do
      {:ok, blog_post} -> {:ok, blog_post}
      error -> mutation_error_payload(error)
    end
  end

  def update(%{input: input}, %{context: %{user: _user}}) do
    case BlogPost.update(input) do
      {:ok, blog_post} -> {:ok, blog_post}
      error -> mutation_error_payload(error)
    end
  end

  def delete(%{id: id}, %{context: %{user: _user}}) do
    case BlogPost.delete(id) do
      {:ok, blog_post} -> {:ok, blog_post}
      error -> mutation_error_payload(error)
    end
  end
end
