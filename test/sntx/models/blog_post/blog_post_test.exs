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
end
