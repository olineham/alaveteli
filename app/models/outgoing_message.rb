# models/outgoing_message.rb:
# A message, associated with a request, from the user of the site to somebody
# else. e.g. An initial request for information, or a complaint.
#
# Copyright (c) 2007 UK Citizens Online Democracy. All rights reserved.
# Email: francis@mysociety.org; WWW: http://www.mysociety.org/
#
# $Id: outgoing_message.rb,v 1.10 2007-11-09 02:11:36 francis Exp $

class OutgoingMessage < ActiveRecord::Base
    belongs_to :info_request
    validates_presence_of :info_request

    validates_presence_of :body, :message => "^Please enter your letter requesting information."
    validates_inclusion_of :status, :in => ['ready', 'sent', 'failed']

    validates_inclusion_of :message_type, :in => ['initial_request'] #, 'complaint']

    # Set default letter
    def after_initialize
        if self.body.nil?
            self.body = "Dear Sir or Madam,\n\n\n\nYours faithfully,\n\n"
        end
    end

    # Check have edited letter
    def validate
        if self.body =~ /\ADear Sir or Madam,\s+Yours faithfully,\s+/
            errors.add(:body, "^Please enter your letter requesting information")
        end
        if self.body =~ /Yours faithfully,\s+\Z/
            errors.add(:body, '^Please sign at the bottom with your name, or alter the "Yours faithfully" signature')
        end
    end

    # Deliver outgoing message
    # Note: You can test this from script/console with, say:
    # InfoRequest.find(1).outgoing_messages[0].send_message
    def send_message
        if self.message_type == 'initial_request'
            if self.status == 'ready'
                RequestMailer.deliver_initial_request(self.info_request, self)
                self.sent_at = Time.now
                self.status = 'sent'
                self.save!
            elsif self.status == 'sent'
                raise "Message id #{self.id} has already been sent"
            else
                raise "Message id #{self.id} not in state for send_message"
            end
        else
            raise "Message id #{self.id} has type '#{self.message_type}' which send_message can't handle"
        end

    end
end

