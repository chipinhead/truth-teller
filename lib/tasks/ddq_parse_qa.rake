namespace :ddq do
    desc "Parse the questions and answers from the file"
    task parse_qa: :environment do
        file_path = ENV['FILE']
        if not File.exist?(file_path)   
            puts "File not found: #{file_path}"
            exit 1
        end
        contents = File.read(file_path)
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        ddq_service = DdqService.new(client)
        parsed_result = ddq_service.parse_qa(contents)
        puts parsed_result
    end
end
