require 'pry'
require 'csv'

class AmazonItemsearchWorker
  def initialize
  end

  def create_data
    request = Vacuum.new
    
    request.configure(
      aws_access_key_id: AMA_CONFIG['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: AMA_CONFIG['AWS_SECRET_ACCESS_KEY'],
      associate_tag: AMA_CONFIG['AWS_ASSOCIATE_TAG']
    )
# Idividual Item Search
"""    params = {
      'SearchIndex' => 'Books',
      'Keywords'=> 'Ruby',
      'ItemPage' => '4'
    }

    response = request.item_search(query: params) """

# Best Seller by BrowseNodeID
# todo: We need to find Node Ids that we are interested in.
    params = {
      'BrowseNodeId' => '165796011', # baby products 166772011, 166781011
      'ResponseGroup'=> 'TopSellers' # MostGifted | NewReleases | MostWishedFor | TopSellers
      'ItemPage' => '2'
    }

    response = request.browse_node_lookup(query: params)
    res = Nokogiri::XML response.body
    res.css('//TopItem').to_a

    binding.pry
  end
end