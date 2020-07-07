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
        # Para type: 'fvh'in highlight se agrega  index_options: 'offsets', term_vector: 'with_positions_offsets'
        indexes :title, type: :text, analyzer: :custom_analyzer, index_options: 'offsets', term_vector: 'with_positions_offsets'
        indexes :body, type: :text, analyzer: :custom_analyzer
        # Para hacer agregation el campo debe tener el type 'keyword'
        indexes :tags, type: 'keyword', null_value: 'NULL'
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

  def self.search_fuzzy(query)
    self.search({
      query: {
        bool: {
          must: [
          {
            multi_match: {
              query: query,
              fields: [:author, :title, :body, :tags],
              fuzziness: 'AUTO'
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

  def self.search_highlight(query)
    self.search({
      query: {
        bool: {
          must: [
          {
            multi_match: {
              query: query,
              fields: [:author, :title, :body, :tags],
              fuzziness: 'AUTO'
            }
          },
          {
            match: {
              published: true
            }
          }]
        }
      },
      highlight: {
        pre_tags: ['<strong>'],
        post_tags: ['</strong>'],
        type: 'fvh',
        fragment_size: 100,
        number_of_fragments: 5,
        boundary_chars: '.,!? \t\n',
        boundary_scanner: 'sentence',
        fields: {
          title: {}
        }
      }
    })
  end

  def self.search_agregation(query)
    search = {
      query: {
        bool: {
          must: [
          {
            multi_match: {
              query: query,
              fields: [:author, :title, :body, :tags],
              fuzziness: 'AUTO'
            }
          },
          {
            match: {
              published: true
            }
          }]
        }
      },
      highlight: {
        pre_tags: ['<strong>'],
        post_tags: ['</strong>'],
        type: 'fvh',
        fragment_size: 100,
        number_of_fragments: 5,
        boundary_chars: '.,!? \t\n',
        boundary_scanner: 'sentence',
        fields: {
          title: {}
        }
      },
      aggs: {
        tags: {
          terms: { field: 'tags', size: 10 }
        }
      }
    }

    self.search(search)
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
