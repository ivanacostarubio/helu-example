class ExampleController < UIViewController
  PRODUCT_ID = 'milk'

  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor

    @name = UILabel.alloc.init.tap do |l|
      l.text = PRODUCT_ID
      l.sizeToFit
      l.frame = [
        [10, 10],
        [self.view.frame.size.width - 20, l.frame.size.height]
      ]
    end
    self.view.addSubview(@name)

    @description = UILabel.alloc.init.tap do |l|
      l.text = "to be determined"
      l.sizeToFit
      l.frame = [
        [10, 60],
        [self.view.frame.size.width - 20, l.frame.size.height]
      ]
    end
    self.view.addSubview(@description)

    @price = UILabel.alloc.init.tap do |l|
      l.text = "$0.99"
      l.sizeToFit
      l.frame = [
        [10, 110],
        [self.view.frame.size.width - 20, l.frame.size.height]
      ]
    end
    self.view.addSubview(@price)

    @buy = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
      b.setTitle("Buy", forState: UIControlStateNormal)
      b.sizeToFit
      b.frame = [
        [10, 165],
        [self.view.frame.size.width - 20, b.frame.size.height]
      ]
      b.addTarget(self, action: "buy_it", forControlEvents:UIControlEventTouchUpInside)
    end
    self.view.addSubview(@buy)

    refresh_product_info
  end

  def refresh_product_info
    unless Helu.respond_to?(:fetch_product_info)
      puts "Outdated helu without fetch support! Please upgrade."
      return
    end

    Dispatch::Queue.concurrent.async do
      puts "Going to fetch data from AppStore..."
      pi = Helu.fetch_product_info(PRODUCT_ID)
      if prod = pi[PRODUCT_ID]
        puts "Have got valid info for my product from AppleStore:"
        p prod
        Dispatch::Queue.main.sync do
          puts "Changing labels..."
          @name.text = prod[:title]
          @description.text = prod[:description]
          @price.text = prod[:price_str]
        end
      else
        puts "Haven't got valid info for my product from AppleStore :-("
        Dispatch::Queue.main.sync do
          @description.text = "AppStore doesn't know this product"
        end
      end
    end
  end

  def buy_it
    Dispatch::Queue.main.async do
      @helu = Helu.new(PRODUCT_ID)

      @helu.fail = fail_iap
      @helu.winning = successful_iap

      puts "Calling Apple for the In-App Purchase. This will take a while."
      @helu.buy
    end
  end

  def fail_iap
    lambda { |transaction| puts "something went wrong" ; puts transaction.error.inspect }
  end

  def successful_iap
    lambda { |transaction| puts "We created the IAP :-)" ; puts transaction.inspect}
  end

end
