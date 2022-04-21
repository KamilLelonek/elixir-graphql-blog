defmodule SntxGraph.Queries.BlogPostsTest do
  use SntxWeb.ConnCase

  @blog_post_query """
    query q($id: UUID4!) {
      blogPost(id: $id) {
        title
        body
        author {
          firstName
          lastName
          publicEmail
        }
      }
    }
  """

  describe "blogPost" do
    test "should not query a nonexisting BlogPost", %{conn: conn} do
      assert conn
             |> post("/graphql", %{
               "query" => @blog_post_query,
               "variables" => %{id: UUID.generate()}
             })
             |> json_response(200) == %{"data" => %{"blogPost" => nil}}
    end

    test "should query a single BlogPost", %{conn: conn} do
      %{id: id, title: title, body: body} = insert(:blog_post)

      assert %{"data" => %{"blogPost" => %{"title" => ^title, "body" => ^body}}} =
               conn
               |> post("/graphql", %{
                 "query" => @blog_post_query,
                 "variables" => %{id: id}
               })
               |> json_response(200)
    end

    test "should query a single BlogPost with an author", %{conn: conn} do
      %{id: id, author: %{first_name: first_name, last_name: last_name}} = insert(:blog_post)

      assert %{"data" => %{"blogPost" => %{"author" => %{"firstName" => ^first_name, "lastName" => ^last_name}}}} =
               conn
               |> post("/graphql", %{
                 "query" => @blog_post_query,
                 "variables" => %{id: id}
               })
               |> json_response(200)
    end
  end
end
