class MailServerLog::DeliveryStatusSerializer
  def self.load(value)
    return unless value
    delivery_status_class.new(value.to_sym)
  end

  def self.dump(value)
    return unless value
    # Both delivery status classes return the MTA status Symbol as a String:
    value.to_s
  end

  private

  def self.delivery_status_class
    mta = AlaveteliConfiguration.mta_log_type.to_sym
    case mta
    when :exim
      MailServerLog::EximDeliveryStatus
    when :postfix
      MailServerLog::PostfixDeliveryStatus
    else
      raise "Unexpected MTA type: #{ mta }"
    end
  end
end
