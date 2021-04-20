module ApplicationHelper
    def time_ago_in_words(from_time, include_seconds_or_options = {})
        distance_of_time_in_words(from_time, Time.now, include_seconds_or_options)
    end
	
	def default_meta_tags
    {
		site: 'firework.vn',
		title: 'Nền tảng giúp bạn có được công việc mơ ước',
		reverse: true,
		separator: '-',
		description: 'Firework là nền tảng chia sẻ các thông tin trong tìm kiếm việc làm như review công ty, kinh nghiệm phỏng vấn, bài test phỏng vấn,... Từ đó giúp bạn có sự chuẩn bị tốt nhất trên con đường tìm kiếm công việc mơ ước.',
		keywords: 'firework, review, interview, đánh giá, việc làm, phỏng vấn, tìm việc',
		canonical: request.original_url,
		noindex: !Rails.env.production?,
		icon: [
			{ href: image_url('logo_offical.png') },
			{ href: image_url('logo_offical.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
		],
		og: {
			site_name: 'firework.vn',
			title: 'Nền tảng review công ty, chia sẻ kinh nghiệm và hỗ trợ tìm kiếm việc làm',
			description: 'Firework là nền tảng chia sẻ các thông tin trong tìm kiếm việc làm như review công ty, kinh nghiệm phỏng vấn, bài test phỏng vấn,... Từ đó giúp bạn có sự chuẩn bị tốt nhất trên con đường tìm kiếm công việc mơ ước.', 
			type: 'website',
			url: request.original_url,
			image: image_url('logo_offical.png')
		}
    }
	end
end
