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

  @blog_post_update """
      mutation q($input: BlogPostUpdateInput!) {
      blogPostUpdate(input: $input) {
        messages {
          message
        }
        result {
          #{@blog_post}
        }
      }
    }
  """

  @blog_post_delete """
    mutation q($id: UUID4!) {
      blogPostDelete(id: $id) {
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
             |> authorize()
             |> post("/graphql", %{
               "query" => @blog_post_create,
               "variables" => %{"input" => %{"title" => "Title", "body" => "Body", "authorId" => UUID.generate()}}
             })
             |> json_response(200) == %{
               "data" => %{"blogPostCreate" => %{"result" => nil, "messages" => [%{"message" => "does not exist"}]}}
             }
    end

    test "should create a BlogPost", %{conn: conn} do
      account = %{id: author_id} = insert(:account)

      assert %{"data" => %{"blogPostCreate" => %{"result" => %{"author" => %{}}}}} =
               conn
               |> authorize(account)
               |> post("/graphql", %{
                 "query" => @blog_post_create,
                 "variables" => %{"input" => %{"title" => "Title", "body" => "Body", "authorId" => author_id}}
               })
               |> json_response(200)
    end
  end

  describe "blogPostUpdate" do
    test "should update a BlogPost", %{conn: conn} do
      %{id: id} = insert(:blog_post)
      title = "New Title"

      assert %{"data" => %{"blogPostUpdate" => %{"result" => %{"title" => ^title}}}} =
               conn
               |> authorize()
               |> post("/graphql", %{
                 "query" => @blog_post_update,
                 "variables" => %{"input" => %{"id" => id, "title" => title}}
               })
               |> json_response(200)
    end

    test "should not update a nonexisting BlogPost", %{conn: conn} do
      assert %{"data" => %{"blogPostUpdate" => %{"result" => nil, "messages" => [%{"message" => "does not exist"}]}}} =
               conn
               |> authorize()
               |> post("/graphql", %{
                 "query" => @blog_post_update,
                 "variables" => %{"input" => %{"id" => UUID.generate()}}
               })
               |> json_response(200)
    end
  end

  describe "blogPostDelete" do
    test "should not delete any BlogPost", %{conn: conn} do
      assert conn
             |> authorize()
             |> post("/graphql", %{
               "query" => @blog_post_delete,
               "variables" => %{id: UUID.generate()}
             })
             |> json_response(200) == %{
               "data" => %{"blogPostDelete" => %{"result" => nil, "messages" => [%{"message" => "does not exist"}]}}
             }
    end

    test "should delete s BlogPost", %{conn: conn} do
      %{id: id} = insert(:blog_post)

      assert %{"data" => %{"blogPostDelete" => %{"result" => %{"author" => %{}}}}} =
               conn
               |> authorize()
               |> post("/graphql", %{
                 "query" => @blog_post_delete,
                 "variables" => %{id: id}
               })
               |> json_response(200)
    end
  end
end
