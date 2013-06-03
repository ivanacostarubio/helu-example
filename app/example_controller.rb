class ExampleController < UIViewController

  def viewDidLoad
    @helu = Helu.new("loosing_weight_10")

    @helu.fail = fail_iap
    @helu.winning = successful_iap

    puts "Calling Apple for the In-App Purchase. This will take a while."
    @helu.buy
  end

  def buy_product

  end

  def fail_iap
    lambda { |transaction| puts "something went wrong" ; puts transaction.error.inspect }
  end

  def successful_iap
    lambda { |transaction| puts "We created the IAP :-)" ; puts transaction.inspect}
  end

end