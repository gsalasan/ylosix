class ProductsController < Frontend::CommonController
  before_action :set_product

  def show
  end

  def get_template_variables(template)
    super

    @variables['product'] = @product
  end

  def add_to_shopping_cart
    if customer_signed_in?
      sc = current_customer.shopping_cart
      sc ||= ShoppingCart.new
      sc.add_product(@product)

      current_customer.shopping_cart = sc
      current_customer.save

      # TODO save Shopping Cart in cache
    end

    redirect_to :customers_shopping_carts
  end

  def delete_from_shopping_cart
    if customer_signed_in?
      sc = current_customer.shopping_cart

      unless sc.blank?
        sc.remove_product(@product)
        current_customer.shopping_cart = sc
        current_customer.save

        # TODO save Shopping Cart in cache
      end
    end

    redirect_to :customers_shopping_carts
  end

  private

  def set_product
    @product = nil
    @category = nil

    if !params[:slug].blank? || !params[:id].blank?
      attributes = { enabled: true }
      attributes[:slug] = params[:slug] unless params[:slug].blank?
      attributes[:id] = params[:id] unless params[:id].blank?

      @product = Product.find_by(attributes)

      @category = @product.categories.first
    end
  end
end
