class Post < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings analysis: {
    filter: {
      spanish_stop: {
      type: "stop",
      stopwords: "_spanish_" 
      }
    },  
    analyzer: {
        custom_analyzer: {
          language: 'spanish',
          tokenizer: 'standard',
          filter: ['lowercase', 'asciifolding', 'spanish_stop']
        }
      },
    },
    index: {number_of_shards: 1 } do
      mappings dynamic: false do
        indexes :author, type: :text, analyzer: :custom_analyzer
        indexes :title, type: :text, analyzer: :custom_analyzer
        indexes :body, type: :text, analyzer: :custom_analyzer
        indexes :tags, type: :text, analyzer: :custom_analyzer
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
