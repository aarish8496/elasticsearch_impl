module Searchable
  extend ActiveSupport::Concern

  included do
    include  Elasticsearch::Model
    include  Elasticsearch::Model::Callbacks

    mapping do
      # Mapping goes here
      indexes :artist, type: :text
      indexes :title, type: :text
      indexes :genre, type: :text
      indexes :lyrics, type: :text
    end

    def self.search(query)
      # build and run search
      param = {
        query: {
          bool: {
            should: [
              { match: { title: query } },
              { match: { artist: { query: query, boost: 5 } } },
              { match: { lyrics: query } }
            ]
          }
        },
         highlight: { fields: { title: {}, artist: {}, lyrics: {} } }
      }
      self.__elasticsearch__.search(param)
    end
  end
end
=begin
for querying multiple fields

  params = {
    query:{
      multi_match: {
        query: query,
        fields: [ :title, :artist, :lyrics ]
      }
    }
  }

for bool query (combination of multiple queries) using boost, fuzziness

      param = {
        query: {
          bool:{
            should:[
              { match: { title: query } },
              { match: { artist: {query: query, boost: 5, fuzziness: "AUTO" } } },
              { match: { lyrics: query } },
            ],
          }
        },
         # highlight: { fields: { title: {}, artist: {}, lyrics: {} } }
      }

Run and Test:   curl "http://localhost:3000/songs?query=genesis"

=end
