class PlayersController < ApplicationController
    http_basic_authenticate_with name: "sagae", password: "s19930528"
    require 'nokogiri'
    require 'open-uri'


    def index
      @players = Player.all
    end
    
    def new
        @player = Player.new
    end
    
    def create
     @player = Player.new(player_params)
     if @player.save
       redirect_to root_path
     else
       render 'laughters/new'
     end
    end
    
    def edit
      @player = Player.find(params[:id])
    end
    
    def destroy
      @player = Player.find(params[:id])
        if @player.delete
         flash[:success] = "deleted"
        end
        redirect_to root_path
    end
    
    def show
      @player = Player.find(params[:id])
    end
    
    def update
        @player = Player.find(params[:id])
        @player.update(player_params)
        redirect_to root_path
    end
    
    ## target 名鑑
    def players_meikan
      @team_url = ["c", "g", "db", "t", "s", "d", "f", "h", "m", "l", "e", "bs"]
        @team_url.each do |team_url|
          doc = Nokogiri::HTML(open("http://npb.jp/bis/teams/rst_#{team_url}.html"))
            doc.css(" td.rosterRegister").each do |doc|
                doc.css('a').each do |anchor|
                      begin
                        @player = Player.new
                        p "名前"
                        p @player[:name] = anchor.inner_text #名前
                        p @player[:wiki] = anchor.inner_text.gsub("　", "")
                        p "画像"
                        p url = "http://npb.jp" + anchor[:href] #URL先
    
    
                          doc = Nokogiri::HTML(open("#{url}"))
                          
                          doc.css('td.rgshdphoto > img').each do |anchor|
                            p "画像URL"
                            p @player[:image] = anchor[:src]
                          end
                          
                          doc.css('td.registerDetail').first(1).each do |phonetic|
                            p "ふりがな"
                            p @player[:phonetic] = phonetic.inner_text
                          end
                          
                          doc.css('td.registerDetail').first(3).each do |career_over|
                            p "経歴"
                            p @player[:career_over] = career_over.inner_text
                          end
                          
                          doc.css('td.registerDetail').first(4).each do |draft|
                            p "ドラフト"
                            p @player[:draft] = draft.inner_text
                          end
                          
                          
                          doc.css('td.registerTeam').each do |team|
                            p "球団"
                            p @player[:team] = team.inner_text
                          end
                          
                          doc.css('td.registerPosition').each do |position|
                            p "ポジション"
                            p @player[:position] = position.inner_text
                          end
    
                          @player.save!
                        
                      rescue => e
                        puts "エラー"
                      end
                end
            end
         end
        redirect_to root_path
    end

    ## target wiki ロッテ ヤクルト 中日 楽天 西武 横浜 日本ハム 阪神
    def players_wiki1
      @team_url = ["yGWq5L", "yLeqvB", "hEd4Wd", "NYUttm", "kS4Lv3", "ZM7LZN", "GLL2Bp", "fPbiVJ"]
        @team_url.each do |team_url|
          doc = Nokogiri::HTML(open("https://goo.gl/#{team_url}"))
          doc.css("table.wikitable").each_with_index do |doc, i|
              if i >= 2 && i <= 5
                  doc.css('a').each do |anchor|
                      begin
                        p "名前"
                        p @player = Player.find_by(wiki: anchor.inner_text)


                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))
                          
                          doc.css('td').first(10).each_with_index do |doc, i|
                              p "国籍"
                              p @player[:country] = doc.inner_text.lstrip if i == 1
                              p "出身"
                              p @player[:graduate] = doc.inner_text if i == 2
                              p "誕生日"
                              p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip if i == 3
                              p "フィジカル"
                              p @player[:physical] = doc.inner_text if i == 4
                              p "投打"
                              p @player[:style] = doc.inner_text if i == 5
                              p "初出場"
                              p @player[:first] = doc.inner_text if i == 8
                              p "年棒"
                              p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "") if i == 9
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                          end
                          @player.save!
                        end
                      rescue => e
                        puts "エラー"
                      end
                  end
              end
          end
        end
        redirect_to root_path
    end 

    ## target wiki 広島 オリックス
    def players_wiki2
      @team_url = ["yCgQgn", "uUph4H"]
        @team_url.each do |team_url|
          doc = Nokogiri::HTML(open("https://goo.gl/#{team_url}"))
          doc.css("table.wikitable").each_with_index do |doc, i|
              if i >= 3 && i <= 6
                  doc.css('a').each do |anchor|
                      begin
                        p "名前"
                        p @player = Player.find_by(wiki: anchor.inner_text)
                        
                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))
                          
                          doc.css('td').first(10).each_with_index do |doc, i|
                              p "国籍"
                              p @player[:country] = doc.inner_text.lstrip if i == 1
                              p "出身"
                              p @player[:graduate] = doc.inner_text if i == 2
                              p "誕生日"
                              p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip if i == 3
                              p "フィジカル"
                              p @player[:physical] = doc.inner_text if i == 4
                              p "投打"
                              p @player[:style] = doc.inner_text if i == 5
                              p "初出場"
                              p @player[:first] = doc.inner_text if i == 8
                              p "年棒"
                              p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "") if i == 9
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                          end
                          @player.save!
                        end
                      rescue => e
                        puts "エラー"
                      end
                  end
              end
          end
        end
        redirect_to root_path
    end
    
    ## target wiki 巨人 ホークス
    def players_wiki3
      @team_url = ["J5CtJe", "pxwytq"]
        @team_url.each do |team_url|
          doc = Nokogiri::HTML(open("https://goo.gl/#{team_url}"))
          doc.css("table.wikitable").each_with_index do |doc, i|
              if i >= 4 && i <= 7
                  doc.css('a').each do |anchor|
                      begin
                        p "名前"
                        p @player = Player.find_by(wiki: anchor.inner_text)
                        
                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))
                          
                          doc.css('td').first(10).each_with_index do |doc, i|
                              p "国籍"
                              p @player[:country] = doc.inner_text.lstrip if i == 1
                              p "出身"
                              p @player[:graduate] = doc.inner_text if i == 2
                              p "誕生日"
                              p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip if i == 3
                              p "フィジカル"
                              p @player[:physical] = doc.inner_text if i == 4
                              p "投打"
                              p @player[:style] = doc.inner_text if i == 5
                              p "初出場"
                              p @player[:first] = doc.inner_text if i == 8
                              p "年棒"
                              p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "") if i == 9
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                          end
                          @player.save!
                        end
                      rescue => e
                        puts "エラー"
                      end
                  end
              end
          end
        end
        redirect_to root_path
    end 
    
      private
      
        def player_params
          params.require(:player).permit(:name, :image, :country, :graduate, :birth, :height, :weight, :style, :position, :draft, :bar, :career, :phonetic, :team)
        end
end
