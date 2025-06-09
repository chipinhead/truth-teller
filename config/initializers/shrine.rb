require "shrine"
require "shrine/storage/file_system"

Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("storage", prefix: "cache"),
  store: Shrine::Storage::FileSystem.new("storage", prefix: "docs")
}