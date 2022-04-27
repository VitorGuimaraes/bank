defmodule Owner do
  defstruct name: nil, cpf: nil

  def register(name, cpf) do
    %__MODULE__{name: name, cpf: cpf}
  end
end
