defmodule SntxGraph.Queries.BlogPostsTest do
  use SntxWeb.ConnCase

  @blog_post """
    title
    body
    author {
      firstName
      lastName
      publicEmail
    }
  """

  @blog_post_query """
    query q($id: UUID4!) {
      blogPost(id: $id) {
        #{@blog_post}
      }
    }
  """

  @blog_posts_query """
    query {
      blogPosts {
        #{@blog_post}
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

  describe "blogPosts" do
    test "should not query any BlogPost", %{conn: conn} do
      assert conn
             |> post("/graphql", %{"query" => @blog_posts_query})
             |> json_response(200) == %{"data" => %{"blogPosts" => []}}
    end

    test "should query all BlogPosts", %{conn: conn} do
      insert(:blog_post)
      insert(:blog_post)

      assert %{"data" => %{"blogPosts" => [%{"author" => _, "body" => _, "title" => _}, _]}} =
               conn
               |> post("/graphql", %{"query" => @blog_posts_query})
               |> json_response(200)
    end
  end
end
