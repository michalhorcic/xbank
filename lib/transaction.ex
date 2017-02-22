defmodule Xbank.Transaction do
  @moduledoc """
  Definition of bank transaction properties. Useful for all bank modules.
  """
  
  defstruct date: nil,
            value: nil,
            account_name: nil,
            bank_name: nil,
            currency: nil,
            message: nil,
            var_sym: nil,
            type: nil,
            account_number: nil,
            comment: nil,
            account_code: nil,
            identifier: nil
end
