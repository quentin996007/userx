defmodule Honeypot.Encrypt do
  import Pbkdf2

  def hash_password(password) do
    hash_pwd_salt(password)
  end

  def verify_with_hash(password, hash) do
    verify_pass(password, hash)
  end

  def dummy_verfy() do
    no_user_verify()
  end
end
