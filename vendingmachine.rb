class VendingMachine
  def initialize
    @sum = 0
    @sales = 0
    @drink = [{name: "コーラ", price: 120, stock: 5}, {name: "水", price: 100, stock: 5},{name: "レッドブル", price: 200, stock: 5}]
    @stock_money = { ¥10: 50, ¥50: 50, ¥100: 50, ¥500: 50, ¥1000: 10}
  end

  def slot_money(money)
    @stock_money.each do |key, value|
      if key.to_s.delete('¥').to_i == money
        # ↑キーの¥を取って整数にした後に引数比較することで投入された貨幣を判別。もっと楽な書き方ができないか？
        @stock_money[key] += 1
        @sum += money
        puts "合計金額は#{@sum}円です。"
        puts @stock_money
        return
      end
    end
    puts "使用できません。返金します。"
  end

  # def slot_money(money)
  #   # お金を入れる
  #   case money
  #   when 10
  #     @stock_money[:¥10] += 1
  #   when 50
  #     @stock_money[:¥50] += 1
  #   when 100
  #     @stock_money[:¥100] += 1
  #   when 500
  #     @stock_money[:¥500] += 1
  #   when 1000
  #     @stock_money[:¥1000] += 1
  #   else
  #     puts "使用できません。返金します。"
  #     money = 0
  #   end
  #   @sum += money
  #   puts "合計金額は#{@sum}円です。"
  # end

  def buyable_drink
    #購入可能なドリンクの表示
    new_drink = []
    @drink.each do |n|
      if @sum >= n[:price] && n[:stock] > 0
        new_drink.push(n[:name])
      end
    end
    puts "購入可能な飲み物は#{new_drink.join('.')}"
  end
  
  def buy(select_drink)
    #飲み物の購入
    @drink.each do |n|
      if n[:name] == select_drink
        @change = @sum - n[:price]
        if @sum >= n[:price] && n[:stock] > 0 && compare
          @sum -= n[:price]
          n[:stock] -= 1
          @sales += n[:price]
          puts "お買い上げありがとうございます。#{n[:name]}1本お買い上げです。"
          puts "残りの金額は#{@sum}円です" 
          if rand(2) == 1
            if n[:stock] > 0
              n[:stock] -= 1
              puts "おめでとうございます。当たりです。一本追加でプレゼント。"
            else
              puts "残念。。当たりでしたが、在庫がありません。"   
            end
          else
            puts "残念。ハズレです。"
          end
        else
          puts "申し訳ありません。購入できません。"
        end
      end
    end
  end
#  リファクタリング前(あたり機能なし)
  # def buy(drink)
  #   case drink 
  #   when "coke"
  #     if @sum >= 120 && @coke[:stock] >= 1
  #       @sum = @sum - 120
  #       @coke[:stock] -= 1
  #       @sales += 120
  #       puts "お買い上げありがとうございます。コーラ1本お買い上げです。"
  #       puts "お釣りは#{@sum}円です"
  #     else
  #       puts "申し訳ありません。購入できません。"
  #     end
  #   when "water"
  #     if @sum >= 100 && @water[:stock] >= 1
  #       @sum = @sum - 100
  #       @water[:stock] -= 1
  #       @sales += 100
  #       puts "お買い上げありがとうございます。水1本お買い上げです。"
  #       puts "お釣りは#{@sum}円です"
  #     else
  #       puts "申し訳ありません。購入できません。"
  #     end
  #   when "redbull"
  #     if @sum >= 200 && @redbull[:stock] >= 1
  #       @sum = @sum - 200
  #       @redbull[:stock] -= 1
  #       @sales += 200
  #       puts "お買い上げありがとうございます。レッドブル1本お買い上げです。"
  #       puts "お釣りは#{@sum}円です"
  #     else
  #       puts "申し訳ありません。購入できません。"
  #     end
  #   end
  # end

  def current_sales
    #売上表示
    puts "売上金額は#{@sales}円です。"
  end
# ↓もう少しシンプルな書き方にできないか確認ポイント
  def return_money
    #お釣りの返却
    puts "お釣りは#{@sum}円です"
    while @sum > 0 do
      if @sum >= 1000 && @stock_money[:¥1000] >= 1
        puts"1000円返金します"
        @stock_money[:¥1000] -= 1
        @sum -= 1000
      elsif @sum >= 500 && @stock_money[:¥500] >= 1
        puts"500円返金します"
        @stock_money[:¥500] -= 1
        @sum -= 500
      elsif @sum >= 100 && @stock_money[:¥100] >= 1
        puts"100円返金します"
        @stock_money[:¥100] -= 1
        @sum -= 100
      elsif @sum >= 50 && @stock_money[:¥50] >= 1
        puts"50円返金します"
        @stock_money[:¥50] -= 1
        @sum -= 50
      elsif @sum >= 10 && @stock_money[:¥10] >= 1
        puts"10円返金します"
        @stock_money[:¥10] -= 1
        @sum -= 10
      else
        puts "お釣りが足りません"
        return
      end
    end
    puts @stock_money
  end

  def current_drink
    #在庫と価格の表示
    @drink.each do |n|
    puts "#{n[:name]}の価格は#{n[:price]}円で、在庫は#{n[:stock]}本です。"
    end
  end

  def add(name,price,stock)
    #ドリンクの種類追加
    @drink.push({name: name, price: price, stock: stock})
  end

  private
  # ↓もう少しシンプルな書き方にできないか確認ポイント
  def change
    #buyメソッドの硬貨の必要数算出
    @count10 = @count50 = @count100 = @count500 = @count1000 = 0
    while @change > 0 do
      if @change >= 1000 && @stock_money[:¥1000] >= 1
        @count1000 += 1
        @change -= 1000
      elsif @change >= 500 && @stock_money[:¥500] >= 1
        @count500 += 1
        @change -= 500
      elsif @change >= 100 && @stock_money[:¥100] >= 1
        @count100 += 1
        @change -= 100
      elsif @change >= 50 && @stock_money[:¥50] >= 1
        @count50 += 1
        @change -= 50
      elsif @change >= 10 && @stock_money[:¥10] >= 1
        @count10 += 1
        @change -= 10
      else
        return false
      end
    end
    true
  end

  def compare
    #硬貨が足りるかの確認（buyメソッドで使用）
    if change && @stock_money[:¥1000] >= @count1000 && 
      @stock_money[:¥500] >= @count500 && @stock_money[:¥100] >= @count100 && 
      @stock_money[:¥50] >= @count50 && @stock_money[:¥10] >= @count10
      true
    else
      false
    end
  end
end

# vendingmachine1 = VendingMachine.new
# vendingmachine1.add("コーヒー", 130, 5)
# vendingmachine1.slot_money(100)
# vendingmachine1.slot_money(100)
# vendingmachine1.slot_money(100)
# vendingmachine1.buy("コーヒー")
# vendingmachine1.buy("コーラ")
# vendingmachine1.return_money
# vendingmachine1.current_drink
# vendingmachine1.current_sales
# vendingmachine1.buyable_drink
