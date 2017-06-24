require 'nokogiri'
require 'open-uri'




##  第一部 ~wikipediaで選手名とリンクを取得~
# 選手名の取得 target wikipedia

    doc = Nokogiri::HTML(open("https://goo.gl/T2HDEv"))

    doc.css("table.wikitable").each_with_index do |doc, i|
        if i >= 2 && i <= 5
            doc.css('a').each do |anchor|
                p "名前"
                p anchor.inner_text
                
                p "URL"
                p url = "https://ja.wikipedia.org" + anchor[:href]
                
                doc = Nokogiri::HTML(open(url))
                doc.css('td > a > img').each do |img|
                    p "画像"
                    p "https:" + img[:src]
                end
                
               p "国籍と出身"
               n = 0
                doc.css('td').first(10).each_with_index do |doc, i|
                    p @country = doc.inner_text.lstrip if i == 1
                    p @graduate = doc.inner_text if i == 2
                    p @birth = doc.inner_text.gsub(/\(.+?\)/, "").lstrip if i == 3
                    p @physical = doc.inner_text if i == 4
                    p @style = doc.inner_text if i == 5
                    p @first = doc.inner_text if i == 8
                    p @bar = doc.inner_text.gsub(/\[\d+\]/, "") if i == 9
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
            end
        end
    end

