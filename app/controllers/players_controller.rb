class PlayersController < ApplicationController
    http_basic_authenticate_with name: "sagae", password: "s19930528"
    require 'nokogiri'
    require 'open-uri'


    def index
      @players = Player.all
      @q        = Player.search(params[:q])
      @results = @q.result(distinct: true)
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
                      # begin
                        @player = Player.new
                        p "名前"
                        p @player[:name] = anchor.inner_text #名前
                        p @player[:wiki] = anchor.inner_text.gsub("　", "")

    
                          doc = Nokogiri::HTML(open("#{url}"))
                          
                          # doc.css('td.rgshdphoto > img').each do |anchor|
                          #   p "画像URL"
                          #   p @player[:image] = anchor[:src]
                          # end
                          
                          doc.css('td.registerDetail').first(1).each do |phonetic|
                            p "ふりがな"
                            p @player[:phonetic] = phonetic.inner_text.gsub("　", "").gsub(" ", "").gsub(/（[a-zA-Z]++）/, "")
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
                        
                      # rescue => e
                      #   puts "エラー"
                      # end
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

                        if @player.nil?
                          p @player = Player.find_by(phonetic: anchor.inner_text)
                        end
                        
                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))

                          # doc.css('td > a > img').each do |img|
                          #     p "画像"
                          #     p @player[:image] = "https:" + img[:src]
                          # end
                       
                       doc.css('td').first(10).each_with_index do |doc, i|
                            
                              if doc.inner_text.include?("日本") == true ||  doc.inner_text.include?("アメリカ") == true ||  doc.inner_text.include?("ブラジル") == true ||  doc.inner_text.include?("ドミニカ") == true ||  doc.inner_text.include?("オーストラリア") == true || doc.inner_text.include?("台湾") == true || doc.inner_text.include?("カナダ") == true || doc.inner_text.include?("メキシコ") == true || doc.inner_text.include?("ベネズエラ") == true|| doc.inner_text.include?("キューバ") == true
                                  p "国籍"
                                  p @player[:country] = doc.inner_text.lstrip.gsub(/\[\d+\]/, "") if doc.inner_text.length <= 10
                              end
                              
                              
                              if doc.inner_text.include?("県") == true || 
                              doc.inner_text.include?("都") == true || doc.inner_text.include?("府") == true || doc.inner_text.include?("道") == true || doc.inner_text.include?("州") == true
                              p "出身"
                              p @player[:graduate] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("歳") == true
                                  p "誕生日"
                                  p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("cm") == true && doc.inner_text.include?("kg") == true
                                  p "フィジカル"
                                  p @player[:physical] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end

                              if doc.inner_text.include?("ドラフト") == true
                                  p "ドラフト"
                                  p @player[:draft] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("投") == true && doc.inner_text.include?("打") == true
                                  p "投打"
                                  p @player[:style] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("万") == true || doc.inner_text.include?("億") == true || doc.inner_text.include?("兆") == true || doc.inner_text.include?("$") == true || doc.inner_text.include?("000") == true
                                  p "年棒"
                                  p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                              @player[:career_detail] = @player[:career_detail].gsub(/編集\]/, "")
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

                        if @player.nil?
                          p @player = Player.find_by(phonetic: anchor.inner_text)
                        end
                        
                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))
                          
                          doc.css('td').first(10).each_with_index do |doc, i|
                            
                              if doc.inner_text.include?("日本") == true ||  doc.inner_text.include?("アメリカ") == true ||  doc.inner_text.include?("ブラジル") == true ||  doc.inner_text.include?("ドミニカ") == true ||  doc.inner_text.include?("オーストラリア") == true || doc.inner_text.include?("台湾") == true || doc.inner_text.include?("カナダ") == true || doc.inner_text.include?("メキシコ") == true || doc.inner_text.include?("ベネズエラ") == true|| doc.inner_text.include?("キューバ") == true
                                  p "国籍"
                                  p @player[:country] = doc.inner_text.lstrip.gsub(/\[\d+\]/, "") if doc.inner_text.length <= 10
                              end
                              
                              
                              if doc.inner_text.include?("県") == true || 
                              doc.inner_text.include?("都") == true || doc.inner_text.include?("府") == true || doc.inner_text.include?("道") == true || doc.inner_text.include?("州") == true
                              p "出身"
                              p @player[:graduate] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("歳") == true
                                  p "誕生日"
                                  p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("cm") == true && doc.inner_text.include?("kg") == true
                                  p "フィジカル"
                                  p @player[:physical] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end

                              if doc.inner_text.include?("ドラフト") == true
                                  p "ドラフト"
                                  p @player[:draft] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("投") == true && doc.inner_text.include?("打") == true
                                  p "投打"
                                  p @player[:style] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("万") == true || doc.inner_text.include?("億") == true || doc.inner_text.include?("兆") == true || doc.inner_text.include?("$") == true || doc.inner_text.include?("000") == true
                                  p "年棒"
                                  p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                              @player[:career_detail] = @player[:career_detail].gsub(/編集\]/, "")
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

                        if @player.nil?
                          p @player = Player.find_by(phonetic: anchor.inner_text)
                        end
                        
                        if !@player.nil?
                          p "URL"
                          p url = "https://ja.wikipedia.org" + anchor[:href]
                          
                          doc = Nokogiri::HTML(open(url))
                          
                          doc.css('td').first(10).each_with_index do |doc, i|
                            
                              if doc.inner_text.include?("日本") == true ||  doc.inner_text.include?("アメリカ") == true ||  doc.inner_text.include?("ブラジル") == true ||  doc.inner_text.include?("ドミニカ") == true ||  doc.inner_text.include?("オーストラリア") == true || doc.inner_text.include?("台湾") == true || doc.inner_text.include?("カナダ") == true || doc.inner_text.include?("メキシコ") == true || doc.inner_text.include?("ベネズエラ") == true|| doc.inner_text.include?("キューバ") == true
                                  p "国籍"
                                  p @player[:country] = doc.inner_text.lstrip.gsub(/\[\d+\]/, "") if doc.inner_text.length <= 10
                              end
                              
                              
                              if doc.inner_text.include?("県") == true || 
                              doc.inner_text.include?("都") == true || doc.inner_text.include?("府") == true || doc.inner_text.include?("道") == true || doc.inner_text.include?("州") == true
                              p "出身"
                              p @player[:graduate] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("歳") == true
                                  p "誕生日"
                                  p @player[:birth] = doc.inner_text.gsub(/\(.+?\)/, "").lstrip.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("cm") == true && doc.inner_text.include?("kg") == true
                                  p "フィジカル"
                                  p @player[:physical] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end

                              if doc.inner_text.include?("ドラフト") == true
                                  p "ドラフト"
                                  p @player[:draft] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("投") == true && doc.inner_text.include?("打") == true
                                  p "投打"
                                  p @player[:style] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                              
                              if doc.inner_text.include?("万") == true || doc.inner_text.include?("億") == true || doc.inner_text.include?("兆") == true || doc.inner_text.include?("$") == true || doc.inner_text.include?("000") == true
                                  p "年棒"
                                  p @player[:bar] = doc.inner_text.gsub(/\[\d+\]/, "")
                              end
                          end
           
                          doc.css('#mw-content-text > div').each do |doc|
          
                              @keireki_start = doc.xpath('//*[@id="mw-content-text"]/div/h2[1]').inner_text
                              @start_doc = doc.inner_text.index("#{@keireki_start}") + 6
                              
                              @keireki_end = doc.xpath('//*[@id="mw-content-text"]/div/h2[2]').inner_text
                              @end_doc = doc.inner_text.index("#{@keireki_end}") - 1
                              
                              @remove_episode = doc.inner_text.slice(@start_doc..@end_doc).gsub(/\[\d+\]/, "")
                              # 経歴詳細
                              @player[:career_detail] = @remove_episode.gsub(/\[編集\]/, "")
                              @player[:career_detail] = @player[:career_detail].gsub(/編集\]/, "")
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
