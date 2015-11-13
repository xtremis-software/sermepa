#
# Adds some extra methods to any active record model to make the integration easier
#
module SermepaWebTpv
  module Persistence
    module ActiveRecord
      def transaction_number
        generate_transaction_number! if transaction.new_record?

        transaction.send(transaction_number_attribute)
      end

      def transaction_amount
        transaction.send(transaction_model_amount_attribute)
      end

      def generate_transaction_number!
        number = Time.now.strftime('%y%m%d%H%M%S')
        transaction.update_attribute(transaction_number_attribute, number)
      end
    end
  end
end