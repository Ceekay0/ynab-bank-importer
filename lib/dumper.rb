# Uses methods that need to be implemented by each dumper -
# this is to enforce consitency.
class Dumper
  def self.get_dumper(name)
    case name
    when :bbva
      Dumper::Bbva
    when :fints
      Dumper::Fints
    when :n26
      Dumper::N26
    else
      raise "Dumper \"#{name}\" not supported."
    end
  end

  # rubocop:disable Metrics/MethodLength
  def to_ynab_transaction(transaction)
    # Debug
    # File.write('./trans.txt', JSON.pretty_generate(transaction), mode: 'a')
    return nil if date(transaction) > Date.today
    ::TransactionCreator.call(
      account_id: account_id,
      date: date(transaction),
      payee_name: payee_name(transaction),
      payee_iban: payee_iban(transaction),
      category_name: category_name(transaction),
      category_id: category_id(transaction),
      memo: memo(transaction),
      amount: amount(transaction),
      is_withdrawal: withdrawal?(transaction),
      ## import_id: SecureRandom.hex + "01"
      import_id: import_id(transaction)
    )
  end
  # rubocop:enable Metrics/MethodLength

  def category_name(_transaction)
    nil
  end

  def category_id(_transaction)
    nil
  end

  def normalize_iban(iban)
    iban.delete(' ')
  end
end
