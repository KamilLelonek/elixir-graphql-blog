defmodule SntxGraph.Resolvers.BlogPostResolver do
  import SntxWeb.Payload

  alias Sntx.{Models.BlogPost, Repo}

  def create(%{input: input}, _) do
    case BlogPost.create(input) do
      {:ok, blog_post} -> {:ok, blog_post}
      error -> mutation_error_payload(error)
    end
  end

  def update(%{input: %{id: id} = input}, %{context: %{user: %{id: author_id}}}) do
    case Repo.get(BlogPost, id) do
      %BlogPost{author_id: ^author_id} = blog_post -> BlogPost.update(blog_post, input)
      %BlogPost{} -> {:error, "Current User is not BlogPost owner"}
      nil -> {:error, "does not exist"}
      error -> mutation_error_payload(error)
    end
  end

  def delete(%{id: id}, %{context: %{user: %{id: author_id}}}) do
    case Repo.get(BlogPost, id) do
      %BlogPost{author_id: ^author_id} = blog_post -> BlogPost.delete(blog_post)
      %BlogPost{} -> {:error, "Current User is not BlogPost owner"}
      nil -> {:error, "does not exist"}
      error -> mutation_error_payload(error)
    end
  end
end
