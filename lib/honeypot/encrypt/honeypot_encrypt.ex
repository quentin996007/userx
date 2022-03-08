defmodule Honeypot.Encrypt do
  import Pbkdf2

  def hash_password(password) do
    hash_pwd_salt(password)
  end
end
