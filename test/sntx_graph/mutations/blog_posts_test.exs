defmodule SntxGraph.Mutations.BlogPostsTest do
  use SntxWeb.ConnCase, async: true

  @blog_post """
    title
    body
    author {
      firstName
      lastName
      publicEmail
    }
  """

  @blog_post_create """
    mutation q($input: BlogPostCreateInput!) {
      blogPostCreate(input: $input) {
        messages {
          message
        }
        result {
          #{@blog_post}
        }
      }
    }
  """

  describe "blogPostCreate" do
    test "should not create a BlogPost with an invalid Author ID", %{conn: conn} do
      assert conn
             |> post("/graphql", %{
               "query" => @blog_post_create,
               "variables" => %{"input" => %{"title" => "Title", "body" => "Body", "authorId" => UUID.generate()}}
             })
             |> json_response(200) == %{
               "data" => %{"blogPostCreate" => %{"result" => nil, "messages" => [%{"message" => "does not exist"}]}}
             }
    end

    test "should create a BlogPost", %{conn: conn} do
      %{id: author_id} = insert(:account)

      assert %{"data" => %{"blogPostCreate" => %{"result" => %{"author" => %{}}}}} =
               conn
               |> post("/graphql", %{
                 "query" => @blog_post_create,
                 "variables" => %{"input" => %{"title" => "Title", "body" => "Body", "authorId" => author_id}}
               })
               |> json_response(200)
    end
  end
end
