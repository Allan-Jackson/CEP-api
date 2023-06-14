require "test_helper"

class EnderecosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endereco = enderecos(:one)
  end

  test "should get index" do
    get enderecos_url, as: :json
    assert_response :success
  end

  test "should create endereco" do
    assert_difference("Endereco.count") do
      post enderecos_url, params: { endereco: { bairro: @endereco.bairro, cidade: @endereco.cidade, logradouro: @endereco.logradouro, uf: @endereco.uf } }, as: :json
    end

    assert_response :created
  end

  test "should show endereco" do
    get endereco_url(@endereco), as: :json
    assert_response :success
  end

  test "should update endereco" do
    patch endereco_url(@endereco), params: { endereco: { bairro: @endereco.bairro, cidade: @endereco.cidade, logradouro: @endereco.logradouro, uf: @endereco.uf } }, as: :json
    assert_response :success
  end

  test "should destroy endereco" do
    assert_difference("Endereco.count", -1) do
      delete endereco_url(@endereco), as: :json
    end

    assert_response :no_content
  end
end
