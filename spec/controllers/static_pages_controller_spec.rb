require "rails_helper"
require 'support/controller_helpers'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end

RSpec.describe StaticPagesController, type: :controller do
  it "renders to home" do
    get :home
    expect(response).to render_template("home")
  end
  it "renders to about" do
    get :about
    expect(response).to render_template("about")
  end
  it "renders to contact" do
    get :contact
    expect(response).to render_template("contact")
  end
  it "renders to help" do
    get :help
    expect(response).to render_template("help")
  end
end

