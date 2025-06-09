# {"data" =>
#   {"id" => "4bd94adb-63f2-4585-a300-377142ae0cfb",
#    "type" => "document",
#    "attributes" =>
#     {"source_id" => "doc123",
#      "version" => 1,
#      "title" => "Test Document",
#      "metadata" => {"tags" => ["important"]},
#      "file_url" => "/docs/db048b4148491251b1cbbe460db0880f.txt",
#      "created_at" => "2025-06-09T01:06:00.370Z",
#      "updated_at" => "2025-06-09T01:06:00.392Z"}}}

module JSONAPIHelpers
  def json_response(response)
    JSON.parse(response.body)
  end

  def json_data(response)
    json_response(response)['data']
  end

  def json_attributes(response)
    data = json_data(response)
    if data.is_a?(Array)
      data.map { |item| item['attributes'] }
    else
      data['attributes']
    end
  end

  def json_id(response)
    data = json_data(response)
    if data.is_a?(Array)
      data.map { |item| item['id'] }
    else
      data['id']
    end
  end
end