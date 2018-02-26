namespace :amazon do
  task :fetch => :environment do
    puts "Go Piggy!"
    
    browse_node_id = 165796011

    request = Vacuum.new
    request.associate_tag = 'gopiggybank-20'

    response = request.browse_node_lookup(
      query: {
        'BrowseNodeId' => browse_node_id
      }
    )

    doc = Nokogiri::XML response.body
    AmaBrowseNode.find_or_create_by! browse_node_name: doc.at("Name").content, browse_node_id: browse_node_id

    response = request.browse_node_lookup(
      query: {
        'BrowseNodeId' => browse_node_id,
        'ResponseGroup' => 'TopSellers'
      }
    )

    doc = Nokogiri::XML response.body
    doc.at("TopItemSet").css("TopItem").map {|item| item.at("ASIN").content}.first(5).each_with_index do |asin, index|

      response = request.item_lookup(
        query: {
          'ItemId' => asin,
          'ResponseGroup' => 'ItemAttributes,Images,Offers,PromotionSummary,SalesRank'
        }
      )
      
      # we still need to create new logic for SalesRank and PromotionSummary
      # We still need to improve and integrate AmaProductListPrice, AmaProductLanguages, and AmaItemOffers
      doc = Nokogiri::XML response.body
      r = AmaProductItem.find_by asin: asin
        #binding.pry if index == 2
        p "Processing: #{asin} with index #{index}"
        #require 'pry'; binding.pry
      if r
        p = AmaProductItem.find_by asin: asin
        p.upc = doc.at('Items').css('Item').children.at("ItemAttributes").at("UPC").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("UPC").nil?
        p.browse_node_id = browse_node_id
        p.title = doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").nil?
        p.studio = doc.at('Items').css('Item').children.at("ItemAttributes").at("Studio").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Studio").nil?
        p.parent_asin = doc.at('Items').css('Item').children.at("ParentASIN").content unless doc.at('Items').css('Item').children.at("ParentASIN").nil?
        ## this one should be nomalized
        p.ean = doc.at('Items').css('Item').children.at("ItemAttributes").at("EAN").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("EAN").nil?
        p.is_adult_product = doc.at('Items').css('Item').children.at("ItemAttributes").at("IsAdultProduct").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("IsAdultProduct").nil?
        p.brand = doc.at('Items').css('Item').children.at("ItemAttributes").at("Brand").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Brand").nil?
        p.package_qty = doc.at('Items').css('Item').children.at("ItemAttributes").at("PackageQuantity").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("PackageQuantity").nil?
        p.product_group = doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").nil?
        p.publisher = doc.at('Items').css('Item').children.at("ItemAttributes").at("Publisher").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Publisher").nil?
        p.brand_max_age = doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMaximumAge").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMaximumAge").nil?
        p.brand_min_age = doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMinimumAge").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMinimumAge").nil?
        p.model = doc.at('Items').css('Item').children.at("ItemAttributes").at("Model").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Model").nil?
        p.mpn = doc.at('Items').css('Item').children.at("ItemAttributes").at("MPN").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("MPN").nil?
        p.num_of_items = doc.at('Items').css('Item').children.at("ItemAttributes").at("NumberOfItems").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("NumberOfItems").nil?
        p.detail_page_url = doc.at('Items').css('Item').children.at("DetailPageURL").content unless doc.at('Items').css('Item').children.at("DetailPageURL").nil?
        p.sm_image_url = doc.at('Items').css('Item').children.at("SmallImage").at("URL").content unless doc.at('Items').css('Item').children.at("SmallImage").at("URL").nil?
        p.mid_image_url = doc.at('Items').css('Item').children.at("MediumImage").at("URL").content unless doc.at('Items').css('Item').children.at("MediumImage").at("URL").nil?
        p.lrg_image_url = doc.at('Items').css('Item').children.at("LargeImage").at("URL").content unless doc.at('Items').css('Item').children.at("LargeImage").at("URL").nil?
        p.publication_date = doc.at('Items').css('Item').children.at("ItemAttributes").at("PublicationDate").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("PublicationDate").nil?
        p.release_date = doc.at('Items').css('Item').children.at("ItemAttributes").at("ReleaseDate").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ReleaseDate").nil?
        p.save!

        t = AmaTopSeller.find_or_create_by asin: asin
        t.title = doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").nil?
        t.detail_page_url = doc.at('Items').css('Item').children.at("DetailPageURL").content unless doc.at('Items').css('Item').children.at("DetailPageURL").nil?
        t.product_group = doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").nil?
        t.is_active = true
        t.save!
        
        l = AmaProductListPrice.find_or_create_by asin: asin
        l.amount = doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('Amount').content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('Amount').nil?
        l.currency_code = doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('CurrencyCode').content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('CurrencyCode').nil?
        l.formated_price = doc.at('Items').css('Item').children.at("ItemAttributes").at("ListPrice").children.at("FormattedPrice").content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('FormattedPrice').nil?
        l.save!
        #get_offers(doc.at('Items').css('Item').children.at("Offers"))
      else
        p = AmaProductItem.new
        p.asin = asin
        p.upc = doc.at('Items').css('Item').children.at("ItemAttributes").at("UPC").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("UPC").nil?
        p.browse_node_id = browse_node_id
        p.title = doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").nil?
        p.studio = doc.at('Items').css('Item').children.at("ItemAttributes").at("Studio").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Studio").nil?
        p.parent_asin = doc.at('Items').css('Item').children.at("ParentASIN").content unless doc.at('Items').css('Item').children.at("ParentASIN").nil?
        p.ean = doc.at('Items').css('Item').children.at("ItemAttributes").at("EAN").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("EAN").nil?
        p.is_adult_product = doc.at('Items').css('Item').children.at("ItemAttributes").at("IsAdultProduct").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("IsAdultProduct").nil?
        p.brand = doc.at('Items').css('Item').children.at("ItemAttributes").at("Brand").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Brand").nil?
        p.package_qty = doc.at('Items').css('Item').children.at("ItemAttributes").at("PackageQuantity").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("PackageQuantity").nil?
        p.product_group = doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").nil?
        p.publisher = doc.at('Items').css('Item').children.at("ItemAttributes").at("Publisher").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Publisher").nil?
        p.brand_max_age = doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMaximumAge").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMaximumAge").nil?
        p.brand_min_age = doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMinimumAge").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ManufacturerMinimumAge").nil?
        p.model = doc.at('Items').css('Item').children.at("ItemAttributes").at("Model").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Model").nil?
        p.mpn = doc.at('Items').css('Item').children.at("ItemAttributes").at("MPN").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("MPN").nil?
        p.num_of_items = doc.at('Items').css('Item').children.at("ItemAttributes").at("NumberOfItems").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("NumberOfItems").nil?
        p.detail_page_url = doc.at('Items').css('Item').children.at("DetailPageURL").content unless doc.at('Items').css('Item').children.at("DetailPageURL").nil?
        p.sm_image_url = doc.at('Items').css('Item').children.at("SmallImage").at("URL").content unless doc.at('Items').css('Item').children.at("SmallImage").at("URL").nil?
        p.mid_image_url = doc.at('Items').css('Item').children.at("MediumImage").at("URL").content unless doc.at('Items').css('Item').children.at("MediumImage").at("URL").nil?
        p.lrg_image_url = doc.at('Items').css('Item').children.at("LargeImage").at("URL").content unless doc.at('Items').css('Item').children.at("LargeImage").at("URL").nil?
        p.publication_date = doc.at('Items').css('Item').children.at("ItemAttributes").at("PublicationDate").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("PublicationDate").nil?
        p.release_date = doc.at('Items').css('Item').children.at("ItemAttributes").at("ReleaseDate").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ReleaseDate").nil?
        p.save!

        t = AmaTopSeller.new
        t.asin = asin
        t.title = doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("Title").nil?
        t.detail_page_url = doc.at('Items').css('Item').children.at("DetailPageURL").content unless doc.at('Items').css('Item').children.at("DetailPageURL").nil?
        t.product_group = doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").content unless doc.at('Items').css('Item').children.at("ItemAttributes").at("ProductGroup").nil?
        t.is_active = true
        t.save!

        l = AmaProductListPrice.find_or_create_by asin: asin
        l.amount = doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('Amount').content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('Amount').nil?
        l.currency_code = doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('CurrencyCode').content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('CurrencyCode').nil?
        l.formated_price = doc.at('Items').css('Item').children.at("ItemAttributes").at("ListPrice").children.at("FormattedPrice").content unless doc.at('Items').css('Item').children.at("ItemAttributes").children.at("ListPrice").at('FormattedPrice').nil?
        l.save!
      end
    end

    def get_offers(offers)
      #o = Offers.new
      ##
    end
  end
end