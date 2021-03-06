require 'fastlane/action'
require_relative '../helper/send_e_mail_helper'
require 'net/smtp'

module Fastlane
  module Actions
    class SendEMailAction < Action
      def self.send_emails(stmpserver_address,sender_address,password,recipients,subject,message_body)
        recipients.each do |recipient_address|
          message_header = ''
          message_header << "From: <#{sender_address}>\r\n"
          message_header << "To: <#{recipient_address}>\r\n"
          message_header << "Subject: #{subject}\r\n"
          message_header << 'Date: ' + Time.now.to_s + "\r\n"
          message_header << 'MIME-Version: 1.0' + "\r\n"
          message_header << 'Content-type: text/html;charset=utf-8' + "\r\n"
          message_header << 'X-Priority:3;X-MSMail-Priority:Normal;X-Mailer:Microsoft Outlook Express 6.00.2900.2869;X-MimeOLE:Produced By Microsoft MimeOLE V6.00.2900.2869;ReturnReceipt:1' + "\r\n"
          message = message_header + "\r\n" + message_body.encode('utf-8') + "\r\n"
          Net::SMTP.start(stmpserver_address, 25, 'yeah.net', sender_address, password, :plain) do |smtp|
            begin
              smtp.send_message(message, sender_address, recipient_address)
            rescue
              raise Exception => e
              print 'Exception occured: ' + e
            end
          end
        end
      end

      def self.run(params)
        send_emails(
          params[:stmp_server],
          params[:user_name],
          params[:password],
          params[:recipients],
          params[:subject],
          params[:message_body]
        )
        # UI.message("The testdemo plugin is working!")
      end

      def self.description
        'a tool to sendmail'
      end

      def self.authors
        ['huangjia']
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        'send email by stmp'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :stmp_server,
                                       env_name: 'SEND_E_MAIL_SERVER',
                                       description: 'servername',
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :user_name,
                                       env_name: 'SEND_E_MAIL_USERNAME',
                                       description: 'USERNAME',
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :password,
                                       env_name: 'SEND_E_MAIL_PASSWORD',
                                       description: 'password',
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :recipients,
                                       env_name: 'SEND_E_MAIL_RECIPIENTS',
                                       description: 'recipients',
                                       optional: false,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :subject,
                                       env_name: 'SEND_E_MAIL_SUBJECT',
                                       description: 'subject',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :message_body,
                                       env_name: 'SEND_E_MAIL_MESSAGE_BODY',
                                       description: 'message_body',
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include? platform
      end
    end
  end
end
