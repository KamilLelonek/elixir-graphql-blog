defmodule Sntx.Models.BlogPostTest do
  use Sntx.DataCase, async: true

  alias Sntx.Models.BlogPost

  describe "create/1" do
    test "should create a BlogPost" do
      %{id: author_id} = insert(:account)

      assert {:ok, %BlogPost{id: _}} =
               BlogPost.create(%{
                 title: "Title",
                 body: "Body",
                 author_id: author_id
               })
    end

    test "should not create a BlogPost without an Author" do
      assert {:error, changeset} =
               BlogPost.create(%{
                 title: "Title",
                 body: "Body"
               })

      assert %{author_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "should not create a BlogPost without an invalid Author" do
      assert {:error, changeset} =
               BlogPost.create(%{
                 title: "Title",
                 body: "Body",
                 author_id: UUID.generate()
               })

      assert %{author_id: ["does not exist"]} = errors_on(changeset)
    end

    test "should not create a BlogPost with missing arguments" do
      assert {:error, changeset} =
               BlogPost.create(%{
                 body: "Body"
               })

      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "update/1" do
    test "should not update a BlogPost with invalid attributes" do
      blog_post = %{id: id} = insert(:blog_post)

      assert {:error, changeset} = BlogPost.update(blog_post, %{id: id, title: nil})
      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end

    test "should update a BlogPost" do
      blog_post = %{id: id} = insert(:blog_post)
      title = "New Title"

      assert {:ok, %{id: ^id, title: ^title}} = BlogPost.update(blog_post, %{id: id, title: title})
    end
  end

  describe "delete/1" do
    test "should delete a BlogPost" do
      blog_post = %{id: id} = insert(:blog_post)

      assert [%{id: ^id}] = Repo.all(BlogPost)
      assert {:ok, %{id: ^id}} = BlogPost.delete(blog_post)
      assert Repo.all(BlogPost) == []
    end
  end
end
