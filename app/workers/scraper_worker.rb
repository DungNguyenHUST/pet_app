class ScraperWorker
    include Sidekiq::Worker

    def perform(*args)
        processing_data
    end

    def get_data_fpt
        response = HTTParty.get('http://www.fpts.com.vn/co-hoi-nghe-nghiep/')
        doc = Nokogiri::HTML(response.body)
        
        # Get block
        processing_block = doc.css("detail")

        print processing_block.first

        # link = processing_block.css("a").map { |link| link['href']}

        # print link.first

        # Create data in array
        # data = Struct.new(:title, :link)
        # processing_datas = []
        # processing_block.each do |processing_block|
        #     title = processing_block.css("a").map { |title| title['title']}
        #     link = processing_block.css("a").map { |link| link['href']}
        #     data_temp = data.new(title.first, link.first)
        #     processing_datas.push(data_temp)
        # end
        # return processing_datas
    end

    def processing_post(post_data)
        # @post = Post.new
        # @post.title = post_data.title
        # @post.link = post_data.link
        # @post.user_id = 1
    end

    def processing_data
        puts "Start scrap data..."
        get_data_fpt.first(5).each do |processing_data|
            processing_post(processing_data)
        end
        puts "End scrap data!!!"
    end
end
