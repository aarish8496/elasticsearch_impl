require "csv"

class Song < ApplicationRecord
  include Searchable

  def self.import_csv!
    # filepath = File.expand_path("~/Downloads/Music Dataset Lyrics and Metadata.csv")
    filepath = "//home/rails/Music Dataset Lyrics and Metadata from 1950 to 2019/Music Dataset Lyrics and Metadata from 1950 to 2019/tcc_ceds_music.csv"
    res = CSV.parse(File.read(filepath), headers: true)
    res.each_with_index do |s, ind|
      Song.create!(
        artist: s["artist_name"],
        title: s["track_name"],
        genre: s["genre"],
        lyrics: s["lyrics"]
      )
    end
  end
end
