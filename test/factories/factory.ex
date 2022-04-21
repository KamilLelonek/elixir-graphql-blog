defmodule Sntx.Factory do
  use ExMachina.Ecto, repo: Sntx.Repo

  alias Sntx.Models.{BlogPost, User.Account}

  def blog_post_factory do
    %BlogPost{
      title: Faker.Lorem.word(),
      body: Faker.Lorem.paragraph(),
      author: build(:account)
    }
  end

  def account_factory do
    %Account{
      email: Faker.Internet.email(),
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name()
    }
  end
end
