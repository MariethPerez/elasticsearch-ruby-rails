class Post < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings do
        mappings dynamic: false do
          indexes :author, type: :text
          indexes :title, type: :text, analyzer: :spanish
          indexes :body, type: :text, analyzer: :spanish
          indexes :tags, type: :text, analyzer: :spanish
          indexes :published, type: :boolean
        end
      end

      def self.search_published(query)
        self.search({
          query: {
            bool: {
              must: [
              {
                multi_match: {
                  query: query,
                  fields: [:author, :title, :body, :tags]
                }
              },
              {
                match: {
                  published: true
                }
              }]
            }
          }
        })
      end

      def self.indexation
        # Delete the previous articles index in Elasticsearch
        self.__elasticsearch__.client.indices.delete index: self.index_name rescue nil
    
        # Create the new index with the new mapping
        self.__elasticsearch__.client.indices.create \
          index: self.index_name,
          body: { settings: self.settings.to_hash, mappings: self.mappings.to_hash}
    
        # Index all article records from the DB to Elasticsearch
        self.import
      end
end
