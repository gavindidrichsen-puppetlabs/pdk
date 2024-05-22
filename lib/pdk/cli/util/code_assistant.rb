module PDK
  module CLI
    module Util
      class CodeAssistant
        require 'openai'
        require 'pdk/logger'
        def initialize(prompt, options = {})
          # instantiate the client
          @client ||= client
          # send the request, and return the response
          send_request(prompt)
        end 
        attr_accessor :client

        def client
          api_key = ENV.fetch('OPENAI_API_KEY', nil)
          begin
            @client = OpenAI::Client.new(
              access_token: api_key,
              log_errors: true
            )
          rescue OpenAI::Error => e
            PDK.logger.error format("Error: #{e}")
          end
        end

        def send_request(prompt)
          response = @client.chat(
            parameters: {
                model: 'gpt-3.5-turbo', # Required.
                messages: [{ role: "user", content: prompt}],
                temperature: 0.7,
            })
          PDK.logger.info("Code Assistant Hint: #{response.dig('choices', 0, 'message', 'content')}")
        end
      end
    end
  end
end
