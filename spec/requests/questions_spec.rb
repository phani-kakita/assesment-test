require 'rails_helper'
require 'csv'
RSpec.describe 'Questions', type: :request do
#     include Rack::Test::Methods
#   include ActionDispatch::TestProcess
    let!(:question1) { FactoryBot.create(:question) }
  describe 'GET /index' do
    let!(:question1) { FactoryBot.create(:question) }
    before do
        @user = FactoryBot.create(:user)
        @token = JsonWebToken.encode(user_id: @user.id)
      FactoryBot.create(:question)
      get '/api/v1/questions',as: :json, headers: {"Authorization" => "Bearer #{@token}"} 
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      
      before do
        # let!(:question1) { FactoryBot.create(:question) }
      @user = FactoryBot.create(:user)
      @token = JsonWebToken.encode(user_id: @user.id)
        post '/api/v1/questions', params:
                          { 
                            name: "test5",
                            description: "test6"
                          },as: :json, headers: {"Authorization" => "Bearer #{@token}"}  
      end

      it 'returns the name' do
        expect(json['name']).to eq("test5")
      end

      it 'returns the description' do
        expect(json['description']).to eq("test6")
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      before do
        @user = FactoryBot.create(:user)
        @token = JsonWebToken.encode(user_id: @user.id)
        post '/api/v1/questions', params:
                          { 
                            name: '',
                            description: ''
                          },as: :json, headers: {"Authorization" => "Bearer #{@token}"}  
      end

      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /import' do
  
    let(:file) { fixture_file_upload(file_fixture('spec/fixtures/test.csv')) }
    before do
        @user = FactoryBot.create(:user)
        @token = JsonWebToken.encode(user_id: @user.id)
      FactoryBot.create(:question)
      params = { "file" => Rack::Test::UploadedFile.new('spec/fixtures/test.csv', 'text/csv', true) }
      post '/api/v1/questions/import',params:params, as: :json, headers: {"Authorization" => "Bearer #{@token}"} 
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

end