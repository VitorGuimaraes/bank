defmodule Account do
  defstruct owner: Owner, balance: 500
  @accounts "accounts.txt"

  def create(owner) do
    case get_account_by_cpf(owner.cpf) do
      nil ->
        %__MODULE__{owner: owner}
        |> insert_account()
      _ -> {:error, "This account already exists"}
    end
  end

  def withdraw(account, value) do
    cond do
      check_balance(account.balance, value) -> {:error, "Insufficient balance"}

      true ->
        updated_account = [%Account{account | balance: account.balance - value}]

        accounts = List.delete(get_accounts(), account)
        binary = accounts ++ updated_account
        |> :erlang.term_to_binary()
        File.write!(@accounts, binary)
    end
  end

  def transfer(from, to, value) do
    cond do
      check_balance(from.balance, value) -> {:error, "Insufficient balance"}
      true ->
        updated_from = [%Account{from | balance: from.balance - value}]
        updated_to =   [%Account{to | balance: to.balance + value}]

        accounts =
          get_accounts()
          |> List.delete(from)
          |> List.delete(to)

        binary =
          accounts ++ updated_from ++ updated_to
          |> :erlang.term_to_binary()
        File.write!(@accounts, binary)
    end
  end

  # "CRUD" functions
  def delete_account(account) do
    get_accounts()
    |> List.delete(account)
  end

  def get_accounts() do
    check_file_integrity()
    {:ok, binary} = File.read(@accounts)
    binary
    |> :erlang.binary_to_term()
  end

  def insert_account(owner) do
    binary =
      [owner] ++ get_accounts()
      |> :erlang.term_to_binary()
    File.write!(@accounts, binary)
  end

  def get_account_by_cpf(cpf) do
    get_accounts()
    |> Enum.find(&(&1.owner.cpf == cpf))
  end

  # Utils functions
  def check_file_integrity() do
    case File.read(@accounts) do
      {:error, :enoent} ->
        binary = :erlang.term_to_binary([])
        File.write!(@accounts, binary)
      {:error, :eacces}  -> {:error, "missing permission for reading the file, or for searching one of the parent directories"}
      {:error, :eisdir}  -> {:error, "the named file is a directory"}
      {:error, :enotdir} -> {:error,"a component of the file name is not a directory"}
      {:error, :enomem}  -> {:error,"there is not enough memory for the contents of the file"}
      {:ok, _}           -> {:ok, "the file is ready"}
    end
  end

  def check_balance(balance, value), do: balance < value

end
