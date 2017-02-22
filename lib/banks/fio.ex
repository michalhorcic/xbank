defmodule Xbank.Fio do
  @moduledoc """
  Module for dealing with FIO bank (Czech Republic - www.fio.cz). Using their API
  documented here: https://www.fio.cz/docs/cz/API_Bankovnictvi.pdf.
  """

  alias Xbank.Transaction

  @doc """
  Receive list of transaction structs with defined properties in defined period.
  Dates have to be provided in format: YYYY-MM-DD
  """
  def get_transactions(from, to) do
    url = "https://www.fio.cz/ib_api/rest/periods/#{api_key}/#{from}/#{to}/transactions.json"
    get_response(url)
  end

  @doc """
  Receive list of transaction structs with defined properties from last call.
  """
  def get_transactions do
    url = "https://www.fio.cz/ib_api/rest/last/bGJPYcpacvyHecnuIzJU8x6QsaXjWD0EDUa5OxqlVX63RsZxJvLur17pfqWtwXiP/transactions.json"
    get_response(url)
  end

  @doc """
  GET request to defined url in API. Returns transactions in structs or error message.
  """
  defp get_response(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Poison.Parser.parse!
        |> read_values
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found"
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        "Something bad :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  @doc """
  Read needed values of transactions and create list of transaction structs.
  Number mapping is based on FIO bank API - may change in future!!!

  JSON from API should look like this:
  "transactionList": {
      "transaction": [
        {
          "column22": {
            "value": 13892294935,
            "name": "ID pohybu",
            "id": 22
          },
          "column0": {
            "value": "2017-02-08+0100",
            "name": "Datum",
            "id": 0
          },
          ...
  """
  defp read_values(json_data) do
    json_data["accountStatement"]["transactionList"]["transaction"]
    |> Enum.map fn(transaction) ->
                  %Transaction{
                    date: read_value(transaction, 0),
                    value: read_value(transaction, 1),
                    account_name: read_value(transaction, 10),
                    bank_name: read_value(transaction, 12),
                    currency: read_value(transaction, 14),
                    message: read_value(transaction, 16),
                    var_sym: read_value(transaction, 5),
                    type: read_value(transaction, 8),
                    account_number: read_value(transaction, 2),
                    comment: read_value(transaction, 25),
                    account_code: read_value(transaction, 3),
                    identifier: read_value(transaction, 7)
                  }
                end
  end

  @doc """
  Read value from json helper.
  """
  defp read_value(transaction, number) do
    transaction["column#{number}"]["value"]
  end

  @doc """
  Read api_key from configuration.
  """
  defp api_key do
    Application.get_env(:xbank, __MODULE__)[:api_key]
  end


end
