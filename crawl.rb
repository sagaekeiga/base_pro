require 'nokogiri'
require 'open-uri'




##  第一部 ~wikipediaで選手名とリンクを取得~
# 選手名の取得 target wikipedia

    doc = Nokogiri::HTML(open("https://ja.wikipedia.org/wiki/%E5%BA%83%E5%B3%B6%E6%9D%B1%E6%B4%8B%E3%82%AB%E3%83%BC%E3%83%97%E3%81%AE%E9%81%B8%E6%89%8B%E4%B8%80%E8%A6%A7"))

    doc.css("table.wikitable").each_with_index do |doc, i|
        if i >= 2 && i <= 5
            doc.css('a').each do |anchor|
            #   begin
                p "名前"
                p anchor.inner_text
                
                p "URL"
                p url = "https://ja.wikipedia.org" + anchor[:href]
                
                doc = Nokogiri::HTML(open(url))
                doc.css('td > a > img').first(1).each do |img|
                    p "画像"
                    p "https:" + img[:src]
                end
                
               p "国籍と出身"
               n = 0
                doc.css('td').first(11).each_with_index do |doc, i|

                      if doc.inner_text.include?("日本") == true
                          p "国籍"
                          p doc.inner_text.lstrip
                      end
                      
                      
                      if doc.inner_text.include?("県") == true || 
                      doc.inner_text.include?("都") == true || doc.inner_text.include?("府") == true || doc.inner_text.include?("道") == true
                      p "出身"
                      p doc.inner_text
                      end
                      
                      if doc.inner_text.include?("歳") == true
                          p "誕生日"
                          p doc.inner_text.gsub(/\(.+?\)/, "").lstrip
                      end
                      
                      if doc.inner_text.include?("cm") == true && doc.inner_text.include?("kg") == true
                          p "フィジカル"
                          p doc.inner_text
                      end
                      
                      if doc.inner_text.include?("投") == true && doc.inner_text.include?("打") == true
                          p "投打"
                          p doc.inner_text
                      end
                      
                    #   if doc.inner_text.include?("歳") == false && doc.inner_text.include?("月") == true
                    #       p "初出場"
                    #       p doc.inner_text
                    #   end
                      
                      if doc.inner_text.include?("万円") == true
                          p "年棒"
                          p doc.inner_text.gsub(/\[\d+\]/, "")
                      end
                end
 
                doc.css('#mw-content-text > div').each do |doc|

                    @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                    @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                    
                    @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                    @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                    
                    @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                    # 経歴詳細
                    @gsub = @remove_episode.gsub(/\[編集\]/, "")
                end
                    #   rescue => e
                    #     puts "エラー"
                    #   end
            end
        end
    end

