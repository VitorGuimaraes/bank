# Bank
Run with: `iex -S mix`


Create Account
`Account.create %Owner{name: "new_name", cpf: "cpf_number"}`

## Get all Accounts
`Account.get_accounts`

Get Account by cpf
`Account.get_account_by_cpf(cpf_number)`

Delete Account 
works in memory only, not replicated to the file
`Account.delete(Account_obj)`

Withdraw
`Account.withdraw(Account_obj, value)`

Transfer
`Account.transfer(Account_obj,Account_obj, value)`
